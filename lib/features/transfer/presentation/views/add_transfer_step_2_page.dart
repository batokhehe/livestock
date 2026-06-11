import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/core/widgets/step_info_card.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/widgets/farm_location_paginated_bottom_sheet.dart';
import 'package:livestock/features/receiving/presentation/widgets/farm_area_paginated_bottom_sheet.dart';
import '../../../../app/providers.dart';
import '../../transfer_provider.dart';

class AddTransferStep2Page extends ConsumerStatefulWidget {
  const AddTransferStep2Page({super.key});

  @override
  ConsumerState<AddTransferStep2Page> createState() => _AddTransferStep2PageState();
}

class _AddTransferStep2PageState extends ConsumerState<AddTransferStep2Page> {
  late final TextEditingController _deliveryCostController;

  @override
  void initState() {
    super.initState();
    _deliveryCostController = TextEditingController();
    
    // Set initial value from provider if exists
    final initialCost = ref.read(transferDeliveryCostProvider);
    if (initialCost != null) {
      _deliveryCostController.text = formatPrice(initialCost.toInt());
    }

    _deliveryCostController.addListener(() {
      final raw = _deliveryCostController.text.replaceAll('.', '');
      final value = double.tryParse(raw);
      ref.read(transferDeliveryCostProvider.notifier).state = value;
    });
  }

  @override
  void dispose() {
    _deliveryCostController.dispose();
    super.dispose();
  }

  void _showFarmLocationPicker(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<FarmLocation?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FarmLocationPaginatedBottomSheet(
        initialSelectedId: ref.read(selectedTransferToLocationProvider)?.id,
      ),
    );

    if (result != null) {
      ref.read(selectedTransferToLocationProvider.notifier).state = result;
      ref.read(animalFarmLocationIdProvider.notifier).state = result.id;

      // Clear area if location changes
      ref.read(selectedTransferToAreaProvider.notifier).state = null;
      ref.read(animalFarmAreaIdProvider.notifier).state = null;
    }
  }

  void _showFarmAreaPicker(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<FarmArea?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FarmAreaPaginatedBottomSheet(
        initialSelectedId: ref.read(selectedTransferToAreaProvider)?.id,
      ),
    );

    if (result != null) {
      ref.read(selectedTransferToAreaProvider.notifier).state = result;
      ref.read(animalFarmAreaIdProvider.notifier).state = result.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keep Step 1 providers alive during Step 2
    ref.watch(selectedTransferDateProvider);
    final selectedAnimal = ref.watch(selectedTransferAnimalProvider);

    final selectedToLocation = ref.watch(selectedTransferToLocationProvider);
    final selectedToArea = ref.watch(selectedTransferToAreaProvider);

    final bool isValid = selectedToLocation != null && selectedToArea != null;

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Pemindahan",
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
                const StepInfoCard(
                  title: "Pemindahan Asal & Tujuan",
                  step: 2,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                if (selectedAnimal != null) ...[
                  SectionCard(
                    title: "Informasi Hewan",
                    children: [
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
                  ),
                  const SizedBox(height: 12),
                ],
                SectionCard(
                  title: "Informasi Asal",
                  children: [
                    SelectField(
                      label: "Lokasi peternakan",
                      hint: selectedAnimal?.farmLocation?.name ?? '-',
                      enabled: false,
                      icon: AppImages.icHomeHashTag,
                    ),
                    const SizedBox(height: 12),
                    SelectField(
                      label: "Area peternakan",
                      hint: selectedAnimal?.farmArea?.name ?? '-',
                      enabled: false,
                      icon: AppImages.icMap,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: "Informasi Tujuan",
                  children: [
                    SelectField(
                      label: "Lokasi peternakan",
                      isMandatoryField: true,
                      hint: selectedToLocation?.name ?? "Pilih lokasi",
                      icon: AppImages.icHomeHashTag,
                      onTap: () => _showFarmLocationPicker(context, ref),
                    ),
                    const SizedBox(height: 12),
                    SelectField(
                      label: "Area peternakan",
                      isMandatoryField: true,
                      hint: selectedToArea?.name ?? "Pilih area",
                      icon: AppImages.icMap,
                      enabled: selectedToLocation != null,
                      onTap: () => _showFarmAreaPicker(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: "Rincian Biaya",
                  children: [
                    TextFields(
                      label: "Biaya Pengiriman (Opsional)",
                      hint: "Masukkan biaya pengiriman",
                      prefixText: "Rp ",
                      controller: _deliveryCostController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isValid
                        ? AppColors.primary
                        : AppColors.grey3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: isValid ? 2 : 0,
                  ),
                  onPressed: isValid
                      ? () {
                          context.push('/transfer/add-step-3');
                        }
                      : null,
                  child: Text(
                    "Selanjutnya",
                    style: AppTypography.mediumBoldWhite.copyWith(
                      color: isValid
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
