import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';

class StockDetailCard extends StatelessWidget {
  const StockDetailCard({super.key});

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
              const Text(
                "Detail Persediaan",
                style: AppTypography.mediumNormalBlack,
              ),
              InkWell(
                onTap: () => context.push('/stock-detail?type=all'),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
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
          // 2 Navigation Cards (Stock Pakan & Stock Obat)
          Row(
            children: [
              Expanded(
                child: _buildStockCategoryCard(
                  context: context,
                  icon: AppImages.icBox,
                  iconBgColor: const Color(0xFFFFF7E6),
                  iconColor: AppColors.primary,
                  title: "Pakan",
                  subtitle: "Stock pakan",
                  routeType: 'feed',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStockCategoryCard(
                  context: context,
                  icon: AppImages.icBlend,
                  iconBgColor: const Color(0xFFFFF7E6),
                  iconColor: AppColors.primary,
                  title: "Obat",
                  subtitle: "Stock obat",
                  routeType: 'medicine',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockCategoryCard({
    required BuildContext context,
    required String icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String routeType,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push('/stock-detail?type=$routeType');
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // color: AppColors.baseBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.fieldBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  icon,
                  width: 20,
                  height: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
