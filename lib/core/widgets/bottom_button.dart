import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class BottomButton extends StatelessWidget {
  final String route;
  final String text;

  const BottomButton({super.key, required this.route, required this.text});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.push(route);
            },
            child: Text(text, style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
