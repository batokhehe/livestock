import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../../core/widgets/search_bar_card.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/text_field_with_inner_counter.dart';
import '../../../receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../../user/providers/user_provider.dart';
import '../../data/model/employee_model.dart';
import '../../providers/attendance_provider.dart';

class EmployeeOvernightPage extends ConsumerStatefulWidget {
  const EmployeeOvernightPage({super.key});

  @override
  ConsumerState<EmployeeOvernightPage> createState() =>
      _EmployeeAttendancePageState();
}

class _EmployeeAttendancePageState
    extends ConsumerState<EmployeeOvernightPage> {
  final TextEditingController noteCtrl = TextEditingController();
  final TextEditingController noteDetailCtrl = TextEditingController();

  @override
  void dispose() {
    noteCtrl.dispose();
    noteDetailCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(employeeListProvider);
      ref.read(attendanceStatusProvider.notifier).reset();
      ref.read(selectedEmployeeIdProvider.notifier).state = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(employeeListProvider, (prev, next) {
      next.whenOrNull(
        data: (employees) {
          ref
              .read(attendanceStatusProvider.notifier)
              .initFromEmployees(employees);
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        title: Text("Catat Menginap", style: AppTypography.largeBoldBlack),
        backgroundColor: AppColors.white,
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [_attendanceInfo(context)]),
            ),
          ),
          _submitButton(),
        ],
      ),
    );
  }

  // ================= INFORMASI ABSENSI =================
  Widget _attendanceInfo(BuildContext context) {
    // final selectedDate = ref.watch(attendanceDateProvider);
    final selectedEmployeeId = ref.watch(selectedEmployeeIdProvider);
    final employeesAsync = ref.watch(employeeListProvider);

    String employeeLabel = "Pilih karyawan";

    employeesAsync.whenData((employees) {
      final selected = employees
          .where((e) => e.id == selectedEmployeeId)
          .toList();
      if (selected.isNotEmpty) employeeLabel = selected.first.name;
    });

    final dateText = DateFormat('dd MMM yyyy', 'id_ID').format(DateTime.now());

    return SectionCard(
      title: 'Informasi Absensi',
      children: [
        Dropdowns(
          label: 'Tanggal Absensi',
          value: dateText,
          icon: AppImages.icCalendarSearch,
          enabled: true,
        ),
        const SizedBox(height: 12),

        SelectField(
          label: "Karyawan",
          hint: employeeLabel,
          icon: AppImages.icUserTag,
          onTap: () => _showEmployeePicker(context),
        ),

        const SizedBox(height: 12),
        TextFieldWithInnerCounter(
          label: 'Catatan',
          subLabel: '(Optional)',
          hint: 'Masukkan Catatan',
          maxLength: 80,
          controller: noteCtrl,
        ),
      ],
    );
  }

  Widget _submitButton() {
    final selectedId = ref.watch(selectedEmployeeIdProvider);

    final isEnabled = selectedId != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled ? AppColors.primary : AppColors.greyBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isEnabled ? _submitAttendance : null,
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }

  // ================= BOTTOM SHEET PICKER =================
  void _showEmployeePicker(BuildContext context) {
    final employeesAsync = ref.read(employeeListProvider);

    // reset search tiap buka
    ref.read(employeeSearchProvider.notifier).state = '';

    final searchCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: AppColors.greyBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return employeesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              "Gagal memuat data karyawan\n$error",
              textAlign: TextAlign.center,
              style: AppTypography.smallNormalGrey,
            ),
          ),
          data: (employees) {
            return Consumer(
              builder: (context, ref, _) {
                final selectedId = ref.watch(selectedEmployeeIdProvider);
                final keyword = ref.watch(employeeSearchProvider);

                final filtered = employees.where((e) {
                  return e.name.toLowerCase().contains(keyword.toLowerCase());
                }).toList();

                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // ===== HEADER =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Karyawan",
                            style: AppTypography.mediumBoldBlack,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),

                      // ===== SEARCH =====
                      SearchBarCard(
                        hint: "Cari karyawan",
                        controller: searchCtrl,
                        onChanged: (value) {
                          ref.read(employeeSearchProvider.notifier).state =
                              value;
                        },
                        onClear: () {
                          searchCtrl.clear();
                          ref.read(employeeSearchProvider.notifier).state = '';
                        },
                      ),

                      const SizedBox(height: 12),

                      // ===== LIST =====
                      Expanded(
                        child: filtered.isEmpty
                            ? Center(
                                child: Text(
                                  "Karyawan tidak ditemukan",
                                  style: AppTypography.smallNormalGrey,
                                ),
                              )
                            : ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (_, i) {
                                  final e = filtered[i];
                                  final isSelected = e.id == selectedId;

                                  return GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(
                                            selectedEmployeeIdProvider.notifier,
                                          )
                                          .state = e
                                          .id;
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.fieldBorder,
                                        ),
                                        color: isSelected
                                            ? AppColors.primary.withOpacity(
                                                0.08,
                                              )
                                            : Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${e.name} • ${e.phone}',
                                            style: isSelected
                                                ? AppTypography.smallBoldPrimary
                                                : AppTypography.smallBoldBlack,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedId != null
                                ? AppColors.primary
                                : AppColors.greyBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: selectedId == null
                              ? null
                              : () => Navigator.pop(context),
                          child: Text(
                            "Simpan",
                            style: AppTypography.mediumBoldWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ).whenComplete(() {
      searchCtrl.dispose();
    });
  }

  Future<void> _submitAttendance() async {
    // final selectedDate = ref.read(attendanceDateProvider);
    final employeesAsync = ref.read(employeeListProvider);

    // if (selectedDate == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Tanggal absensi wajib diisi")),
    //   );
    //   return;
    // }

    final isConfirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ConfirmationBottomSheet(
        header: "Konfirmasi Pencatatan Nginap",
        title: "Simpan Data Nginap?",
        subTitle: "Pastikan data Nginap sudah benar sebelum disimpan.",
        saveText: "Simpan Sekarang",
      ),
    );

    if (isConfirmed != true) return;

    final selectedId = ref.read(selectedEmployeeIdProvider);
    if (selectedId == null) return;

    final employees = await ref.read(employeeListProvider.future);
    final employee = employees.firstWhere((e) => e.id == selectedId);

    final payload = _buildAttendancePayload([employee]);
    await ref.read(attendanceApiProvider).submitAttendance(payload);

    if (!mounted) return;
    context.pushReplacement('/history-attendance');
  }

  Map<String, dynamic> _buildAttendancePayload(List<Employee> employees) {
    // final selectedDate = ref.read(attendanceDateProvider);
    final statuses = ref.read(attendanceStatusProvider);
    final farmId = ref.watch(userFarmProvider);

    return {
      // "trans_date": DateFormat('yyyy-MM-dd').format(selectedDate!),
      "trans_date": todayDate,
      "additional_information": noteCtrl.text,
      "farm_location_id": farmId,
      "record_by": 1,
      "type": "overnight",
      "details": employees.map((e) {
        final isPresent = statuses[e.id] ?? true;
        return {
          "employee_id": e.id,
          "farm_location_id": farmId,
          "status": isPresent ? "present" : "absent",
          "note": isPresent ? "Hadir" : "Tidak hadir",
        };
      }).toList(),
    };
  }
}
