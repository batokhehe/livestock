import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/AppColors.dart';
import '../../../../../../core/theme/AppImages.dart';
import '../../../../../../core/theme/AppTypography.dart';
import '../../../../../../core/widgets/select_field.dart';
import '../../../../../../core/widgets/text_field_with_inner_counter.dart';
import '../../../../data/monitoring_item_model.dart';
import '../../../../data/monitoring_type_item_model.dart';
import '../../../../monitoring_provider.dart';
import 'monitoring_health_medicine_paginated_bottom_sheet.dart';

class EditItemHealthBottomSheet extends ConsumerStatefulWidget {
  final MonitoringItem itemToEdit;
  const EditItemHealthBottomSheet({super.key, required this.itemToEdit});

  @override
  ConsumerState<EditItemHealthBottomSheet> createState() =>
      _EditItemHealthBottomSheetState();
}

class _EditItemHealthBottomSheetState
    extends ConsumerState<EditItemHealthBottomSheet> {
  final qtyCtrl = TextEditingController();
  final jumlahCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  bool get _isValid {
    final selectedObat = ref.read(selectedMonitoringMedicineProvider);
    if (selectedObat == null) return false;

    final qtyText = qtyCtrl.text.replaceAll(',', '.');
    final qty = double.tryParse(qtyText) ?? 0.0;

    return qty > 0.0;
  }

  @override
  void initState() {
    super.initState();
    final item = widget.itemToEdit;
    qtyCtrl.text =
        item.quantity
            ?.toStringAsFixed(
              item.quantity!.truncateToDouble() == item.quantity ? 0 : 2,
            )
            .replaceAll('.', ',') ??
        '';
    noteCtrl.text = item.note ?? '';
    jumlahCtrl.text = item.code ?? '';

    Future.microtask(() {
      if (mounted) {
        ref
            .read(selectedMonitoringMedicineProvider.notifier)
            .state = MonitoringTypeItemModel(
          name: item.name ?? '',
          code: item.code ?? '',
          quantity: 0,
          uom: item.unit ?? '',
        );
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
      builder: (_) => const MonitoringHealthMedicinePaginatedBottomSheet(),
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

  Widget _buildQtyField(bool hasObat) {
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
                      color: hasObat ? AppColors.fieldBorder : AppColors.grey2,
                      width: 1.0,
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch location provider to keep it alive
    ref.watch(selectedMonitoringFarmProvider);

    final selectedObat = ref.watch(selectedMonitoringMedicineProvider);

    if (selectedObat != null) {
      if (jumlahCtrl.text != selectedObat.code) {
        jumlahCtrl.text = selectedObat.code;
        qtyCtrl.text = "";
      }
    }

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Ubah Item", style: AppTypography.largeBoldBlack),
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
          _buildQtyField(selectedObat != null),
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
                          id: widget.itemToEdit.id,
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
                          stock: "0",
                        ),
                      );
                    }
                  : null,
              child: const Text(
                "Simpan Perubahan",
                style: AppTypography.mediumBoldWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
