import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import 'package:livestock/features/monitoring/data/animal_health_check_model.dart';

class AnimalHealthCheckCard extends StatelessWidget {
  final AnimalHealthCheck item;
  final VoidCallback? onTap;

  const AnimalHealthCheckCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final animalLabel = [
      if (item.animalCode != null && item.animalCode!.isNotEmpty)
        item.animalCode,
      if (item.animalName != null && item.animalName!.isNotEmpty)
        item.animalName,
    ].join(' • ');

    final detailsText = [
      '${item.detailsCount} obat',
      if (animalLabel.isNotEmpty) animalLabel else '1 hewan',
    ].join(' • ');

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
                  Text(item.checkCode, style: AppTypography.smallBoldBlack),
                  const SizedBox(height: 4),
                  Text(detailsText, style: AppTypography.xSmallNormalBlack),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.fieldBorder,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  if (item.dateLabel.isNotEmpty) InfoTag(label: item.dateLabel),
                  if (item.employeeName.isNotEmpty)
                    InfoTag(label: item.employeeName),
                  if (item.farmLocationName.isNotEmpty)
                    InfoTag(label: item.farmLocationName),
                  // if (item.farmAreaName.isNotEmpty)
                  //   InfoTag(label: item.farmAreaName),
                  // if (item.checkStatus.isNotEmpty)
                  //   InfoTag(label: 'Status: ${item.checkStatus}'),
                  // if (item.formattedCreatedAt != null && item.formattedCreatedAt!.isNotEmpty)
                  //   InfoTag(label: 'Dibuat: ${item.formattedCreatedAt}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
