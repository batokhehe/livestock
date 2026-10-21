import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../theme/AppColors.dart';

class InfoTag extends StatelessWidget {
  final String label;

  const InfoTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryShade,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.xSmallNormalPrimary,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
