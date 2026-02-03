import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';

class ProductGradeCard extends StatelessWidget {
  final String grade;
  final String weightRange;
  final String total;
  final String available;
  final String sold;

  const ProductGradeCard({
    super.key,
    required this.grade,
    required this.weightRange,
    required this.total,
    required this.available,
    required this.sold,
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(grade, style: AppTypography.smallBoldBlack),
                  Text(weightRange, style: AppTypography.smallNormalBlack),
                ],
              ),
              Text(total, style: AppTypography.smallNormalBlack),
            ],
          ),
          const SizedBox(height: 6),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_stat("Tersedia", available), _stat("Terjual", sold)],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.smallNormalBlack),
        Text(label, style: AppTypography.smallNormalGrey),
      ],
    );
  }
}
