import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // ICON
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryShade,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Image.asset(image, width: 24, height: 24)),
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
      ),
    );
  }
}
