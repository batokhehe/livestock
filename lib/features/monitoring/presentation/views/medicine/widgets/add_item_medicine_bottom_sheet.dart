import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/helpers/utils.dart';
import '../../../../../../core/theme/AppColors.dart';
import '../../../../../../core/theme/AppImages.dart';
import '../../../../../../core/theme/AppTypography.dart';
import '../../../../../../core/widgets/input_field_card.dart';
import '../../../../../../core/widgets/select_field.dart';
import '../../../../../../core/widgets/text_field_with_inner_counter.dart';
import '../../../../data/monitoring_item_model.dart';
import '../../../../monitoring_provider.dart';
import '../../../widgets/monitoring_medicine_paginated_bottom_sheet.dart';

class AddItemMedicineBottomSheet extends ConsumerStatefulWidget {
  const AddItemMedicineBottomSheet({super.key});

  @override
  ConsumerState<AddItemMedicineBottomSheet> createState() =>
      _AddItemMedicineBottomSheetState();
}

class _AddItemMedicineBottomSheetState
    extends ConsumerState<AddItemMedicineBottomSheet> {
  final qtyCtrl = TextEditingController();
  final jumlahCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  bool get _isValid {
    final selectedObat = ref.read(selectedMonitoringMedicineProvider);
    if (selectedObat == null) return false;

    final qtyText = qtyCtrl.text.replaceAll(',', '.');
    final qty = double.tryParse(qtyText) ?? 0.0;
    final stock = selectedObat.quantity.toDouble();

    return qty > 0.0 && qty <= stock;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(selectedMonitoringMedicineProvider.notifier).state = null;
      }
    });
    qtyCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    qtyCtrl.dispose();
    jumlahCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  void _openObatSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MonitoringMedicinePaginatedBottomSheet(),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, size: 24, color: Colors.grey.shade800),
          ),
        ),
      ),
    );
  }

  Widget _buildQtyField(double stock, bool hasObat) {
    final qtyText = qtyCtrl.text.replaceAll(',', '.');
    final qty = double.tryParse(qtyText) ?? 0.0;
    final isExceeded = hasObat && qty > stock;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Kuantitas", style: AppTypography.smallBoldBlack),
              const Text('*', style: AppTypography.smallBoldRed),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: hasObat ? Colors.white : AppColors.greyBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isExceeded
                          ? AppColors.danger
                          : (hasObat ? AppColors.fieldBorder : AppColors.grey2),
                      width: isExceeded ? 1.5 : 1.0,
                    ),
                  ),
                  child: TextFormField(
                    controller: qtyCtrl,
                    enabled: hasObat,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    style: hasObat
                        ? AppTypography.smallBoldBlack
                        : AppTypography.smallBoldGrey,
                    decoration: const InputDecoration(
                      hintText: "Jumlah kuantitas",
                      hintStyle: AppTypography.hint,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              if (hasObat) ...[
                const SizedBox(width: 12),
                _buildCircleButton(
                  icon: Icons.keyboard_arrow_down,
                  onTap: () {
                    final currentText = qtyCtrl.text.replaceAll(',', '.');
                    double currentQty = double.tryParse(currentText) ?? 0.0;
                    if (currentQty >= 0.01) {
                      currentQty -= 0.01;
                      String formattedQty = currentQty.toStringAsFixed(2);
                      if (formattedQty.endsWith('0')) {
                        formattedQty = formattedQty.substring(
                          0,
                          formattedQty.length - 1,
                        );
                      }
                      if (formattedQty.endsWith('.0')) {
                        formattedQty = formattedQty.substring(
                          0,
                          formattedQty.length - 2,
                        );
                      }
                      qtyCtrl.text = formattedQty.replaceAll('.', ',');
                    } else {
                      qtyCtrl.text = "0";
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(width: 8),
                _buildCircleButton(
                  icon: Icons.keyboard_arrow_up,
                  onTap: () {
                    final currentText = qtyCtrl.text.replaceAll(',', '.');
                    double currentQty = double.tryParse(currentText) ?? 0.0;
                    currentQty += 0.01;
                    String formattedQty = currentQty.toStringAsFixed(2);
                    if (formattedQty.endsWith('0')) {
                      formattedQty = formattedQty.substring(
                        0,
                        formattedQty.length - 1,
                      );
                    }
                    if (formattedQty.endsWith('.0')) {
                      formattedQty = formattedQty.substring(
                        0,
                        formattedQty.length - 2,
                      );
                    }
                    qtyCtrl.text = formattedQty.replaceAll('.', ',');
                    setState(() {});
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Stok tersedia: ${stock.toStringAsFixed(stock.truncateToDouble() == stock ? 0 : 2)}",
            style: AppTypography.smallNormalGrey,
          ),
          if (isExceeded) ...[
            const SizedBox(height: 4),
            const Text(
              "Kuantitas melebihi stok tersedia",
              style: TextStyle(
                color: AppColors.danger,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedObat = ref.watch(selectedMonitoringMedicineProvider);
    final stock = selectedObat?.quantity.toDouble() ?? 0.0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
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
                const Text("Tambah Item", style: AppTypography.largeBoldBlack),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.cancel_outlined),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SelectField(
              label: "Obat",
              hint: selectedObat?.name ?? "Pilih obat",
              style: selectedObat != null ? AppTypography.smallNormalBlack : null,
              icon: AppImages.icProduct,
              isMandatoryField: true,
              onTap: _openObatSheet,
            ),
            const SizedBox(height: 8),
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
                        const Text(
                          "Nama Obat",
                          style: AppTypography.smallNormalGrey,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedObat?.name.isEmpty ?? true
                              ? "-"
                              : selectedObat!.name,
                          style: AppTypography.smallBoldBlack,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Kuantitas Tersedia",
                          style: AppTypography.smallNormalGrey,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedObat == null
                              ? "0"
                              : selectedObat.quantity.toString(),
                          style: AppTypography.smallBoldBlack,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kode",
                          style: AppTypography.smallNormalGrey,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedObat?.code.isEmpty ?? true
                              ? "-"
                              : selectedObat!.code,
                          style: AppTypography.smallBoldBlack,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Harga Satuan",
                          style: AppTypography.smallNormalGrey,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedObat == null
                              ? "Rp 0"
                              : "Rp ${formatPrice(selectedObat.price)}",
                          style: AppTypography.smallBoldBlack,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // _buildQtyField(stock, selectedObat != null),
            TextFields(
              label: "Kuantitas",
              hint: "Kuantitas",
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            TextFieldWithInnerCounter(
              label: "Catatan",
              subLabel: "(Opsional)",
              hint: "Masukkan catatan",
              maxLength: 80,
              controller: noteCtrl,
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.grey3,
                  disabledForegroundColor: AppColors.white,
                  padding: const EdgeInsets.all(14),
                  elevation: _isValid ? 2 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isValid
                    ? () {
                        Navigator.pop(
                          context,
                          MonitoringItem(
                            name: selectedObat?.name,
                            code: selectedObat?.code,
                            unit: selectedObat?.uom.isNotEmpty == true
                                ? selectedObat!.uom
                                : "Botol",
                            price: selectedObat?.price,
                            quantity: double.tryParse(
                              qtyCtrl.text.replaceAll(',', '.'),
                            ),
                            note: noteCtrl.text.isEmpty ? null : noteCtrl.text,
                            stock: selectedObat?.quantity.toString() ?? "0",
                          ),
                        );
                      }
                    : null,
                child: const Text("Tambah Item", style: AppTypography.mediumBoldWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
