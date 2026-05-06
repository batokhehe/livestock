import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppImages.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import 'chip_card.dart';

class ProductCardItem extends StatelessWidget {
  final String title;
  final String status;
  final String weight;
  final String grade;
  final String price;
  final Color? statusColor;
  final Color? statusBgColor;

  const ProductCardItem({
    super.key,
    required this.title,
    required this.status,
    required this.weight,
    required this.grade,
    required this.price,
    this.statusColor,
    this.statusBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.smallNormalBlack),
                    const SizedBox(height: 4),
                    if (statusBgColor != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          status,
                          style: AppTypography.xSmallNormalPrimary.copyWith(
                            color: statusColor,
                          ),
                        ),
                      )
                    else
                      Text(status, style: AppTypography.xSmallNormalGreen),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(AppImages.product, width: 48),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 8.0,
            children: [
              ChipCard(label: weight),
              ChipCard(label: grade),
              ChipCard(label: price),
            ],
          ),
        ],
      ),
    );
  }
}
