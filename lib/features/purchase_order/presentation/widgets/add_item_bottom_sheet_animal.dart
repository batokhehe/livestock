import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/theme/AppImages.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../../core/widgets/text_field_with_inner_counter.dart';
import '../../data/model/purchase_order_item_request_model.dart';

class AddItemBottomSheetAnimal extends ConsumerStatefulWidget {
  const AddItemBottomSheetAnimal({super.key});

  @override
  ConsumerState<AddItemBottomSheetAnimal> createState() =>
      _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends ConsumerState<AddItemBottomSheetAnimal> {
  final nameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final typeCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final uomCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final poelCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  bool vaccine = true;

  DateTime? deliveryDate;

  @override
  void initState() {
    super.initState();
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
    poelCtrl.dispose();
    categoryCtrl.dispose();
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
                    Text("Tambah Item", style: AppTypography.largeBoldBlack),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFields(
                  label: "Kode Ref.Hewan",
                  hint: "Masukkan Kode",
                  controller: codeCtrl,
                ),
                const SizedBox(height: 16),
                TextFields(
                  label: "Jenis/Ras Hewan",
                  hint: "Masukkan jenis",
                  controller: typeCtrl,
                ),
                const SizedBox(height: 16),
                Dropdowns(
                  label: "Jenis Kelamin",
                  value: "Jantan",
                  icon: AppImages.icMan,
                  enabled: false,
                ),
                const SizedBox(height: 16),
                TextFields(
                  label: "Kategoi Umur Hewan",
                  hint: "Masukkan kategori",
                  controller: categoryCtrl,
                ),
                const SizedBox(height: 16),
                TextFields(
                  label: "Berat Hewan",
                  hint: "Masukkan berat",
                  controller: weightCtrl,
                  suffix: "kg",
                ),
                const SizedBox(height: 16),
                TextFields(
                  label: "Umur Hewan",
                  hint: "Masukkan umur",
                  controller: ageCtrl,
                ),
                const SizedBox(height: 16),
                TextFields(
                  label: "Harga Beli Hewan",
                  hint: "Masukkan harga",
                  controller: priceCtrl,
                  suffix: "Rp",
                ),
                const SizedBox(height: 16),
                TextFields(
                  label: "POEL",
                  hint: "Masukkan POEL",
                  controller: poelCtrl,
                ),
                const SizedBox(height: 16),
                AppRadioGroup<bool>(
                  title: 'Sudah Vaksin?',
                  value: vaccine,
                  options: const [true, false],
                  labelBuilder: (v) => v ? 'Ya' : 'Tidak',
                  onChanged: (v) => vaccine = v,
                ),
                const SizedBox(height: 16),
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
                      final item = PurchaseOrderItemRequest(
                        animalCode: codeCtrl.text,
                        animalName: typeCtrl.text,
                        poel: poelCtrl.text,
                        gender: "male",
                        initialWeight: double.tryParse(weightCtrl.text),
                        ageCategory: int.tryParse(ageCtrl.text),
                        isVaccinated: vaccine,
                        purchPrice: double.tryParse(priceCtrl.text),
                        subtotal: 0,
                        total: 0,
                        notes: notesCtrl.text,
                      );

                      Navigator.pop(context, item);
                    },
                    child: Text(
                      "Tambah Item",
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
