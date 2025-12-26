import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hint;
  final String? suffix;

  const InputField({
    super.key,
    required this.label,
    required this.hint,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.smallBoldBlack),
        const SizedBox(height: 6),
        TextField(
          style: AppTypography.smallNormalBlack,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.hint,
            suffixText: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.fieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.fieldBorder),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
