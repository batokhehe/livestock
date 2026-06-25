import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/custom_date_picker_sheet.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/widgets/employee_bottom_sheet.dart';
import 'package:livestock/features/attendance/data/model/employee_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/widgets/farm_location_paginated_bottom_sheet.dart';
import 'package:livestock/features/receiving/presentation/widgets/farm_area_paginated_bottom_sheet.dart';
import 'package:livestock/features/monitoring/data/medicine_monitoring_model.dart';
import 'edit_monitoring_medicine_provider.dart';

import '../../../../../../core/theme/AppColors.dart';
import '../../../../../../core/theme/AppTypography.dart';
import '../../../../../../core/widgets/section_card.dart';
import '../../../../../../core/widgets/select_field.dart';
import '../../../../../../core/widgets/step_info_card.dart';

class EditMonitoringMedicinePage extends ConsumerStatefulWidget {
  final MedicineMonitoring item;
  const EditMonitoringMedicinePage({super.key, required this.item});

  @override
  ConsumerState<EditMonitoringMedicinePage> createState() =>
      _EditMonitoringMedicinePageState();
}

class _EditMonitoringMedicinePageState
    extends ConsumerState<EditMonitoringMedicinePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        EditMonitoringMedicineInitializer.init(ref, widget.item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(editAddedMonitoringMedicineItemsProvider);
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Edit Pemantauan",
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
                StepInfoCard(title: "Pemantauan Obat", step: 1, totalStep: 3),
                SizedBox(height: 12),
                _MonitoringInfoSection(),
                SizedBox(height: 12),
                _FarmInfoSection(),
              ],
            ),
          ),
          _NextButton(item: widget.item),
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
        initialSelectedId: ref
            .read(editSelectedMedicineMonitoringEmployeeProvider)
            ?.id,
      ),
    );
    if (result != null) {
      ref.read(editSelectedMedicineMonitoringEmployeeProvider.notifier).state =
          result;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(editSelectedMedicineMonitoringDateProvider);
    final selectedEmployee = ref.watch(
      editSelectedMedicineMonitoringEmployeeProvider,
    );
    return SectionCard(
      title: "Informasi Pemantauan",
      children: [
        SelectField(
          label: "Tanggal Pemantauan",
          hint: selectedDate != null
              ? formatDateTime(selectedDate)
              : "Pilih tanggal",
          style: selectedDate != null ? AppTypography.smallNormalBlack : null,
          icon: AppImages.icCalendarSearch,
          isMandatoryField: true,
          onTap: () async {
            final pickedDate = await showModalBottomSheet<DateTime?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const CustomDatePickerSheet(
                title: "Pilih Tanggal Pemantauan",
              ),
            );
            if (pickedDate != null) {
              ref
                      .read(editSelectedMedicineMonitoringDateProvider.notifier)
                      .state =
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
        initialSelectedId: ref
            .read(editSelectedMedicineMonitoringFarmProvider)
            ?.id,
      ),
    );
    if (result != null) {
      ref.read(editSelectedMedicineMonitoringFarmProvider.notifier).state =
          result;
      ref.read(editSelectedMedicineMonitoringAreaProvider.notifier).state =
          null;
    }
  }

  void _showFarmAreaPicker(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<FarmArea?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FarmAreaPaginatedBottomSheet(
        initialSelectedId: ref
            .read(editSelectedMedicineMonitoringAreaProvider)
            ?.id,
      ),
    );
    if (result != null) {
      ref.read(editSelectedMedicineMonitoringAreaProvider.notifier).state =
          result;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFarm = ref.watch(editSelectedMedicineMonitoringFarmProvider);
    final selectedArea = ref.watch(editSelectedMedicineMonitoringAreaProvider);
    final availableCountAsync = ref.watch(
      editMonitoringAnimalAvailableCountProvider,
    );
    final availableCount = availableCountAsync.value ?? 0;

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
  final MedicineMonitoring item;
  const _NextButton({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(editSelectedMedicineMonitoringDateProvider);
    final selectedEmployee = ref.watch(
      editSelectedMedicineMonitoringEmployeeProvider,
    );
    final selectedFarm = ref.watch(editSelectedMedicineMonitoringFarmProvider);
    final selectedArea = ref.watch(editSelectedMedicineMonitoringAreaProvider);
    final availableCountAsync = ref.watch(
      editMonitoringAnimalAvailableCountProvider,
    );
    final availableCount = availableCountAsync.value ?? 0;

    final isValid =
        selectedDate != null &&
        selectedEmployee != null &&
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
                    context.push(
                      '/monitoring/edit/medicine/step-2',
                      extra: item,
                    );
                  }
                : null,
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
