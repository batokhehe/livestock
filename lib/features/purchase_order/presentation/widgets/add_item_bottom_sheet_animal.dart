import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/theme/AppImages.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/custom_date_picker_sheet.dart';
import '../../../../core/widgets/gender_bottom_sheet.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/text_field_with_inner_counter.dart';
import '../../data/model/purchase_order_item_request_model.dart';

class AddItemBottomSheetAnimal extends ConsumerStatefulWidget {
  final PurchaseOrderItemRequest? initialData;

  const AddItemBottomSheetAnimal({super.key, this.initialData});

  @override
  ConsumerState<AddItemBottomSheetAnimal> createState() =>
      _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends ConsumerState<AddItemBottomSheetAnimal> {
  String? validateForm() {
    if (codeCtrl.text.trim().isEmpty) {
      return "Kode hewan wajib diisi";
    }

    if (typeCtrl.text.trim().isEmpty) {
      return "Jenis/Ras hewan wajib diisi";
    }

    if (categoryCtrl.text.trim().isEmpty) {
      return "Kategori umur wajib diisi";
    }

    if (weightCtrl.text.trim().isEmpty) {
      return "Berat hewan wajib diisi";
    }

    if (ageCtrl.text.trim().isEmpty) {
      return "Umur hewan wajib diisi";
    }

    if (priceCtrl.text.trim().isEmpty) {
      return "Harga wajib diisi";
    }

    if (vaccine && vaccineDate == null) {
      return "Tanggal vaksin wajib diisi";
    }

    return null; // ✅ valid
  }

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
  String gender = "male";
  DateTime? vaccineDate;

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      final data = widget.initialData!;

      codeCtrl.text = data.animalCode ?? "";
      typeCtrl.text = data.animalName ?? "";
      poelCtrl.text = data.poel ?? "";
      weightCtrl.text = data.initialWeight?.toString() ?? "";
      ageCtrl.text = data.age?.toString() ?? "";
      priceCtrl.text = data.purchPrice?.toString() ?? "";
      notesCtrl.text = data.notes ?? "";
      categoryCtrl.text = data.ageCategory.toString() ?? "";

      gender = data.gender ?? "male";
      vaccine = data.isVaccinated ?? false;
      vaccineDate = data.vaccineDate;
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
                    Text(
                      widget.initialData == null ? "Tambah Item" : "Edit Item",
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextFields(
                  label: "Kode Ref.Hewan",
                  hint: "Masukkan Kode",
                  controller: codeCtrl,
                ),
                const SizedBox(height: 6),
                TextFields(
                  label: "Jenis/Ras Hewan",
                  hint: "Masukkan jenis",
                  controller: typeCtrl,
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    // open bottom sheet
                    final result = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => GenderBottomSheet(selected: gender),
                    );

                    if (result != null) {
                      setState(() {
                        gender = result;
                      });
                    }
                  },
                  child: Dropdowns(
                    label: "Jenis Kelamin",
                    value: gender == "male" ? "Jantan" : "Betina",
                    icon: AppImages.icMan,
                    enabled: false,
                  ),
                ),
                const SizedBox(height: 6),
                TextFields(
                  label: "Kategori Umur Hewan",
                  hint: "Masukkan kategori",
                  controller: categoryCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 6),
                TextFields(
                  label: "Berat Hewan",
                  hint: "Masukkan berat",
                  controller: weightCtrl,
                  suffix: "kg",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 6),
                TextFields(
                  label: "Umur Hewan",
                  hint: "Masukkan umur",
                  controller: ageCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 6),
                AppRadioGroup<bool>(
                  title: 'Sudah Vaksin?',
                  value: vaccine,
                  options: const [true, false],
                  labelBuilder: (v) => v ? 'Ya' : 'Tidak',
                  onChanged: (v) {
                    setState(() {
                      vaccine = v;
                    });
                  },
                ),
                if (vaccine) ...[
                  const SizedBox(height: 6),
                  SelectField(
                    label: "Tanggal Vaksin",
                    hint: vaccineDate != null
                        ? "${vaccineDate!.day}/${vaccineDate!.month}/${vaccineDate!.year}"
                        : "Pilih tanggal",
                    icon: AppImages.icCalendarSearch,
                    onTap: () async {
                      final pickedDate = await showModalBottomSheet<DateTime?>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const CustomDatePickerSheet(),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          vaccineDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
                const SizedBox(height: 6),
                TextFields(
                  label: "Harga Beli Hewan",
                  hint: "Masukkan harga",
                  controller: priceCtrl,
                  suffix: "Rp",
                ),
                const SizedBox(height: 6),
                TextFields(
                  label: "POEL",
                  hint: "Masukkan POEL",
                  controller: poelCtrl,
                ),
                const SizedBox(height: 6),
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
                      final error = validateForm();

                      if (error != null) {
                        final messenger = ScaffoldMessenger.of(context);

                        messenger.clearSnackBars();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(error),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final item = PurchaseOrderItemRequest(
                        animalCode: codeCtrl.text,
                        animalName: typeCtrl.text,
                        age: int.tryParse(ageCtrl.text),
                        poel: poelCtrl.text,
                        gender: gender,
                        initialWeight: double.tryParse(weightCtrl.text),
                        ageCategory: int.tryParse(categoryCtrl.text),
                        isVaccinated: vaccine,
                        vaccineDate: vaccineDate,
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
