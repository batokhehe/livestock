import 'package:flutter/material.dart';

import '../theme/AppColors.dart';

class CardWrapper extends StatelessWidget {
  final Widget child;
  final double? padding;

  const CardWrapper({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: child,
    );
  }
}
