import 'package:flutter/material.dart';

import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class SectionCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Widget? trailing;

  const SectionCard({
    super.key,
    this.title,
    required this.children,
    this.actionLabel,
    this.onActionTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasHeader = title != null;
    final bool hasAction = actionLabel != null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasHeader)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(title!, style: AppTypography.smallNormalBlack),
                  ),
                  if (hasAction)
                    TextButton(
                      onPressed: onActionTap,
                      style: TextButton.styleFrom(
                        backgroundColor: onActionTap == null
                            ? AppColors.greyBg
                            : AppColors.textBtnBackground,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        actionLabel!,
                        style: AppTypography.smallNormalBlack.copyWith(
                          color: onActionTap == null
                              ? AppColors.hint
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (trailing != null) trailing!,
                ],
              ),
            if (hasHeader) const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
