import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                          "Rp. 1.684.842.213",
                          style: AppTypography.mediumBoldWhite,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Image.asset(AppImages.icWalletCheck, width: 16),
                            const SizedBox(width: 4),
                            const Text(
                              "Total pemasukan",
                              style: AppTypography.smallNormalWhite,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "500/200.000",
                          style: AppTypography.mediumNormalWhite,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Image.asset(AppImages.icAnimal, width: 16),
                            const SizedBox(width: 4),
                            const Text(
                              "Hewan terjual",
                              style: AppTypography.smallNormalWhite,
                            ),
                          ],
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
                    Image.asset(AppImages.icUserTick, width: 16),
                    const SizedBox(width: 4),
                    const Text(
                      "13 Karyawan yang hadir hari ini!",
                      style: AppTypography.xSmallNormalBlack,
                    ),
                  ],
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  style: AppTypography.xSmallNormalBlack,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
