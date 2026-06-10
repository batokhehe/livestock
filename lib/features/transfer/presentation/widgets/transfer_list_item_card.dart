import 'package:flutter/material.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import '../../data/model/transfer_list_model.dart';

class TransferCard extends StatelessWidget {
  final TransferList item;

  const TransferCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // 7. Status chip: only show Hewan or Stock
    final String typeText = item.isStock ? 'Stock' : 'Hewan';
    final Color badgeColor = item.isStock ? AppColors.info : AppColors.primary;

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
          // Header section
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. transfer_code
                Text(
                  item.transferCode,
                  style: AppTypography.smallBoldBlack,
                ),
                // 7. Status chip (Hewan / Stock)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    typeText,
                    style: AppTypography.xSmallNormalPrimary.copyWith(
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),

          // Body details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 3. animal_profile.name & 4. animal_profile.code & 2. transfer_date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.animalName ?? '-',
                            style: AppTypography.mediumBoldBlack,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.animalCode ?? '-',
                            style: AppTypography.xSmallNormalGrey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatDateString(item.transferDate),
                      style: AppTypography.xSmallNormalGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),

          // Footer tags: 5. Lokasi awal & 6. Lokasi Akhir
          Container(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InfoTag(
                    label: 'Dari: ${item.fromFarmLocationName}'
                        '${item.fromFarmAreaName != null && item.fromFarmAreaName!.isNotEmpty ? ' (${item.fromFarmAreaName})' : ''}',
                  ),
                  InfoTag(
                    label: 'Ke: ${item.toFarmLocationName}'
                        '${item.toFarmAreaName != null && item.toFarmAreaName!.isNotEmpty ? ' (${item.toFarmAreaName})' : ''}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
