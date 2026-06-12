import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/core/widgets/step_info_card.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import '../../transfer_provider.dart';
import '../widgets/stock_transfer_farm_location_bottom_sheet.dart';

class AddStockTransferStep2Page extends ConsumerStatefulWidget {
  const AddStockTransferStep2Page({super.key});

  @override
  ConsumerState<AddStockTransferStep2Page> createState() => _AddStockTransferStep2PageState();
}

class _AddStockTransferStep2PageState extends ConsumerState<AddStockTransferStep2Page> {

  void _showFarmLocationPicker(BuildContext context, WidgetRef ref) async {
    final selectedToLocation = ref.read(selectedStockTransferToLocationProvider);

    ref.read(stockTransferLocationSearchProvider.notifier).state = '';

    final result = await showModalBottomSheet<FarmLocation?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StockTransferFarmLocationBottomSheet(
        initialSelectedId: selectedToLocation?.id,
        title: "Pilih Lokasi Tujuan",
        description: "Silakan pilih lokasi peternakan tujuan pemindahan stock.",
      ),
    );

    if (result != null) {
      ref.read(selectedStockTransferToLocationProvider.notifier).state = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch step 1 values to keep them in memory
    ref.watch(selectedStockTransferDateProvider);
    final selectedItem = ref.watch(selectedStockTransferItemProvider);
    final qty = ref.watch(stockTransferQuantityProvider);

    final selectedToLocation = ref.watch(selectedStockTransferToLocationProvider);

    final bool isValid = selectedToLocation != null;
    final qtyStr = qty != null ? (qty % 1 == 0 ? qty.toInt().toString() : qty.toString()) : '0';

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
                  title: "Informasi Pemindahan Stock",
                  step: 2,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                if (selectedItem != null) ...[
                  SectionCard(
                    title: "Informasi Stock",
                    children: [
                      CardWrapper(
                        child: ProductHeaderCard(
                          title: selectedItem.itemCode,
                          subtitle: "${selectedItem.itemName} • $qtyStr ${selectedItem.uom ?? 'Unit'}",
                          image: AppImages.icProduct,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    title: "Informasi Asal",
                    children: [
                      SelectField(
                        label: "Dari Lokasi",
                        hint: selectedItem.farmLocationName,
                        icon: AppImages.icHome,
                        onTap: null, // read-only/disabled
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                SectionCard(
                  title: "Informasi Tujuan",
                  children: [
                    SelectField(
                      label: "Ke Lokasi",
                      isMandatoryField: true,
                      hint: selectedToLocation?.name ?? "Pilih Lokasi",
                      icon: AppImages.icHome,
                      onTap: () => _showFarmLocationPicker(context, ref),
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
                    backgroundColor: isValid ? AppColors.primary : AppColors.grey3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: isValid ? 2 : 0,
                  ),
                  onPressed: isValid
                      ? () {
                          context.push('/transfer/stock-add-step-3');
                        }
                      : null,
                  child: Text(
                    "Selanjutnya",
                    style: AppTypography.mediumBoldWhite.copyWith(
                      color: isValid ? Colors.white : Colors.white.withValues(alpha: 0.6),
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
