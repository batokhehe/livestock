import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/farm_area_bottom_sheet.dart';
import 'package:livestock/core/widgets/farm_location_bottom_sheet.dart';
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
        SelectField(
          label: "Lokasi peternakan",
          hint: selectedFarm?.name ?? "Pilih lokasi",
          icon: AppImages.icHomeHashTag,
          onTap: () => _showFarmLocationPicker(context),
        ),
        if (activeTab == ReceivingTab.animal) ...[
          const SizedBox(height: 12),
          SelectField(
            label: "Area peternakan",
            hint: selectedArea?.name ?? "Pilih area",
            icon: AppImages.icMap,
            onTap: () => _showFarmAreaPicker(context),
          ),
        ],
      ],
    );
  }

  void _showFarmLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: AppColors.greyBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FarmLocationBottomSheet(),
    );
  }

  void _showFarmAreaPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: AppColors.greyBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FarmAreaBottomSheet(),
    );
  }
}

class _NextButton extends StatelessWidget {
  final ReceivingTab type;

  const _NextButton(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => SelectReceivingItemSheet(tab: type),
              );
            },
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
