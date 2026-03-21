import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class TextFields extends StatelessWidget {
  final String label;
  final String? hint;
  final String? initial;
  final String? suffix;
  final String? prefixText;
  final TextEditingController? controller;
  final int maxLines;
  final bool showCounter;
  final bool enabled;
  final bool isMandatoryField;
  final String? prefixIcon;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const TextFields({
    super.key,
    required this.label,
    this.hint,
    this.initial,
    this.suffix,
    this.prefixText,
    this.controller,
    this.maxLines = 1,
    this.showCounter = false,
    this.enabled = true,
    this.isMandatoryField = false,
    this.prefixIcon,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: enabled
                    ? AppTypography.smallBoldBlack
                    : AppTypography.smallBoldGrey,
              ),
              isMandatoryField
                  ? Text('*', style: AppTypography.smallBoldRed)
                  : SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: controller == null ? initial : null,
            controller: controller,
            enabled: enabled,
            maxLines: maxLines,
            maxLength: showCounter ? 80 : null,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,

            /// 🔥 INI YANG PENTING
            onChanged: onChanged,

            style: enabled
                ? AppTypography.smallBoldBlack
                : AppTypography.smallBoldGrey,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.hint,
              counterText: showCounter ? null : "",
              suffixText: suffix,
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(prefixIcon!, width: 18),
                    )
                  : prefixText != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(prefixText!, style: AppTypography.smallBoldBlack),
                        )
                      : null,
              prefixIconConstraints: prefixText != null
                  ? const BoxConstraints(minWidth: 0, minHeight: 0)
                  : null,
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
                borderSide: const BorderSide(color: AppColors.grey2, width: 1),
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

class AppRadioGroup<T> extends StatelessWidget {
  final String title;
  final T value;
  final List<T> options;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;

  const AppRadioGroup({
    super.key,
    required this.title,
    required this.value,
    required this.options,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.smallBoldBlack),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldBorder, width: 1),
            ),
            child: Row(
              children: options.map((item) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<T>(
                      value: item,
                      groupValue: value,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        if (val != null) onChanged(val);
                      },
                    ),
                    Text(
                      labelBuilder(item),
                      style: AppTypography.smallNormalBlack,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
