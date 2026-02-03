import 'package:flutter/material.dart';

import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class TextFields extends StatelessWidget {
  final String label;
  final String? hint;
  final String? initial;
  final String? suffix;
  final TextEditingController? controller;
  final int maxLines;
  final bool showCounter;
  final bool enabled;

  const TextFields({
    super.key,
    required this.label,
    this.hint,
    this.initial,
    this.suffix,
    this.controller,
    this.maxLines = 1,
    this.showCounter = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: enabled
                ? AppTypography.smallBoldBlack
                : AppTypography.smallBoldGrey,
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initial,
            enabled: enabled,
            maxLines: maxLines,
            maxLength: showCounter ? 80 : null,
            controller: controller,
            style: enabled
                ? AppTypography.smallBoldBlack
                : AppTypography.smallBoldGrey,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.hint,
              counterText: showCounter ? null : "",
              suffixText: suffix,
              filled: true,
              fillColor: enabled ? AppColors.white : AppColors.greyBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.fieldBorder,
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.grey2, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Dropdowns extends StatelessWidget {
  final String label;
  final String value;
  final String? icon;
  final bool enabled;
  final VoidCallback? onTap;

  const Dropdowns({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: enabled
                ? AppTypography.smallBoldBlack
                : AppTypography.smallBoldGrey,
          ),
          const SizedBox(height: 6),

          InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: enabled ? AppColors.white : AppColors.greyBg,
                border: Border.all(
                  color: enabled ? AppColors.fieldBorder : AppColors.grey2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Image.asset(icon!, width: 14, height: 14),
                    const SizedBox(width: 8),
                  ],

                  /// VALUE
                  Expanded(
                    child: Text(
                      value,
                      style: enabled
                          ? AppTypography.smallNormalBlack
                          : AppTypography.smallNormalGrey,
                    ),
                  ),

                  Icon(
                    Icons.chevron_right,
                    color: enabled ? Colors.grey : Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
