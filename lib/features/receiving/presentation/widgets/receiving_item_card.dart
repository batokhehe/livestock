import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../../../../core/theme/AppColors.dart';
import '../../data/model/receiving_list_model.dart';

class ReceivingItemCard extends StatelessWidget {
  final ReceivingList item;

  const ReceivingItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isReceived = item.receiveStatus == 'received';

    final Color statusColor = isReceived
        ? AppColors.success
        : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ROW ATAS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.stockCode, style: AppTypography.smallBoldBlack),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  item.receiveStatus,
                  style: AppTypography.xSmallNormalPrimary.copyWith(
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${item.quantity} • ${item.locationName}',
                style: AppTypography.xSmallNormalBlack,
              ),
              Text(
                '${item.quantity} Diterima',
                style: AppTypography.xSmallNormalBlack,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
