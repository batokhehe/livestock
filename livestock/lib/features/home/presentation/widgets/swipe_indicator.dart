import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';

class SwipeIndicator extends StatelessWidget {
  const SwipeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
