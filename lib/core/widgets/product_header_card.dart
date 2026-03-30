import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class ProductHeaderCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String image;
  final bool isActive;
  final String? status;

  const ProductHeaderCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.image,
    this.isActive = false,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ICON
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: image.toLowerCase().endsWith('.svg')
                ? SvgPicture.asset(
                    image,
                    fit: BoxFit.contain,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  )
                : Image.asset(
                    image,
                    fit: BoxFit.contain,
                    width: 24,
                    height: 24,
                    color: AppColors.primary,
                  ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.smallBoldBlack),
              if (subtitle != null) const SizedBox(height: 2),
              if (subtitle != null)
                Text(subtitle!, style: AppTypography.smallNormalGrey),
            ],
          ),
        ),

        if (status != null) _statusBadge(status!),
        if (status == null && isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Aktif", style: AppTypography.xSmallNormalGreen),
          ),
      ],
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
}
