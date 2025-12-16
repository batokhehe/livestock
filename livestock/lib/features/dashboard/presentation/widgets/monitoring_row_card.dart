import 'package:flutter/material.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../data/monitoring_item.dart';

class MonitoringRowCard extends StatelessWidget {
  final MonitoringItem item;

  const MonitoringRowCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.label, style: AppTypography.smallNormalGrey),
          Text(
            item.value,
            style: AppTypography.smallBoldBlack.copyWith(
              color: item.valueColor ?? AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
