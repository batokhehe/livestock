import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/theme/AppImages.dart';

import '../../../../core/helpers/utils.dart';
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
      return "Jenis/Ras wajib diisi";
    }

    if (weightCtrl.text.trim().isEmpty) {
      return "Berat hewan wajib diisi";
    }

    if (vaccine && vaccineDate == null) {
      return "Tanggal vaksin wajib diisi";
    }

    if (priceCtrl.text.trim().isEmpty) {
      return "Harga wajib diisi";
    }

    if (gender.isEmpty) {
      return "Jenis kelamin wajib dipilih";
    }

    return null;
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
      priceCtrl.text = data.purchPrice != null
          ? formatPrice(data.purchPrice!)
          : "";
      notesCtrl.text = data.notes ?? "";
      categoryCtrl.text = data.ageCategory?.toString() ?? "";

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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        maxChildSize: 0.95,
        minChildSize: 0.6,
        expand: false,
        builder: (_, controller) {
          return Container(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.greyBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
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
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFields(
                          label: "Kode Ref.Hewan",
                          hint: "Masukkan kode",
                          controller: codeCtrl,
                          isMandatoryField: true,
                          onChanged: (_) => setState(() {}),
                        ),
                        TextFields(
                          label: "Jenis/Ras",
                          hint: "Masukkan jenis/ras",
                          controller: typeCtrl,
                          isMandatoryField: true,
                          onChanged: (_) => setState(() {}),
                        ),
                        TextFields(
                          label: "Berat",
                          hint: "Masukkan berat",
                          controller: weightCtrl,
                          suffix: "kg",
                          isMandatoryField: true,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9\.\,]'),
                            ),
                          ],
                          onChanged: (_) => setState(() {}),
                        ),
                        TextFields(
                          label: "Kategori Umur",
                          hint: "Masukkan kategori umur",
                          controller: categoryCtrl,
                          isMandatoryField: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (_) => setState(() {}),
                        ),
                        AppRadioGroup<bool>(
                          title: 'Sudah Vaksin?',
                          value: vaccine,
                          isMandatoryField: true,
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
                            hint: formatDateTime(vaccineDate),
                            icon: AppImages.icCalendarSearch,
                            isMandatoryField: true,
                            onTap: () async {
                              final pickedDate =
                                  await showModalBottomSheet<DateTime?>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => const CustomDatePickerSheet(
                                      title: "Pilih Tanggal Vaksin",
                                    ),
                                  );

                              if (pickedDate != null) {
                                setState(() {
                                  vaccineDate = pickedDate;
                                });
                              }
                            },
                          ),
                        ],
                        const SizedBox(height: 10),
                        TextFields(
                          label: "Harga Beli",
                          hint: "0",
                          isMandatoryField: true,
                          prefixText: 'Rp ',
                          controller: priceCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter(),
                          ],
                          onChanged: (_) => setState(() {}),
                        ),
                        TextFieldWithInnerCounter(
                          label: 'Catatan',
                          subLabel: '(Optional)',
                          hint: 'Masukkan Catatan',
                          maxLength: 80,
                          controller: notesCtrl,
                        ),
                        const SizedBox(height: 12),
                        SelectField(
                          label: "Jenis Kelamin",
                          hint: gender == "male" ? "Jantan" : "Betina",
                          icon: AppImages.icMan,
                          isMandatoryField: true,
                          onTap: () async {
                            // open bottom sheet
                            final result = await showModalBottomSheet<String>(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (_) =>
                                  GenderBottomSheet(selected: gender),
                            );

                            if (result != null) {
                              setState(() {
                                gender = result;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFields(
                          label: "POEL",
                          hint: "Masukkan POEL",
                          controller: poelCtrl,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Builder(
                  builder: (context) {
                    final isValid = validateForm() == null;

                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isValid
                              ? AppColors.primary
                              : AppColors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isValid
                            ? () {
                                final price =
                                    double.tryParse(
                                      priceCtrl.text.replaceAll('.', ''),
                                    ) ??
                                    0;

                                final item = PurchaseOrderItemRequest(
                                  animalCode: codeCtrl.text,
                                  animalName: typeCtrl.text,
                                  age: int.tryParse(ageCtrl.text),
                                  poel: poelCtrl.text,
                                  gender: gender,
                                  initialWeight: double.tryParse(
                                    weightCtrl.text.replaceAll(',', '.'),
                                  ),
                                  ageCategory: int.tryParse(categoryCtrl.text),
                                  isVaccinated: vaccine,
                                  vaccineDate: vaccineDate,
                                  quantity: 1,
                                  purchPrice: price,
                                  subtotal: price,
                                  total: price,
                                  notes: notesCtrl.text,
                                );

                                Navigator.pop(context, item);
                              }
                            : null,
                        child: Text(
                          widget.initialData == null
                              ? "Tambah Item"
                              : "Simpan Perubahan",
                          style: AppTypography.mediumBoldWhite,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
