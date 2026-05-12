import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/custom_date_picker_sheet.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';
import 'package:livestock/features/user/providers/user_provider.dart';

import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/core/widgets/farm_location_paginated_bottom_sheet.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../data/model/employee_model.dart';
import '../../providers/attendance_provider.dart';

class EmployeeAttendancePage extends ConsumerStatefulWidget {
  const EmployeeAttendancePage({super.key});

  @override
  ConsumerState<EmployeeAttendancePage> createState() =>
      _EmployeeAttendancePageState();
}

class _EmployeeAttendancePageState
    extends ConsumerState<EmployeeAttendancePage> {
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
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(attendanceInitProvider);
    ref.watch(attendanceLogIdProvider);
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        title: Text("Lakukan Absen", style: AppTypography.largeBoldBlack),
        backgroundColor: AppColors.white,
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _attendanceInfo(context),
                  const SizedBox(height: 16),
                  _employeeInfo(),
                ],
              ),
            ),
          ),

          /// ===== BUTTON SUBMIT =====
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitAttendance,
                  child: Text(
                    "Selanjutnya",
                    style: AppTypography.mediumBoldWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= INFORMASI ABSENSI =================
  Widget _attendanceInfo(BuildContext context) {
    final selectedDate = ref.watch(attendanceDateProvider);
    final selectedFarm = ref.watch(attendanceFormFarmLocationProvider);

    return SectionCard(
      title: 'Informasi Absensi',
      children: [
        SelectField(
          label: "Lokasi peternakan",
          hint: selectedFarm?.name ?? "Pilih lokasi",
          icon: AppImages.icHomeHashTag,
          onTap: () async {
            final result = await showModalBottomSheet<FarmLocation?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => FarmLocationPaginatedBottomSheet(
                initialSelectedId: selectedFarm?.id,
              ),
            );

            if (result != null) {
              ref.read(attendanceFormFarmLocationProvider.notifier).state =
                  result;
            }
          },
        ),
        const SizedBox(height: 12),
        Dropdowns(
          label: 'Tanggal Absensi',
          value: DateFormat(
            'dd MMM yyyy',
            'id_ID',
          ).format(selectedDate ?? DateTime.now()),
          icon: AppImages.icCalendarSearch,
          // enabled: false,
          onTap: () async {
            final pickedDate = await showModalBottomSheet<DateTime?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const CustomDatePickerSheet(),
            );

            if (pickedDate != null) {
              ref.read(attendanceDateProvider.notifier).state = pickedDate;
            }
          },
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

  // ================= INFORMASI PEKERJA =================
  Widget _employeeInfo() {
    final employeesAsync = ref.watch(employeeListProvider);

    return SectionCard(
      title: 'Informasi Pekerja',
      actionLabel: 'Pilih Semua Hadir',
      onActionTap: () {
        ref.read(attendanceStatusProvider.notifier).setAllStatus(true);
      },
      children: [
        employeesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Center(
            child: Text(
              "Gagal memuat data pekerja\n$error",
              textAlign: TextAlign.center,
              style: AppTypography.smallNormalGrey,
            ),
          ),
          data: (employees) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summary(employees),
                const SizedBox(height: 12),

                ...employees.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _employeeItem(e),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _summary(List<Employee> employees) {
    final statuses = ref.watch(attendanceStatusProvider);

    int present = 0;
    int absent = 0;

    for (final e in employees) {
      final attendanceState =
          statuses[e.id] ??
          EmployeeAttendanceState(isPresent: false, note: 'Tidak hadir');
      final isPresent = attendanceState.isPresent;
      if (isPresent) {
        present++;
      } else {
        absent++;
      }
    }

    final total = employees.length;

    return CardWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.groups, color: AppColors.primary),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$total", style: AppTypography.smallBoldBlack),
                  Text("Pekerja", style: AppTypography.xSmallNormalBlack),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("$present hadir", style: AppTypography.xSmallNormalGreen),
              Text("$absent tidak hadir", style: AppTypography.xSmallNormalRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _employeeItem(Employee item) {
    final attendanceState =
        ref.watch(attendanceStatusProvider)[item.id] ??
        EmployeeAttendanceState(isPresent: false, note: 'Tidak hadir');
    final isPresent = attendanceState.isPresent;

    return CardWrapper(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(AppImages.icUserTick, width: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTypography.smallBoldBlack),
                Text(item.position, style: AppTypography.xSmallNormalGrey),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _showNoteBottomSheet(item),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.icNote,
                              width: 16,
                              color:
                                  attendanceState.note.isNotEmpty &&
                                      attendanceState.note !=
                                          (isPresent ? 'Hadir' : 'Tidak hadir')
                                  ? AppColors.primary
                                  : AppColors.hint,
                            ),
                            const SizedBox(width: 4),
                            if (attendanceState.note.isNotEmpty &&
                                attendanceState.note !=
                                    (isPresent ? 'Hadir' : 'Tidak hadir'))
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  attendanceState.note,
                                  style: AppTypography.xSmallNormalPrimary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            else
                              Text(
                                "Tambah catatan",
                                style: AppTypography.xSmallNormalGrey.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _statusDropdown(
            value: isPresent ? "Hadir" : "Tidak Hadir",
            onChanged: (val) {
              ref
                  .read(attendanceStatusProvider.notifier)
                  .setStatus(item.id, val == "Hadir");
            },
          ),
        ],
      ),
    );
  }

  void _showNoteBottomSheet(Employee item) {
    final state = ref.read(attendanceStatusProvider)[item.id];
    final controller = TextEditingController(text: state?.note);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Catatan untuk ${item.name}",
                style: AppTypography.mediumBoldBlack,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Masukkan catatan",
                  border: OutlineInputBorder(),
                ),
                maxLength: 80,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    ref
                        .read(attendanceStatusProvider.notifier)
                        .setNote(item.id, controller.text);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Simpan Catatan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusDropdown({
    required String value,
    required Function(String) onChanged,
  }) {
    return CardWrapper(
      padding: 0,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          value: value,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: AppColors.black,
          ),
          style: AppTypography.xSmallNormalBlack,
          items: const [
            DropdownMenuItem(value: "Hadir", child: Text("Hadir")),
            DropdownMenuItem(value: "Tidak Hadir", child: Text("Tidak Hadir")),
          ],
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }

  Widget _noteField({required int maxLength}) {
    return TextFieldWithInnerCounter(
      label: 'Catatan',
      subLabel: '',
      hint: "Masukkan catatan",
      maxLength: maxLength,
      controller: noteDetailCtrl,
    );
  }

  Future<void> _submitAttendance() async {
    final employeesAsync = ref.read(employeeListProvider);
    final selectedFarm = ref.read(attendanceFormFarmLocationProvider);

    if (selectedFarm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lokasi peternakan wajib diisi"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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
        header: "Konfirmasi Absensi",
        title: "Simpan Absensi Pegawai?",
        subTitle: "Data Absensi Pegawai akan diperbarui di sistem.",
        saveText: "Simpan Absensi",
      ),
    );

    if (isConfirmed != true) return;

    employeesAsync.when(
      data: (employees) async {
        try {
          final payload = _buildAttendancePayload(employees);
          final attendanceLogId = ref.read(attendanceLogIdProvider);

          if (attendanceLogId != null) {
            await ref
                .read(attendanceApiProvider)
                .updateAttendance(attendanceLogId, payload);
          } else {
            await ref.read(attendanceApiProvider).submitAttendance(payload);
          }

          if (!context.mounted) return;
          context.pushReplacement('/history-attendance');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Absensi berhasil disimpan"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal menyimpan absensi")),
          );
        }
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  Map<String, dynamic> _buildAttendancePayload(List<Employee> employees) {
    final selectedDate = ref.read(attendanceDateProvider);
    final statuses = ref.read(attendanceStatusProvider);
    final selectedFarm = ref.read(attendanceFormFarmLocationProvider);
    final farmId = selectedFarm?.id ?? ref.watch(userFarmProvider);

    return {
      "trans_date": DateFormat(
        'yyyy-MM-dd',
      ).format(selectedDate ?? DateTime.now()),
      "additional_information": noteCtrl.text,
      "farm_location_id": farmId,
      "record_by": 1,
      "type": "regular",
      "details": employees.map((e) {
        final attendanceState =
            statuses[e.id] ??
            EmployeeAttendanceState(isPresent: false, note: 'Tidak hadir');
        return {
          "employee_id": e.id,
          "farm_location_id": farmId,
          "status": attendanceState.isPresent ? "present" : "absent",
          "note": attendanceState.note,
        };
      }).toList(),
    };
  }
}
