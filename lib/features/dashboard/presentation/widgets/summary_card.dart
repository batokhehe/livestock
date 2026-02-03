import 'package:flutter/material.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // ⭐ penting
              children: [
                // ── BARIS ATAS ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "6 Pesanan",
                          style: AppTypography.mediumBoldWhite,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Penjualan Terkonfirmasi",
                          style: AppTypography.smallNormalWhite,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "15 Item",
                          style: AppTypography.mediumNormalWhite,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Total Penerimaan",
                          style: AppTypography.smallNormalWhite,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(AppImages.icTruckFast, width: 16),
                    const SizedBox(width: 4),
                    const Text(
                      "8 Pengiriman Aktif",
                      style: AppTypography.xSmallNormalBlack,
                    ),
                  ],
                ),
                const Text(
                  "Monitoring Aktif",
                  style: AppTypography.xSmallNormalGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
