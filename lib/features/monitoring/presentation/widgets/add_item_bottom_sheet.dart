import 'package:flutter/material.dart';

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
  final stockCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  MonitoringTypeItemModel? selectedFeed;

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
            controller: qtyCtrl,
          ),
          TextFields(label: "Kode", hint: "Kode", controller: qtyCtrl),
          TextFields(
            label: "Kuantitas Tersedia",
            hint: "Jumlah Kuantitas Tersedia",
            controller: qtyCtrl,
          ),
          TextFields(
            label: "Harga Satuan",
            hint: "Masukkan Harga Satuan",
            controller: priceCtrl,
          ),
          const SizedBox(height: 16),
          TextFields(
            label: "Jumlah Pakan",
            hint: "Jumlah Pakan",
            controller: priceCtrl,
          ),
          TextFields(
            label: "Harga Total",
            hint: "Harga Total",
            controller: priceCtrl,
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
              onPressed: () {
                Navigator.pop(
                  context,
                  MonitoringItem(
                    name: nameCtrl.text,
                    unit: "Pakan",
                    quantity: int.tryParse(qtyCtrl.text) ?? 0,
                    price: int.tryParse(priceCtrl.text) ?? 0,
                    note: noteCtrl.text,
                    stock: stockCtrl.text,
                  ),
                );
              },
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
        stockCtrl.text = result.quantity.toString();
      });
    }
  }
}
