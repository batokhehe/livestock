import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../../core/widgets/text_field_with_inner_counter.dart';
import '../../../../core/helpers/utils.dart';
import '../../data/monitoring_item_model.dart';
import '../../data/monitoring_type_item_model.dart';
import 'monitoring_feed_paginated_bottom_sheet.dart';

class AddItemBottomSheet extends StatefulWidget {
  final MonitoringItem? itemToEdit;
  const AddItemBottomSheet({super.key, this.itemToEdit});

  @override
  State<AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  final nameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final totalPriceCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  MonitoringTypeItemModel? selectedFeed;

  @override
  void initState() {
    super.initState();
    if (widget.itemToEdit != null) {
      final item = widget.itemToEdit!;
      nameCtrl.text = item.name ?? '';
      codeCtrl.text = item.code ?? '';
      stockCtrl.text = item.stock ?? '0';
      qtyCtrl.text = item.quantity.toString();
      priceCtrl.text = item.price.toString();
      noteCtrl.text = item.note ?? '';
      totalPriceCtrl.text = formatPrice((item.quantity ?? 0) * (item.price ?? 0));
    }

    qtyCtrl.addListener(_calculateTotal);
    priceCtrl.addListener(_calculateTotal);
  }

  void _calculateTotal() {
    int qty = int.tryParse(qtyCtrl.text) ?? 0;
    final stock = int.tryParse(stockCtrl.text) ?? 0;

    bool qtyChanged = false;
    if (qty > stock) {
      qty = stock;
      qtyChanged = true;
    }

    final price = int.tryParse(priceCtrl.text) ?? 0;
    final rawTotal = (qty > 0 && price > 0) ? (qty * price) : 0;
    final formattedTotal = formatPrice(rawTotal);

    if (totalPriceCtrl.text != formattedTotal) {
      totalPriceCtrl.text = formattedTotal;
    }

    if (qtyChanged) {
      qtyCtrl.value = TextEditingValue(
        text: qty.toString(),
        selection: TextSelection.collapsed(offset: qty.toString().length),
      );
    }

    setState(() {});
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    codeCtrl.dispose();
    stockCtrl.dispose();
    qtyCtrl.dispose();
    priceCtrl.dispose();
    totalPriceCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.itemToEdit == null ? "Tambah Item" : "Ubah Item",
                  style: AppTypography.largeBoldBlack,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (widget.itemToEdit == null) ...[
              Dropdowns(
                label: "Pakan",
                value: selectedFeed == null
                    ? "Pilih Pakan"
                    : selectedFeed!.name,
                icon: AppImages.icProduct,
                onTap: _openFeedSheet,
              ),
            ],
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.greyBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Nama Pakan", style: AppTypography.smallNormalGrey),
                        const SizedBox(height: 4),
                        Text(nameCtrl.text.isEmpty ? "-" : nameCtrl.text, style: AppTypography.smallBoldBlack),
                        const SizedBox(height: 12),
                        const Text("Kuantitas Tersedia", style: AppTypography.smallNormalGrey),
                        const SizedBox(height: 4),
                        Text(stockCtrl.text.isEmpty ? "0" : stockCtrl.text, style: AppTypography.smallBoldBlack),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Kode", style: AppTypography.smallNormalGrey),
                        const SizedBox(height: 4),
                        Text(codeCtrl.text.isEmpty ? "-" : codeCtrl.text, style: AppTypography.smallBoldBlack),
                        const SizedBox(height: 12),
                        const Text("Harga Satuan", style: AppTypography.smallNormalGrey),
                        const SizedBox(height: 4),
                        Text(
                          priceCtrl.text.isEmpty 
                              ? "Rp 0" 
                              : "Rp ${formatPrice(int.tryParse(priceCtrl.text) ?? 0)}", 
                          style: AppTypography.smallBoldBlack,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFields(
              label: "Jumlah Pakan",
              hint: "Jumlah Pakan",
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            TextFields(
              label: "Harga Total",
              hint: "Harga Total",
              controller: totalPriceCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyInputFormatter()],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: (int.tryParse(qtyCtrl.text) ?? 0) > 0
                    ? () {
                        Navigator.pop(
                          context,
                          MonitoringItem(
                            name: nameCtrl.text,
                            code: codeCtrl.text,
                            unit:
                                widget.itemToEdit?.unit ??
                                (selectedFeed?.uom.isNotEmpty == true
                                    ? selectedFeed!.uom
                                    : "Pakan"),
                            quantity: int.tryParse(qtyCtrl.text) ?? 0,
                            price: int.tryParse(priceCtrl.text) ?? 0,
                            note: noteCtrl.text,
                            stock: stockCtrl.text,
                          ),
                        );
                      }
                    : null,
                child: Text(
                  widget.itemToEdit == null
                      ? "Tambah Item"
                      : "Simpan Perubahan",
                  style: AppTypography.mediumBoldWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFeedSheet() async {
    final result = await showModalBottomSheet<MonitoringTypeItemModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MonitoringFeedPaginatedBottomSheet(),
    );
    if (result != null) {
      setState(() {
        selectedFeed = result;
        nameCtrl.text = result.name;
        codeCtrl.text = result.code;
        stockCtrl.text = result.quantity.toString();
        priceCtrl.text = result.price.toString();
      });
    }
  }
}
