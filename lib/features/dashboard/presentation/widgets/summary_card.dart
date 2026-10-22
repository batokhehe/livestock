import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/dashboard/providers/dashboard_provider.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';

class SummaryCard extends ConsumerWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(dashboardSalesProvider);

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
                        salesAsync.when(
                          loading: () => const Text(
                            "Loading...",
                            style: AppTypography.mediumBoldWhite,
                          ),
                          error: (e, s) => const Text(
                            "- Pesanan",
                            style: AppTypography.mediumBoldWhite,
                          ),
                          data: (sales) {
                            final total =
                                sales.salesOrderConfirmed +
                                sales.salesOrderClosed;
                            return Text(
                              "$total Pesanan",
                              style: AppTypography.mediumBoldWhite,
                            );
                          },
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
                    Image.asset(
                      AppImages.icTruckFast,
                      width: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "8 ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "Pengiriman aktif"),
                        ],
                      ),
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
