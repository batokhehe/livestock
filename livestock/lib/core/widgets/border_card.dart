import 'package:flutter/material.dart';

import '../theme/AppColors.dart';

class BorderCard extends StatelessWidget {
  final Widget child;

  const BorderCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: child,
    );
  }
}
