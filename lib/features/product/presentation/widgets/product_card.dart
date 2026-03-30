import 'package:flutter/material.dart';

import '../../../../core/data/model/farm_area_model.dart';
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
  final String refSalesPriceTotal;
  final String location;
  final String status;
  final FarmArea? farmArea;

  const ProductCard({
    super.key,
    required this.code,
    required this.name,
    required this.gender,
    required this.grade,
    required this.age,
    required this.weight,
    required this.price,
    required this.refSalesPriceTotal,
    required this.location,
    required this.status,
    this.farmArea,
  });

  @override
  Widget build(BuildContext context) {
    final genderLabel = gender == 'male' ? 'Jantan' : 'Betina';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(code, style: AppTypography.smallBoldBlack),
              _statusBadge(status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "$name • $genderLabel • $grade",
            style: AppTypography.smallNormalGrey,
          ),
          const SizedBox(height: 10),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 10),
          // INFO TAGS
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip(age),
              _infoChip(weight),
              _infoChip(refSalesPriceTotal),
              _infoChip(location),
              if (farmArea != null) _infoChip(farmArea!.name),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'available':
        bgColor = AppColors.success.withOpacity(0.08);
        textColor = AppColors.success;
        label = 'Tersedia';
        break;
      case 'sold':
        bgColor = Colors.red.withOpacity(0.08);
        textColor = Colors.red;
        label = 'Terjual';
        break;
      case 'booked':
        bgColor = Colors.orange.withOpacity(0.08);
        textColor = Colors.orange;
        label = 'Dipesan';
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.08);
        textColor = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTypography.xSmallNormalGreen.copyWith(color: textColor),
      ),
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
