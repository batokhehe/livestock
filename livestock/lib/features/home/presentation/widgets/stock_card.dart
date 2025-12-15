import 'package:flutter/material.dart';
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
          const Text("Persediaan", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                StockItemCard(AppImages.icBox, "7.800", "Pakan"),
                SizedBox(width: 12),
                StockItemCard(AppImages.icBlend, "1.000", "Obat"),
                SizedBox(width: 12),
                StockItemCard(AppImages.icRulerPen, "5.800", "Lainnya"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
