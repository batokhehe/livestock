import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/employee_bottom_sheet.dart';
import 'package:livestock/core/widgets/custom_date_picker_sheet.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';
import 'package:livestock/features/attendance/data/model/employee_model.dart';
import 'package:livestock/core/widgets/input_field.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/widgets/farm_location_paginated_bottom_sheet.dart';
import 'package:livestock/features/receiving/presentation/widgets/farm_area_paginated_bottom_sheet.dart';

import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/select_field.dart';
import '../../../../../core/widgets/step_info_card.dart';

class AddMonitoringFeedPage extends StatelessWidget {
  const AddMonitoringFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Monitoring",
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
                StepInfoCard(title: "Monitoring Pakan", step: 1, totalStep: 3),
                SizedBox(height: 12),
                _MonitoringInfoSection(),
                SizedBox(height: 12),
                _FarmInfoSection(),
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
      title: "Informasi Monitoring",
      children: [
        SelectField(
          label: "Tanggal Monitoring",
          isMandatoryField: true,
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
              builder: (_) => const CustomDatePickerSheet(
                title: "Pilih Tanggal Monitoring",
              ),
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
          isMandatoryField: true,
          hint: selectedEmployee != null
              ? "${selectedEmployee.name} • ${selectedEmployee.phone}"
              : "Pilih karyawan",
          style: selectedEmployee != null
              ? AppTypography.smallNormalBlack
              : null,
          icon: AppImages.icUserTag,
          onTap: () => _showEmployeePicker(context, ref),
        ),
        SizedBox(height: 12),
        InputField(
          label: "Satuan",
          isMandatoryField: true,
          hint: "Masukkan satuan",
          keyboardType: TextInputType.text,
          onChanged: (val) {
            ref.read(monitoringFeedSatuanProvider.notifier).state = val;
          },
        ),
      ],
    );
  }
}

class _FarmInfoSection extends ConsumerWidget {
  const _FarmInfoSection();

  void _showFarmLocationPicker(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<FarmLocation?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FarmLocationPaginatedBottomSheet(
        initialSelectedId: ref.read(selectedMonitoringFarmProvider)?.id,
      ),
    );

    if (result != null) {
      ref.read(selectedMonitoringFarmProvider.notifier).state = result;
      // Clear area if location changes
      ref.read(selectedMonitoringAreaProvider.notifier).state = null;
    }
  }

  void _showFarmAreaPicker(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<FarmArea?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FarmAreaPaginatedBottomSheet(
        initialSelectedId: ref.read(selectedMonitoringAreaProvider)?.id,
      ),
    );

    if (result != null) {
      ref.read(selectedMonitoringAreaProvider.notifier).state = result;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFarm = ref.watch(selectedMonitoringFarmProvider);
    final selectedArea = ref.watch(selectedMonitoringAreaProvider);
    final availableCountAsync = ref.watch(
      monitoringAnimalAvailableCountProvider,
    );
    final availableCount = availableCountAsync.value ?? 0;

    return SectionCard(
      title: "Informasi Peternakan",
      children: [
        SelectField(
          label: "Lokasi peternakan",
          isMandatoryField: true,
          hint: selectedFarm?.name ?? "Pilih lokasi",
          icon: AppImages.icHomeHashTag,
          onTap: () => _showFarmLocationPicker(context, ref),
        ),
        SizedBox(height: 12),
        SelectField(
          label: "Area peternakan",
          isMandatoryField: true,
          hint: selectedArea?.name ?? "Pilih area",
          icon: AppImages.icMap,
          enabled: selectedFarm != null,
          onTap: () => _showFarmAreaPicker(context, ref),
        ),
        SizedBox(height: 12),
        CardWrapper(
          child: availableCountAsync.isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : ProductHeaderCard(
                  title: "$availableCount Hewan",
                  subtitle: "Hewan Tersedia",
                  image: AppImages.icProduct,
                ),
        ),
      ],
    );
  }
}

class _NextButton extends ConsumerWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedMonitoringDateProvider);
    final selectedEmployee = ref.watch(selectedMonitoringEmployeeProvider);
    final satuan = ref.watch(monitoringFeedSatuanProvider);
    final selectedFarm = ref.watch(selectedMonitoringFarmProvider);
    final selectedArea = ref.watch(selectedMonitoringAreaProvider);
    final availableCountAsync = ref.watch(
      monitoringAnimalAvailableCountProvider,
    );
    final availableCount = availableCountAsync.value ?? 0;

    final isValid =
        selectedDate != null &&
        selectedEmployee != null &&
        satuan.trim().isNotEmpty &&
        selectedFarm != null &&
        selectedArea != null &&
        availableCount > 0;

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
              elevation: isValid ? 2 : 0,
            ),
            onPressed: isValid
                ? () {
                    context.push('/monitoring/add/step-2?type=feed');
                  }
                : null,
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
