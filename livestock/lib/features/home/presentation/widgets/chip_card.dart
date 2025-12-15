import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';

class ChipCard extends StatelessWidget {
  final String label;

  const ChipCard({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryShade,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: AppTypography.xSmallNormalPrimary),
    );
  }
}
