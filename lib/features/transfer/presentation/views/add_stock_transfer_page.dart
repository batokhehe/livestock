import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/custom_date_picker_sheet.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/core/widgets/step_info_card.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import '../../transfer_provider.dart';
import '../widgets/stock_transfer_item_bottom_sheet.dart';

class AddStockTransferPage extends ConsumerStatefulWidget {
  const AddStockTransferPage({super.key});

  @override
  ConsumerState<AddStockTransferPage> createState() => _AddStockTransferPageState();
}

class _AddStockTransferPageState extends ConsumerState<AddStockTransferPage> {
  final _qtyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedStockTransferDateProvider.notifier).state = DateTime.now();
      ref.read(selectedStockTransferTypeProvider.notifier).state = null;
      ref.read(selectedStockTransferItemProvider.notifier).state = null;
      ref.read(stockTransferQuantityProvider.notifier).state = null;
    });

    _qtyCtrl.addListener(() {
      final val = double.tryParse(_qtyCtrl.text);
      ref.read(stockTransferQuantityProvider.notifier).state = val;
    });
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  void _showStockTypePicker() async {
    final selectedType = ref.read(selectedStockTransferTypeProvider);
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _StockTypeBottomSheet(initialSelected: selectedType),
    );

    if (result != null) {
      ref.read(selectedStockTransferTypeProvider.notifier).state = result;
    }
  }

  void _showStockItemPicker() async {
    final selectedItem = ref.read(selectedStockTransferItemProvider);
    final selectedType = ref.read(selectedStockTransferTypeProvider);

    if (selectedType == null) return;

    ref.read(stockTransferSearchProvider.notifier).state = '';

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StockTransferItemBottomSheet(
        initialSelected: selectedItem,
        title: "Pilih Item $selectedType",
        description: "Silakan pilih salah satu item $selectedType untuk dipindahkan.",
      ),
    );

    if (result != null) {
      ref.read(selectedStockTransferItemProvider.notifier).state = result;
      _qtyCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(selectedStockTransferTypeProvider, (prev, next) {
      if (prev != next) {
        ref.read(selectedStockTransferItemProvider.notifier).state = null;
        _qtyCtrl.clear();
      }
    });

    final selectedDate = ref.watch(selectedStockTransferDateProvider);
    final selectedType = ref.watch(selectedStockTransferTypeProvider);
    final selectedItem = ref.watch(selectedStockTransferItemProvider);
    final qty = ref.watch(stockTransferQuantityProvider);

    final bool isValid = selectedType != null &&
        selectedItem != null &&
        qty != null &&
        qty > 0 &&
        qty <= selectedItem.qty;

    final formattedDate = formatDateTime(selectedDate);
    final qtyLimitText = selectedItem != null
        ? "Maks: ${selectedItem.qty % 1 == 0 ? selectedItem.qty.toInt() : selectedItem.qty} ${selectedItem.uom ?? 'Unit'}"
        : null;

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
                  step: 1,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: "Informasi Pemindahan",
                  children: [
                    SelectField(
                      label: "Tanggal Pemindahan",
                      isMandatoryField: true,
                      hint: formattedDate,
                      icon: AppImages.icCalendarSearch,
                      onTap: () async {
                        final pickedDate = await showModalBottomSheet<DateTime?>(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const CustomDatePickerSheet(),
                        );

                        if (pickedDate != null) {
                          ref.read(selectedStockTransferDateProvider.notifier).state = pickedDate;
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: "Informasi Stock",
                  children: [
                    SelectField(
                      label: "Pilih Type Stock",
                      isMandatoryField: true,
                      hint: selectedType ?? "Pilih Type Stock",
                      icon: AppImages.icProduct,
                      onTap: _showStockTypePicker,
                    ),
                    const SizedBox(height: 12),
                    SelectField(
                      label: "Pilih Item",
                      isMandatoryField: true,
                      hint: selectedItem != null
                          ? "${selectedItem.itemName} (${selectedItem.itemCode})"
                          : "Pilih Item",
                      icon: AppImages.icProduct,
                      onTap: selectedType != null ? _showStockItemPicker : null,
                    ),
                    if (selectedItem != null) ...[
                      const SizedBox(height: 12),
                      CardWrapper(
                        child: ProductHeaderCard(
                          title: selectedItem.itemCode,
                          subtitle: "${selectedItem.itemName} • ${selectedItem.qty % 1 == 0 ? selectedItem.qty.toInt() : selectedItem.qty} ${selectedItem.uom ?? 'Unit'}",
                          image: AppImages.icProduct,
                          status: "${selectedItem.farmLocationName}${selectedItem.farmAreaName != null ? ' (${selectedItem.farmAreaName})' : ''}",
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextFields(
                      label: "Kuantitas",
                      hint: "Masukkan jumlah kuantitas",
                      controller: _qtyCtrl,
                      isMandatoryField: true,
                      enabled: selectedItem != null,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      suffix: qtyLimitText,
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
                          context.push('/transfer/stock-add-step-2');
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

class _StockTypeBottomSheet extends StatelessWidget {
  final String? initialSelected;
  const _StockTypeBottomSheet({this.initialSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pilih Tipe Stock', style: AppTypography.largeBoldBlack),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.iconColor,
                      width: 2,
                    ),
                  ),
                  child: const Icon(Icons.close_rounded, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...['Alat', 'Pakan', 'Obat'].map((type) => Column(
                children: [
                  ListTile(
                    title: Text(type, style: AppTypography.smallBoldBlack),
                    trailing: initialSelected == type ? const Icon(Icons.check, color: AppColors.primary) : null,
                    onTap: () => Navigator.pop(context, type),
                  ),
                  const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
                ],
              )),
        ],
      ),
    );
  }
}
