import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import 'package:livestock/features/monitoring/data/weight_monitoring_model.dart';

class WeightMonitoringCard extends StatelessWidget {
  final WeightMonitoring item;
  final VoidCallback? onTap;

  const WeightMonitoringCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.monitoringCode, style: AppTypography.smallBoldBlack),
                  const SizedBox(height: 4),
                  Text(
                    '${item.animalCount} hewan',
                    style: AppTypography.xSmallNormalBlack,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  if (item.employeeName.isNotEmpty)
                    InfoTag(label: item.employeeName),
                  InfoTag(label: '${item.animalCount} hewan'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
