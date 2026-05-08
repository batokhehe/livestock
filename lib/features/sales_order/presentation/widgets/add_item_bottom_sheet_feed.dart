import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/feed_medicine_model.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/widgets/feed_medicine_bottom_sheet.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_item_request_model.dart';

import '../../../../app/providers.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/text_field_with_inner_counter.dart';

class AddItemBottomSheetFeed extends ConsumerStatefulWidget {
  const AddItemBottomSheetFeed({super.key});

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
    qtyCtrl.addListener(_onFieldChanged);
    priceCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  bool get _isFormValid {
    final qty = int.tryParse(qtyCtrl.text) ?? 0;
    final priceStr = priceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    final price = double.tryParse(priceStr) ?? 0;
    return selectedFeed != null && qty > 0 && price > 0;
  }

  double get _totalPrice {
    final qty = int.tryParse(qtyCtrl.text) ?? 0;
    final priceStr = priceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    final price = double.tryParse(priceStr) ?? 0;
    return qty * price;
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
    final selectedProvince = ref.watch(selectedProvinceProvider);
    final selectedCity = ref.watch(selectedCityProvider);
    final selectedDistrict = ref.watch(selectedDistrictProvider);
    final selectedVillage = ref.watch(selectedVillageProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      expand: false,
      builder: (_, controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.greyBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tambah Item",
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
                            final result =
                                await showModalBottomSheet<FeedMedicine>(
                                  context: context,
                                  backgroundColor: AppColors.greyBg,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (_) => FeedMedicineBottomSheet(
                                    initialSelectedId: selectedFeed?.id,
                                  ),
                                );

                            if (result != null) {
                              setState(() {
                                selectedFeed = result;
                                nameCtrl.text = result.name;
                                codeCtrl.text = result.code;
                                typeCtrl.text = result.feedType;
                                uomCtrl.text = result.uom;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 16),
                        TextFields(
                          label: "Nama",
                          hint: "Masukkan Nama",
                          controller: nameCtrl,
                          enabled: false,
                        ),
                        TextFields(
                          label: "Kode",
                          hint: "Masukkan kode",
                          controller: codeCtrl,
                          enabled: false,
                        ),
                        TextFields(
                          label: "Tipe Pakan",
                          hint: "Masukkan tipe",
                          controller: typeCtrl,
                          enabled: false,
                        ),
                        TextFields(
                          label: "Satuan",
                          hint: "Masukkan satuan",
                          controller: uomCtrl,
                          enabled: false,
                        ),
                        TextFields(
                          label: "Jumlah",
                          hint: "0",
                          controller: qtyCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        TextFields(
                          label: "Harga Jual",
                          hint: "0",
                          isMandatoryField: true,
                          prefixText: 'Rp ',
                          controller: priceCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter(),
                          ],
                        ),
                        TextFieldWithInnerCounter(
                          label: 'Catatan',
                          subLabel: '(Optional)',
                          hint: 'Masukkan Catatan',
                          maxLength: 80,
                          controller: notesCtrl,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid
                            ? AppColors.primary
                            : AppColors.grey2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isFormValid
                          ? () {
                              final priceStr = priceCtrl.text.replaceAll(
                                RegExp(r'[^0-9]'),
                                '',
                              );
                              final price = double.tryParse(priceStr) ?? 0;

                              final item = SalesOrderItemRequest(
                                feedMedicine: selectedFeed!,
                                qty: int.tryParse(qtyCtrl.text) ?? 0,
                                unitPrice: price,
                                discount: 0,
                                subtotal: _totalPrice,
                                dlvDate: deliveryDate,
                                deliveryAddress: '',
                                uom: uomCtrl.text,

                                stateId: selectedProvince?.code,
                                state: selectedProvince?.name,
                                cityId: selectedCity?.code,
                                city: selectedCity?.name,
                                districtId: selectedDistrict?.code,
                                district: selectedDistrict?.name,
                                villageId: selectedVillage?.code,
                                village: selectedVillage?.name,
                                note: notesCtrl.text,
                              );

                              Navigator.pop(context, item);
                            }
                          : null,
                      child: Text(
                        "Tambah Item",
                        style: AppTypography.mediumBoldWhite,
                      ),
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
