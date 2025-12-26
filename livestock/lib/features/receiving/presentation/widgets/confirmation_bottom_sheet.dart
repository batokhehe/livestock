import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../../../../core/theme/AppColors.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  const ConfirmationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Konfirmasi Penerimaan",
                style: AppTypography.largeBoldBlack,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Image.asset(AppImages.icConfirmation),
          const SizedBox(height: 24),
          Text(
            "Lanjutkan Penerimaan Item?",
            style: AppTypography.mediumBoldBlack,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Tindakan ini akan menandai penerimaan sebagai "
            "dikonfirmasi dan tidak dapat dibatalkan",
            style: AppTypography.hint,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
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
                  onPressed: () {},
                  child: Text(
                    "Simpan Penerimaan",
                    style: AppTypography.smallNormalWhite,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
