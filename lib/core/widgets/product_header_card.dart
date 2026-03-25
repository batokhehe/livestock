import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class ProductHeaderCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String image;
  final bool isActive;

  const ProductHeaderCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.image,
    this.isActive = false,
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
            child: SvgPicture.asset(
              image,
              fit: BoxFit.contain,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
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

        if (isActive)
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
}
