import 'package:flutter/material.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class OperationalSummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final Color badgeColor;

  const OperationalSummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.smallBoldBlack),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTypography.smallNormalGrey),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: AppTypography.mediumBoldBlack.copyWith(color: badgeColor),
            ),
          ),
        ],
      ),
    );
  }
}
