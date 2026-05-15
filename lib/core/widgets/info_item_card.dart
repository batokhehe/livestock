import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/theme/AppColors.dart';
import '../../../core/theme/AppTypography.dart';

class InfoItemCard extends StatelessWidget {
  final String? icon;
  final String title;
  final String? subtitle;
  final String? label;
  final VoidCallback? onTap;

  const InfoItemCard({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.greyBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: icon!.endsWith('.svg')
                      ? SvgPicture.asset(
                          icon!,
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        )
                      : Image.asset(
                          icon!,
                          width: 20,
                          height: 20,
                          color: AppColors.primary,
                        ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null) ...[
                    Text(
                      label!,
                      style: AppTypography.xSmallNormalBlack.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(title, style: AppTypography.smallBoldBlack),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTypography.smallNormalBlack.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
