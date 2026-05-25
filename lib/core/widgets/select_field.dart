import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class SelectField extends StatelessWidget {
  final String label;
  final String hint;
  final dynamic icon;
  final bool isMandatoryField;
  final bool enabled;
  final TextStyle? style;
  final VoidCallback? onTap;

  const SelectField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isMandatoryField = false,
    this.enabled = true,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTypography.smallBoldBlack),
            isMandatoryField
                ? const Text('*', style: AppTypography.smallBoldRed)
                : const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: enabled ? Colors.white : AppColors.greyBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hint,
                    style: style ?? (enabled ? AppTypography.hint : AppTypography.smallNormalGrey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right, color: enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    if (icon is IconData) {
      return Icon(icon as IconData, size: 20, color: AppColors.primary);
    }

    final String iconPath = icon.toString();
    if (iconPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        iconPath,
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
      );
    }

    return Image.asset(iconPath, width: 20, color: AppColors.primary);
  }
}
