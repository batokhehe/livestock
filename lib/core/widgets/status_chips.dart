import 'package:flutter/material.dart';
import '../theme/AppTypography.dart';

class StatusChips extends StatelessWidget {
  final String text;
  final Color color;

  const StatusChips({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: AppTypography.xSmallNormalPrimary.copyWith(color: color),
      ),
    );
  }
}
