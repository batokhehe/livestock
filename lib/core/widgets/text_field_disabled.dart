import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../theme/AppColors.dart';

class TextFieldDisabled extends StatelessWidget {
  final String value;

  const TextFieldDisabled({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      maxLines: 3,
      controller: TextEditingController(text: value),
      style: AppTypography.xSmallBoldBlack,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(12, 12, 48, 28),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.fieldBorder),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.fieldBorder),
        ),
      ),
    );
  }
}
