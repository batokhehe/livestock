import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../../../../core/helpers/utils.dart';
import '../../../../core/widgets/info_tag.dart';
import '../../data/model/receiving_item_model.dart';

class ReceivingDetailCard extends StatelessWidget {
  final ReceivingItem item;

  const ReceivingDetailCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Dikonfirmasi',
                  style: AppTypography.xSmallNormalBlack.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(item.itemName, style: AppTypography.xSmallNormalGrey),
          const SizedBox(height: 4),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              InfoTag(label: item.ageCategory.toString()),
              InfoTag(label: '${item.receivedWeight} kg'),
              InfoTag(
                label: 'Rp ${formatPrice(double.parse(item.subtotal).toInt())}',
              ),
              if (item.isVaccinated ?? false)
                InfoTag(label: item.vaccineDate.toString()),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            'Ini adalah baris catatan.',
            style: AppTypography.xSmallNormalGrey,
          ),
          const SizedBox(height: 10),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 8),

          /// ===== FOOTER =====
          Text(item.purchOrderNo, style: AppTypography.smallBoldBlack),
          const SizedBox(height: 2),
          Text(
            '${item.receivedWeight} kg',
            style: AppTypography.xSmallNormalGrey,
          ),
          const SizedBox(height: 2),
          Text(item.notes.toString(), style: AppTypography.xSmallNormalGrey),
          const SizedBox(height: 2),
          const Text('Catatan', style: AppTypography.xSmallNormalGrey),
        ],
      ),
    );
  }
}
