import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../theme/AppColors.dart';

class TextFieldWithInnerCounter extends StatefulWidget {
  final String label;
  final String subLabel;
  final String hint;
  final int maxLength;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const TextFieldWithInnerCounter({
    super.key,
    required this.label,
    required this.subLabel,
    required this.hint,
    required this.maxLength,
    this.controller,
    this.onChanged,
  });

  @override
  State<TextFieldWithInnerCounter> createState() =>
      _TextFieldWithInnerCounterState();
}

class _TextFieldWithInnerCounterState extends State<TextFieldWithInnerCounter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: widget.label, style: AppTypography.smallBoldBlack),
              TextSpan(
                text: ' ${widget.subLabel}',
                style: AppTypography.smallNormalGrey,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            TextField(
              onChanged: widget.onChanged,
              controller: widget.controller,
              maxLength: widget.maxLength,
              maxLines: 3,
              style: AppTypography.xSmallNormalBlack,
              decoration: InputDecoration(
                hintText: widget.hint,
                counterText: '',
                contentPadding: const EdgeInsets.fromLTRB(12, 12, 48, 28),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.fieldBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.fieldBorder),
                ),
              ),
            ),

            Positioned(
              right: 12,
              bottom: 8,
              child: Text(
                '${widget.controller?.text.length}/${widget.maxLength}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
