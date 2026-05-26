import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/theme/AppColors.dart';
import '../../../../../../core/theme/AppImages.dart';
import '../../../../../../core/theme/AppTypography.dart';
import '../../../../../../core/widgets/input_field_card.dart';
import '../../../../../../core/widgets/text_field_with_inner_counter.dart';
import '../../../../data/monitoring_item_model.dart';

class AddItemMedicineBottomSheet extends StatefulWidget {
  const AddItemMedicineBottomSheet({super.key});

  @override
  State<AddItemMedicineBottomSheet> createState() =>
      _AddItemMedicineBottomSheetState();
}

class _AddItemMedicineBottomSheetState
    extends State<AddItemMedicineBottomSheet> {
  final qtyCtrl = TextEditingController();
  final jumlahCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  String? selectedObatName;

  bool get _isValid =>
      selectedObatName != null &&
      (int.tryParse(qtyCtrl.text) ?? 0) > 0 &&
      (int.tryParse(jumlahCtrl.text) ?? 0) > 0;

  @override
  void initState() {
    super.initState();
    qtyCtrl.addListener(() => setState(() {}));
    jumlahCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    qtyCtrl.dispose();
    jumlahCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  void _openObatSheet() async {
    // TODO: ganti dengan paginated bottom sheet obat
    // final result = await showModalBottomSheet<MedicineItemModel>(...);
    // if (result != null) setState(() => selectedObatName = result.name);
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
              Text("Tambah Item", style: AppTypography.largeBoldBlack),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.cancel_outlined),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Dropdowns(
            label: "Obat",
            value: selectedObatName ?? "Pilih obat",
            icon: AppImages.icProduct,
            onTap: _openObatSheet,
          ),
          TextFields(
            label: "Kuantitas",
            hint: "Jumlah kuantitas",
            controller: qtyCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            isMandatoryField: true,
          ),
          TextFieldWithInnerCounter(
            label: "Catatan",
            subLabel: "(Opsional)",
            hint: "Masukkan catatan",
            maxLength: 80,
            controller: noteCtrl,
          ),
          const SizedBox(height: 4),
          TextFields(
            label: "Jumlah Obat",
            hint: "Masukkan jumlah",
            controller: jumlahCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            isMandatoryField: true,
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
                          name: selectedObatName,
                          quantity: int.tryParse(qtyCtrl.text),
                          note: noteCtrl.text.isEmpty ? null : noteCtrl.text,
                          stock: jumlahCtrl.text,
                        ),
                      );
                    }
                  : null,
              child: Text("Tambah Item", style: AppTypography.mediumBoldWhite),
            ),
          ),
        ],
      ),
    );
  }
}
