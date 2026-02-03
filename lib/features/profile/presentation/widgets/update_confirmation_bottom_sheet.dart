import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppImages.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

Future<bool?> showConfirmUpdateBottomSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _ConfirmUpdateBottomSheet(),
  );
}

class _ConfirmUpdateBottomSheet extends StatelessWidget {
  const _ConfirmUpdateBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Konfirmasi Perubahan",
                style: AppTypography.largeBoldBlack,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context, false),
                child: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Image.asset(AppImages.icConfirmation, width: 96),

          const SizedBox(height: 24),

          const Text(
            "Perbarui Data Profil?",
            style: AppTypography.mediumBoldBlack,
          ),
          const SizedBox(height: 8),
          const Text(
            "Data profil yang anda ubah akan diperbarui pada informasi dan detail profil.",
            textAlign: TextAlign.center,
            style: AppTypography.smallNormalGrey,
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
                    "Simpan Perubahan",
                    style: AppTypography.mediumBoldWhite,
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
