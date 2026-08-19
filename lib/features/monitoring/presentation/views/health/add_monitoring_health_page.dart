import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/custom_date_picker_sheet.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/employee_bottom_sheet.dart';
import 'package:livestock/features/attendance/data/model/employee_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/widgets/farm_location_paginated_bottom_sheet.dart';
import 'package:livestock/features/receiving/presentation/widgets/farm_area_paginated_bottom_sheet.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';
import 'package:livestock/core/helpers/utils.dart';
import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/select_field.dart';
import '../../../../../core/widgets/step_info_card.dart';
import 'widgets/health_check_animal_bottom_sheet.dart';

class AddMonitoringHealthPage extends StatelessWidget {
  const AddMonitoringHealthPage({super.key});

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
                StepInfoCard(title: "Pengobatan", step: 1, totalStep: 3),
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
    final selectedDate = ref.watch(selectedHealthMonitoringDateProvider);
    final selectedEmployee = ref.watch(selectedMonitoringEmployeeProvider);
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
              ref.read(selectedHealthMonitoringDateProvider.notifier).state =
                  pickedDate;
            }
          },
        ),
        const SizedBox(height: 12),
        SelectField(
          label: "Karyawan",
          isMandatoryField: true,
          hint: selectedEmployee != null
              ? "${selectedEmployee.name} \u2022 ${selectedEmployee.phone}"
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
      ref.read(selectedMonitoringAreaProvider.notifier).state = null;
      ref.read(selectedHealthCheckAnimalProvider.notifier).state = null;
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
      ref.read(selectedHealthCheckAnimalProvider.notifier).state = null;
    }
  }

  void _showAnimalPicker(
    BuildContext context,
    WidgetRef ref,
    int farmLocationId,
    int farmAreaId,
  ) async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HealthCheckAnimalBottomSheet(
        farmLocationId: farmLocationId,
        farmAreaId: farmAreaId,
        excludedIds: const [],
      ),
    );
    if (result != null) {
      ref.read(selectedHealthCheckAnimalProvider.notifier).state = result;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFarm = ref.watch(selectedMonitoringFarmProvider);
    final selectedArea = ref.watch(selectedMonitoringAreaProvider);
    final selectedAnimal = ref.watch(selectedHealthCheckAnimalProvider);

    return SectionCard(
      title: "Informasi Peternakan",
      children: [
        SelectField(
          label: "Lokasi peternakan",
          isMandatoryField: true,
          hint: selectedFarm?.name ?? "Pilih lokasi",
          style: selectedFarm != null ? AppTypography.smallNormalBlack : null,
          icon: AppImages.icHomeHashTag,
          onTap: () => _showFarmLocationPicker(context, ref),
        ),
        const SizedBox(height: 12),
        SelectField(
          label: "Area peternakan",
          isMandatoryField: true,
          hint: selectedArea?.name ?? "Pilih area",
          style: selectedArea != null ? AppTypography.smallNormalBlack : null,
          icon: AppImages.icMap,
          enabled: selectedFarm != null,
          onTap: () => _showFarmAreaPicker(context, ref),
        ),
        const SizedBox(height: 12),
        SelectField(
          label: "Hewan",
          isMandatoryField: true,
          hint: selectedAnimal != null
              ? "${selectedAnimal.animalCode} • ${selectedAnimal.name}"
              : "Pilih hewan",
          style: selectedAnimal != null ? AppTypography.smallNormalBlack : null,
          icon: AppImages.icProduct,
          enabled: selectedFarm != null && selectedArea != null,
          onTap: () {
            if (selectedFarm != null && selectedArea != null) {
              _showAnimalPicker(context, ref, selectedFarm.id, selectedArea.id);
            }
          },
        ),
        if (selectedAnimal != null) ...[
          const SizedBox(height: 12),
          CardWrapper(
            child: ProductHeaderCard(
              title: selectedAnimal.animalCode,
              subtitle:
                  "${selectedAnimal.name} • ${selectedAnimal.weight.floor()} kg",
              image: AppImages.icProduct,
              status: selectedAnimal.available,
            ),
          ),
        ],
      ],
    );
  }
}

class _NextButton extends ConsumerWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedHealthMonitoringDateProvider);
    final selectedEmployee = ref.watch(selectedMonitoringEmployeeProvider);
    final selectedFarm = ref.watch(selectedMonitoringFarmProvider);
    final selectedArea = ref.watch(selectedMonitoringAreaProvider);
    final selectedAnimal = ref.watch(selectedHealthCheckAnimalProvider);

    final isValid =
        selectedDate != null &&
        selectedEmployee != null &&
        selectedFarm != null &&
        selectedArea != null &&
        selectedAnimal != null;

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
                    context.push('/monitoring/add/step-2?type=health');
                  }
                : null,
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
