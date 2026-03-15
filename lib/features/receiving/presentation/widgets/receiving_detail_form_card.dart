import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import 'package:livestock/core/widgets/input_field.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';

import '../../../../core/helpers/utils.dart';
import '../../data/model/receiving_item_model.dart';

class ReceivingDetailFormCard extends StatelessWidget {
  final ReceivingItem item;
  final VoidCallback onToggle;
  final ValueChanged<String>? onItemCodeChanged;
  final ValueChanged<String>? onWeightChanged;
  final ValueChanged<String>? onNotesChanged;

  const ReceivingDetailFormCard({
    super.key,
    required this.item,
    required this.onToggle,
    this.onItemCodeChanged,
    this.onWeightChanged,
    this.onNotesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasInput =
        onItemCodeChanged != null ||
        onWeightChanged != null ||
        onNotesChanged != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.purchOrderNo, style: AppTypography.smallBoldBlack),

              /// ✅ CHECKLIST
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: item.selected
                        ? AppColors.success.withOpacity(0.15)
                        : AppColors.fieldBorder.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.selected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: item.selected ? AppColors.success : AppColors.grey,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(item.itemName, style: AppTypography.xSmallNormalGrey),

          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              InfoTag(
                label: 'Rp ${formatPrice(double.parse(item.subtotal).toInt())}',
              ),
            ],
          ),

          /// ✅ INPUT (HANYA JIKA ADA)
          if (hasInput) ...[
            const SizedBox(height: 8),
            Divider(height: 1, color: AppColors.fieldBorder),
            const SizedBox(height: 8),

            Opacity(
              opacity: item.selected ? 1 : 0.5,
              child: IgnorePointer(
                ignoring: !item.selected,
                child: Column(
                  children: [
                    if (onItemCodeChanged != null)
                      InputField(
                        label: "Kode Hewan",
                        hint: "Masukkan kode",
                        onChanged: onItemCodeChanged,
                        initialValue: item.itemCode,
                      ),

                    if (onWeightChanged != null) ...[
                      const SizedBox(height: 8),
                      InputField(
                        label: "Berat Diterima",
                        hint: "Berat",
                        suffix: "Kg",
                        keyboardType: TextInputType.number,
                        onChanged: onWeightChanged,
                      ),
                    ],

                    if (onNotesChanged != null) ...[
                      const SizedBox(height: 8),
                      TextFieldWithInnerCounter(
                        label: 'Catatan',
                        subLabel: '(Optional)',
                        hint: 'Masukkan Catatan',
                        maxLength: 80,
                        onChanged: onNotesChanged,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
