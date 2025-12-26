import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../../../../core/theme/AppColors.dart';
import '../../data/monitoring_model.dart';
import 'monitoring_item_card.dart';

class MonitoringDateGroupCard extends StatelessWidget {
  final String dateLabel;
  final List<Monitoring> items;

  const MonitoringDateGroupCard({
    super.key,
    required this.dateLabel,
    required this.items,
  });

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
          Text(dateLabel, style: AppTypography.smallNormalBlack),
          const SizedBox(height: 8),
          ...items.map(
            (e) => InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                context.push('/monitoring/detail', extra: e);
              },
              child: MonitoringItemCard(item: e),
            ),
          ),
        ],
      ),
    );
  }
}
