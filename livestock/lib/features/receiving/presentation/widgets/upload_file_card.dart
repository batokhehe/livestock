import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';

import '../../../../core/theme/AppTypography.dart';

class UploadFileCard extends StatelessWidget {
  final VoidCallback onTap;

  const UploadFileCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Item", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Unggah Bukti", style: AppTypography.smallBoldBlack),
                      SizedBox(height: 4),
                      Text(
                        "Pastikan bukti terlihat jelas!",
                        style: AppTypography.hint,
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryShade,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Unggah",
                      style: AppTypography.smallNormalPrimary,
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
