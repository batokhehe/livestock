import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../../../../core/theme/AppColors.dart';

class DateGroupCard extends StatelessWidget {
  final String dateLabel;
  final List<Widget> children;

  const DateGroupCard({
    super.key,
    required this.dateLabel,
    required this.children,
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
          /// HEADER DATE
          Text(dateLabel, style: AppTypography.smallNormalBlack),
          const SizedBox(height: 8),

          /// ITEMS
          ...children,
        ],
      ),
    );
  }
}
