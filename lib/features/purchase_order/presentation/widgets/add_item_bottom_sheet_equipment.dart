import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/equipment_model.dart';
import 'package:livestock/core/widgets/equipment_bottom_sheet.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_item_request_model.dart';

import '../../../../core/helpers/utils.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/text_field_with_inner_counter.dart';

class AddItemBottomSheetEquipment extends ConsumerStatefulWidget {
  final PurchaseOrderItemRequest? initialData;

  const AddItemBottomSheetEquipment({super.key, this.initialData});

  @override
  ConsumerState<AddItemBottomSheetEquipment> createState() =>
      _AddItemBottomSheetEquipmentState();
}

class _AddItemBottomSheetEquipmentState
    extends ConsumerState<AddItemBottomSheetEquipment> {
  final nameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  Equipment? selectedEquipment;

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      final data = widget.initialData!;

      if (data.equipmentId != null || data.equipmentName != null) {
        selectedEquipment = Equipment(
          id: data.equipmentId ?? 0,
          name: data.equipmentName ?? '',
          code: data.equipmentCode ?? '',
        );
      }

      nameCtrl.text = data.equipmentName ?? '';
      codeCtrl.text = data.equipmentCode ?? '';
      qtyCtrl.text = data.quantity?.toString() ?? '';
      priceCtrl.text =
          data.purchPrice != null ? formatPrice(data.purchPrice!) : '';
      notesCtrl.text = data.notes ?? '';
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    codeCtrl.dispose();
    qtyCtrl.dispose();
    priceCtrl.dispose();
    notesCtrl.dispose();
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                              widget.initialData == null
                                  ? "Tambah Item Peralatan"
                                  : "Edit Item Peralatan",
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
                          label: "Peralatan",
                          hint: selectedEquipment?.name.isNotEmpty == true
                              ? selectedEquipment!.name
                              : "Pilih Peralatan",
                          icon: AppImages.icProduct,
                          isMandatoryField: true,
                          onTap: () async {
                            final result =
                                await showModalBottomSheet<Equipment>(
                              context: context,
                              backgroundColor: AppColors.greyBg,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (_) => EquipmentBottomSheet(
                                initialSelectedId: selectedEquipment?.id,
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                selectedEquipment = result;
                                nameCtrl.text = result.name;
                                codeCtrl.text = result.code;
                                if (result.price != null && result.price! > 0) {
                                  priceCtrl.text = formatPrice(result.price!);
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFields(
                          label: "Nama Peralatan",
                          hint: "Masukkan Nama Peralatan",
                          isMandatoryField: true,
                          controller: nameCtrl,
                          enabled: false,
                        ),
                        TextFields(
                          label: "Kode Peralatan",
                          hint: "Kode peralatan",
                          isMandatoryField: false,
                          controller: codeCtrl,
                          enabled: false,
                        ),
                        TextFields(
                          label: "Jumlah",
                          hint: "0",
                          isMandatoryField: true,
                          controller: qtyCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (_) => setState(() {}),
                        ),
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
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (nameCtrl.text.trim().isEmpty ||
                              qtyCtrl.text.isEmpty ||
                              priceCtrl.text.isEmpty)
                          ? AppColors.grey
                          : AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: (nameCtrl.text.trim().isEmpty ||
                            qtyCtrl.text.isEmpty ||
                            priceCtrl.text.isEmpty)
                        ? null
                        : () {
                            if (nameCtrl.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Pilih peralatan dulu"),
                                ),
                              );
                              return;
                            }

                            if (qtyCtrl.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Jumlah wajib diisi"),
                                ),
                              );
                              return;
                            }

                            if (priceCtrl.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Harga Beli wajib diisi"),
                                ),
                              );
                              return;
                            }

                            final qty = int.tryParse(qtyCtrl.text) ?? 0;
                            final price = double.tryParse(
                                  priceCtrl.text.replaceAll('.', ''),
                                ) ??
                                0;
                            final subtotal = qty * price;

                            final item = PurchaseOrderItemRequest(
                              equipmentId: selectedEquipment?.id,
                              equipmentCode: codeCtrl.text.isNotEmpty
                                  ? codeCtrl.text
                                  : selectedEquipment?.code,
                              equipmentName: nameCtrl.text.isNotEmpty
                                  ? nameCtrl.text
                                  : selectedEquipment?.name,
                              quantity: qty,
                              purchPrice: price,
                              subtotal: subtotal,
                              total: subtotal,
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
          );
        },
      ),
    );
  }
}
