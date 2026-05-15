import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';

class DeleteConfirmBottomSheet extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteConfirmBottomSheet({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Hapus Item", style: AppTypography.largeBoldBlack),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Image.asset(AppImages.icDeleteConfirmation, height: 120),
          const SizedBox(height: 20),
          const Text("Hapus Item Ini?", style: AppTypography.mediumBoldBlack),
          const SizedBox(height: 8),
          const Text(
            "Item yang telah diinput akan dihapus dan tidak dapat dikembalikan. "
            "Apakah Anda yakin ingin melanjutkan?",
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
                    side: const BorderSide(color: AppColors.primaryShade),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Batal",
                    style: AppTypography.mediumBoldPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onDelete,
                  child: const Text(
                    "Hapus Sekarang",
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
