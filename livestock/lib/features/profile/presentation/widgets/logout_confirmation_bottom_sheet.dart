import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../auth/providers/auth_provider.dart';

class LogoutConfirmationBottomSheet extends ConsumerWidget {
  const LogoutConfirmationBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              const Text(
                "Konfirmasi Keluar",
                style: AppTypography.largeBoldBlack,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 22),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Image.asset(AppImages.icLogoutConfirmation, width: 140),

          const SizedBox(height: 24),

          // ===== TITLE =====
          const Text(
            "Yakin Keluar Livestock?",
            style: AppTypography.mediumBoldBlack,
          ),

          const SizedBox(height: 8),

          // ===== DESCRIPTION =====
          const Text(
            "Kamu akan keluar dari aplikasi. Pastikan semua pekerjaan sudah tersimpan.",
            textAlign: TextAlign.center,
            style: AppTypography.smallNormalGrey,
          ),

          const SizedBox(height: 24),

          // ===== BUTTONS =====
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
                  onPressed: () async {
                    await ref.read(logoutProvider).call();

                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  child: Text(
                    "Keluar Sekarang",
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
