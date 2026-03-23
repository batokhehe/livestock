import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/feed_medicine_model.dart';
import 'package:livestock/core/widgets/feed_medicine_bottom_sheet.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_item_request_model.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/text_field_with_inner_counter.dart';

class AddItemBottomSheetFeed extends ConsumerStatefulWidget {
  final PurchaseOrderItemRequest? initialData;

  const AddItemBottomSheetFeed({super.key, this.initialData});

  @override
  ConsumerState<AddItemBottomSheetFeed> createState() =>
      _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends ConsumerState<AddItemBottomSheetFeed> {
  final nameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final typeCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final uomCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  DateTime? deliveryDate;
  FeedMedicine? selectedFeed;

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      final data = widget.initialData!;

      selectedFeed = data.feedMedicine;

      nameCtrl.text = data.feedMedicineName ?? '';
      typeCtrl.text = data.feedMedicineType ?? '';
      codeCtrl.text = data.feedMedicineCode ?? '';
      qtyCtrl.text = data.quantity?.toString() ?? '';
      priceCtrl.text = data.purchPrice?.toString() ?? '';
      notesCtrl.text = data.notes ?? '';
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    codeCtrl.dispose();
    typeCtrl.dispose();
    qtyCtrl.dispose();
    uomCtrl.dispose();
    priceCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      expand: false,
      builder: (_, controller) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).padding.bottom + 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== HEADER =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.initialData == null ? "Tambah Item" : "Edit Item",
                      style: AppTypography.largeBoldBlack,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SelectField(
                  label: "Pakan/Obat",
                  hint: selectedFeed?.name ?? "Pilih Pakan/Obat",
                  icon: AppImages.icProduct,
                  onTap: () async {
                    final result = await showModalBottomSheet<FeedMedicine>(
                      context: context,
                      backgroundColor: AppColors.greyBg,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => const FeedMedicineBottomSheet(),
                    );

                    if (result != null) {
                      setState(() {
                        selectedFeed = result;

                        nameCtrl.text = result.name ?? '';
                        typeCtrl.text = result.feedType ?? '';
                        codeCtrl.text = result.code ?? '';
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),
                TextFields(
                  label: "Nama",
                  hint: "Masukkan Nama",
                  controller: nameCtrl,
                ),
                TextFields(
                  label: "Tipe Pakan",
                  hint: "Masukkan tipe",
                  controller: typeCtrl,
                ),
                TextFields(
                  label: "Jumlah",
                  hint: "0",
                  controller: qtyCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                TextFields(
                  label: "Satuan",
                  hint: "Masukkan satuan",
                  controller: uomCtrl,
                ),
                TextFields(
                  label: "Harga Beli",
                  hint: "0",
                  suffix: "Rp.",
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                TextFieldWithInnerCounter(
                  label: 'Catatan',
                  subLabel: '(Optional)',
                  hint: 'Masukkan Catatan',
                  maxLength: 80,
                  controller: notesCtrl,
                ),

                const SizedBox(height: 24),

                // ===== BUTTON =====
                SizedBox(
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
                      if (selectedFeed == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Pilih pakan/obat dulu"),
                          ),
                        );
                        return;
                      }

                      if (qtyCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Jumlah wajib diisi")),
                        );
                        return;
                      }
                      final item = PurchaseOrderItemRequest(
                        feedMedicine: selectedFeed,
                        feedMedicineCode: codeCtrl.text,
                        feedMedicineName: nameCtrl.text,
                        feedMedicineType: typeCtrl.text,
                        quantity: int.tryParse(qtyCtrl.text),
                        purchPrice: double.tryParse(priceCtrl.text),
                        subtotal: 0,
                        total: 0,
                        notes: notesCtrl.text,
                      );
                      Navigator.pop(context, item);
                    },
                    child: Text(
                      widget.initialData == null
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
      },
    );
  }
}
