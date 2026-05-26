import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../../core/widgets/text_field_with_inner_counter.dart';
import '../../data/monitoring_item_model.dart';
import '../../data/monitoring_type_item_model.dart';
import 'monitoring_feed_paginated_bottom_sheet.dart';

class AddItemBottomSheet extends StatefulWidget {
  const AddItemBottomSheet({super.key});

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
    qtyCtrl.addListener(_calculateTotal);
    priceCtrl.addListener(_calculateTotal);
  }

  void _calculateTotal() {
    int qty = int.tryParse(qtyCtrl.text) ?? 0;
    final stock = selectedFeed?.quantity ?? 0;

    bool qtyChanged = false;
    if (qty > stock) {
      qty = stock;
      qtyChanged = true;
    }

    final price = int.tryParse(priceCtrl.text) ?? 0;
    final newTotal = (qty > 0 && price > 0) ? (qty * price).toString() : "0";

    if (totalPriceCtrl.text != newTotal) {
      totalPriceCtrl.text = newTotal;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tambah Item", style: AppTypography.largeBoldBlack),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Dropdowns(
            label: "Pakan",
            value: selectedFeed == null ? "Pilih Pakan" : selectedFeed!.name,
            icon: AppImages.icProduct,
            onTap: _openFeedSheet,
          ),
          TextFields(
            label: "Nama Pakan",
            hint: "Nama Pakan",
            controller: nameCtrl,
            enabled: false,
          ),
          TextFields(
            label: "Kode",
            hint: "Kode",
            controller: codeCtrl,
            enabled: false,
          ),
          TextFields(
            label: "Kuantitas Tersedia",
            hint: "Jumlah Kuantitas Tersedia",
            controller: stockCtrl,
            enabled: false,
          ),
          TextFields(
            label: "Harga Satuan",
            hint: "Masukkan Harga Satuan",
            controller: priceCtrl,
            enabled: false,
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
            enabled: false,
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
              onPressed: (int.tryParse(qtyCtrl.text) ?? 0) > 0 ? () {
                Navigator.pop(
                  context,
                  MonitoringItem(
                    name: nameCtrl.text,
                    code: codeCtrl.text,
                    unit: selectedFeed?.uom.isNotEmpty == true ? selectedFeed!.uom : "Pakan",
                    quantity: int.tryParse(qtyCtrl.text) ?? 0,
                    price: int.tryParse(priceCtrl.text) ?? 0,
                    note: noteCtrl.text,
                    stock: stockCtrl.text,
                  ),
                );
              } : null,
              child: Text("Tambah Item", style: AppTypography.mediumBoldWhite),
            ),
          ),
        ],
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
