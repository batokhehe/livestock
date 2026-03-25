import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livestock/core/theme/AppColors.dart';

import '../../../../core/theme/AppTypography.dart';

class OtherMenuButton extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback? onTap; // 🔥 tambah ini

  const OtherMenuButton(this.image, this.label, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // 🔥 handle tap
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppColors.baseBackground,
              ),
              child: Center(
                child: SvgPicture.asset(
                  image,
                  fit: BoxFit.contain,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.xSmallNormalBlack.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
