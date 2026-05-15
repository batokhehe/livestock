import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/farm_area_bottom_sheet.dart';
import 'package:livestock/core/widgets/farm_location_paginated_bottom_sheet.dart';
import 'package:livestock/features/receiving/presentation/widgets/farm_area_paginated_bottom_sheet.dart';
import 'package:livestock/core/widgets/step_info_card.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';

import '../../../../app/providers.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/custom_date_picker_sheet.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../receiving_provider.dart';
import '../widgets/select_receiving_item_sheet.dart';

class AddReceivingPage extends ConsumerStatefulWidget {
  const AddReceivingPage({super.key});

  @override
  ConsumerState<AddReceivingPage> createState() => _AddReceivingPageState();
}

class _AddReceivingPageState extends ConsumerState<AddReceivingPage> {
  final notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(selectedFarmLocationProvider.notifier).state = null;
      ref.read(selectedFarmAreaProvider.notifier).state = null;
      ref.read(animalFarmLocationIdProvider.notifier).state = null;
      ref.read(animalFarmAreaIdProvider.notifier).state = null;

      ref.read(receivingFormProvider).setRemarks('');
    });
  }

  @override
  Widget build(BuildContext context) {
    final notesCtrl = TextEditingController();
    final type = ref.read(receivingTabProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Penerimaan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                StepInfoCard(
                  title: "Informasi Penerimaan",
                  step: 1,
                  totalStep: 3,
                ),
                SizedBox(height: 12),
                _ReceivingInfoSection(notesCtrl),
                SizedBox(height: 12),
                _FarmInfoSection(),
              ],
            ),
          ),
          _NextButton(type),
        ],
      ),
    );
  }
}

class _ReceivingInfoSection extends ConsumerWidget {
  final TextEditingController notesCtrl;

  const _ReceivingInfoSection(this.notesCtrl);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(receivingDateProvider);

    final dateText = selectedDate == null
        ? 'Pilih Tanggal'
        : DateFormat('dd MMM yyyy', 'id_ID').format(selectedDate);

    return SectionCard(
      title: "Informasi Penerimaan",
      children: [
        SelectField(
          label: "Tanggal penerimaan",
          isMandatoryField: true,
          hint: dateText,
          icon: AppImages.icCalendarSearch,
          onTap: () async {
            final pickedDate = await showModalBottomSheet<DateTime?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const CustomDatePickerSheet(),
            );

            if (pickedDate != null) {
              ref.read(receivingDateProvider.notifier).state = pickedDate;
            }
          },
        ),
        const SizedBox(height: 12),
        TextFieldWithInnerCounter(
          controller: notesCtrl,
          label: "Catatan",
          subLabel: "(Optional)",
          hint: "Masukkan catatan",
          maxLength: 80,
          onChanged: (value) {
            ref.read(receivingFormProvider).setRemarks(value);
          },
        ),
      ],
    );
  }
}

class _FarmInfoSection extends ConsumerWidget {
  const _FarmInfoSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFarm = ref.watch(selectedFarmLocationProvider);
    final selectedArea = ref.watch(selectedFarmAreaProvider);
    final activeTab = ref.watch(receivingTabProvider);

    return SectionCard(
      title: "Informasi Peternakan",
      children: [
        if (activeTab == ReceivingTab.feed) ...[
          SelectField(
            label: "Jenis penerimaan",
            isMandatoryField: true,
            hint: ref.watch(receivingFeedTypeProvider) ?? "Pilih jenis",
            icon: AppImages.icBox,
            onTap: () => _showFeedTypePicker(context, ref),
          ),
          const SizedBox(height: 12),
        ],
        SelectField(
          label: "Lokasi peternakan",
          isMandatoryField: true,
          hint: selectedFarm?.name ?? "Pilih lokasi",
          icon: AppImages.icHomeHashTag,
          onTap: () => _showFarmLocationPicker(context, ref),
        ),
        if (activeTab == ReceivingTab.animal) ...[
          const SizedBox(height: 12),
          SelectField(
            label: "Area peternakan",
            isMandatoryField: true,
            hint: selectedArea?.name ?? "Pilih area",
            icon: AppImages.icMap,
            enabled: selectedFarm != null,
            onTap: () => _showFarmAreaPicker(context, ref),
          ),
        ],
      ],
    );
  }

  void _showFeedTypePicker(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Pilih Jenis Penerimaan",
                  style: AppTypography.mediumBoldBlack,
                ),
              ),
              ListTile(
                title: const Text("Pakan"),
                onTap: () => Navigator.pop(context, "Pakan"),
              ),
              ListTile(
                title: const Text("Obat"),
                onTap: () => Navigator.pop(context, "Obat"),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      ref.read(receivingFeedTypeProvider.notifier).state = result;
    }
  }

  void _showFarmLocationPicker(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<FarmLocation?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FarmLocationPaginatedBottomSheet(
        initialSelectedId: ref.read(selectedFarmLocationProvider)?.id,
      ),
    );

    if (result != null) {
      ref.read(selectedFarmLocationProvider.notifier).state = result;
      ref.read(animalFarmLocationIdProvider.notifier).state = result.id;

      // Clear area if location changes
      ref.read(selectedFarmAreaProvider.notifier).state = null;
      ref.read(animalFarmAreaIdProvider.notifier).state = null;
    }
  }

  void _showFarmAreaPicker(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<FarmArea?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FarmAreaPaginatedBottomSheet(
        initialSelectedId: ref.read(selectedFarmAreaProvider)?.id,
      ),
    );

    if (result != null) {
      ref.read(selectedFarmAreaProvider.notifier).state = result;
      ref.read(animalFarmAreaIdProvider.notifier).state = result.id;
    }
  }
}

class _NextButton extends ConsumerWidget {
  final ReceivingTab type;

  const _NextButton(this.type);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(receivingDateProvider);
    final selectedFarm = ref.watch(selectedFarmLocationProvider);
    final selectedArea = ref.watch(selectedFarmAreaProvider);

    final selectedFeedType = ref.watch(receivingFeedTypeProvider);

    bool isValid = selectedDate != null && selectedFarm != null;
    if (type == ReceivingTab.animal) {
      isValid = isValid && selectedArea != null;
    } else if (type == ReceivingTab.feed) {
      isValid = isValid && selectedFeedType != null;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isValid ? AppColors.primary : AppColors.grey3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isValid ? 2 : 0,
            ),
            onPressed: isValid
                ? () {
                    ref.read(receivingPoSearchProvider.notifier).state = '';
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => SelectReceivingItemSheet(tab: type),
                    );
                  }
                : null,
            child: Text(
              "Selanjutnya",
              style: AppTypography.mediumBoldWhite.copyWith(
                color: isValid ? Colors.white : Colors.white.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
