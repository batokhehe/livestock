import 'package:flutter/material.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class ProductCard extends StatelessWidget {
  final String code;
  final String name;
  final String gender;
  final String grade;
  final String age;
  final String weight;
  final String price;
  final String location;
  final String status;

  const ProductCard({
    super.key,
    required this.code,
    required this.name,
    required this.gender,
    required this.grade,
    required this.age,
    required this.weight,
    required this.price,
    required this.location,
    required this.status,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(code, style: AppTypography.smallBoldBlack),
              _statusBadge(status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "$name • $gender • $grade",
            style: AppTypography.smallNormalGrey,
          ),
          const SizedBox(height: 6),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 6),
          // INFO TAGS
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip(age),
              _infoChip(weight),
              _infoChip(price),
              _infoChip(location),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: AppTypography.xSmallNormalGreen),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryShade,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: AppTypography.xSmallNormalPrimary),
    );
  }
}
