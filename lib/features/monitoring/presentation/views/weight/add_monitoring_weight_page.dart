import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/employee_bottom_sheet.dart';
import 'package:livestock/core/widgets/custom_date_picker_sheet.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';
import 'package:livestock/features/attendance/data/model/employee_model.dart';

import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/select_field.dart';
import '../../../../../core/widgets/step_info_card.dart';

class AddMonitoringWeightPage extends ConsumerWidget {
  const AddMonitoringWeightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Pemantauan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                StepInfoCard(
                  title: "Informasi Pemantauan Berat",
                  step: 1,
                  totalStep: 3,
                ),
                SizedBox(height: 12),
                _MonitoringInfoSection(),
                SizedBox(height: 12),
              ],
            ),
          ),
          const _NextButton(),
        ],
      ),
    );
  }
}

class _MonitoringInfoSection extends ConsumerWidget {
  const _MonitoringInfoSection();

  void _showEmployeePicker(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<Employee>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EmployeeBottomSheet(
        initialSelectedId: ref.read(selectedMonitoringEmployeeProvider)?.id,
      ),
    );

    if (result != null) {
      ref.read(selectedMonitoringEmployeeProvider.notifier).state = result;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEmployee = ref.watch(selectedMonitoringEmployeeProvider);
    final selectedDate = ref.watch(selectedMonitoringDateProvider);

    return SectionCard(
      title: "Informasi Pemantauan",
      children: [
        SelectField(
          label: "Tanggal Timbang",
          hint: selectedDate != null
              ? formatDateTime(selectedDate)
              : "Pilih tanggal",
          style: selectedDate != null ? AppTypography.smallNormalBlack : null,
          icon: AppImages.icCalendarSearch,
          onTap: () async {
            final pickedDate = await showModalBottomSheet<DateTime?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) =>
                  const CustomDatePickerSheet(title: "Pilih Tanggal Timbang"),
            );

            if (pickedDate != null) {
              ref.read(selectedMonitoringDateProvider.notifier).state =
                  pickedDate;
            }
          },
        ),
        SizedBox(height: 12),
        SelectField(
          label: "Karyawan",
          hint: selectedEmployee != null
              ? "${selectedEmployee.name} • ${selectedEmployee.phone}"
              : "Pilih karyawan",
          style: selectedEmployee != null
              ? AppTypography.smallNormalBlack
              : null,
          icon: AppImages.icUserTag,
          onTap: () => _showEmployeePicker(context, ref),
        ),
      ],
    );
  }
}

class _NextButton extends ConsumerWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEmployee = ref.watch(selectedMonitoringEmployeeProvider);
    final selectedDate = ref.watch(selectedMonitoringDateProvider);
    final isValid = selectedEmployee != null && selectedDate != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.grey3,
              disabledForegroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isValid
                ? () {
                    context.push('/monitoring/add/step-2?type=weight');
                  }
                : null,
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
