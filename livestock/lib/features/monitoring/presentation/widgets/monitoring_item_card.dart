import 'package:flutter/material.dart';
import 'package:livestock/core/constant/enum.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../../../../core/theme/AppColors.dart';
import '../../data/monitoring_model.dart';

class MonitoringItemCard extends StatelessWidget {
  final Monitoring item;

  const MonitoringItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isReceived = item.status == ItemStatus.received;

    final Color statusColor = isReceived
        ? AppColors.success
        : AppColors.primary;

    final String statusText = isReceived ? 'Diterima' : 'Menunggu';

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
              Text(item.subtitle, style: AppTypography.xSmallNormalBlack),
              Text(
                '${item.total} Diterima',
                style: AppTypography.xSmallNormalBlack,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
