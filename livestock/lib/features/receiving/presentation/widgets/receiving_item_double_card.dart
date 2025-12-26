import 'package:flutter/material.dart';

import '../../../../core/constant/enum.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../data/receiving_model.dart';

class ReceivingItemDoubleCard extends StatelessWidget {
  final Receiving item;

  const ReceivingItemDoubleCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isReceived =
        item.status == ItemStatus.received ||
        item.status == ItemStatus.confirmed;

    final Color statusColor = isReceived
        ? AppColors.success
        : AppColors.primary;

    final String statusText = isReceived ? 'Diterima' : 'Menunggu';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.code, style: AppTypography.smallBoldBlack),
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
                        statusText,
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
                      '${item.count} hewan • ${item.subtitle}',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                    Text(
                      '${item.total} Diterima',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title.toString(),
                      style: AppTypography.smallBoldBlack,
                    ),
                    Text(item.dateLabel, style: AppTypography.smallBoldBlack),
                  ],
                ),

                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.location.toString(),
                      style: AppTypography.xSmallNormalBlack,
                    ),
                    Text(
                      item.description.toString(),
                      style: AppTypography.xSmallNormalBlack,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
