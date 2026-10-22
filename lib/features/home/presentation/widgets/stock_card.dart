import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/features/home/presentation/widgets/stock_item_card.dart';

import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';

class StockCard extends StatelessWidget {
  const StockCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Persediaan", style: AppTypography.mediumNormalBlack),
              InkWell(
                onTap: () => context.push('/stock-detail?type=all'),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        "Lihat Semua",
                        style: AppTypography.xSmallNormalPrimary.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                StockItemCard(
                  AppImages.icBox,
                  "7.800",
                  "Pakan",
                  onTap: () => context.push('/stock-detail?type=feed'),
                ),
                const SizedBox(width: 12),
                StockItemCard(
                  AppImages.icBlend,
                  "1.000",
                  "Obat",
                  onTap: () => context.push('/stock-detail?type=medicine'),
                ),
                const SizedBox(width: 12),
                StockItemCard(
                  AppImages.icRulerPen,
                  "5.800",
                  "Lainnya",
                  onTap: () => context.push('/stock-detail?type=all'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
