import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';

class StockItemCard extends StatelessWidget {
  final String image;
  final String value;
  final String label;
  final VoidCallback? onTap;

  const StockItemCard(
    this.image,
    this.value,
    this.label, {
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.fieldBorder),
          ),
          child: Row(
            children: [
              Image.asset(image, width: 18),
              const SizedBox(width: 8),
              Text(value, style: AppTypography.smallNormalBlack),
              const SizedBox(width: 8),
              Text(label, style: AppTypography.smallNormalBlack),
            ],
          ),
        ),
      ),
    );
  }
}
