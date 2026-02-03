import 'package:flutter/material.dart';
import 'package:livestock/core/widgets/info_tag.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class ItemDoubleCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String tag;

  const ItemDoubleCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
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
                Text(title, style: AppTypography.smallBoldBlack),
                Text(subTitle, style: AppTypography.xSmallNormalBlack),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [InfoTag(label: tag)],
            ),
          ),
        ],
      ),
    );
  }
}
