import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../../../../core/theme/AppColors.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final String header;
  final String title;
  final String subTitle;
  final String saveText;
  final VoidCallback? onTap;

  const ConfirmationBottomSheet({
    super.key,
    required this.header,
    required this.title,
    required this.subTitle,
    required this.saveText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(header, style: AppTypography.largeBoldBlack),
                RawMaterialButton(
                  onPressed: () => Navigator.pop(context),
                  elevation: 1.0,
                  constraints: BoxConstraints(minWidth: 0.0),
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(
                    side: const BorderSide(
                      color: AppColors.iconColor,
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Icon(Icons.close_rounded, size: 12.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Image.asset(AppImages.icConfirmation),
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTypography.mediumBoldBlack,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              subTitle,
              style: AppTypography.hint,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 16.0,
            ),
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[4],
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primaryShade,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppColors.primaryShade),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Batal",
                      style: AppTypography.smallNormalPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      saveText,
                      style: AppTypography.smallNormalWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
