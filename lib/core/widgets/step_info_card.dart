import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';

class StepInfoCard extends StatelessWidget {
  final String title;
  final int step;
  final int totalStep;
  final VoidCallback? onTap;

  const StepInfoCard({
    super.key,
    required this.title,
    required this.step,
    required this.totalStep,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Row(
          children: [
            /// LEFT TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.mediumBoldBlack),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Langkah $step',
                          style: AppTypography.smallBoldPrimary,
                        ),
                        TextSpan(
                          text: '/$totalStep',
                          style: AppTypography.xSmallNormalGrey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryShade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.chevron_right, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
