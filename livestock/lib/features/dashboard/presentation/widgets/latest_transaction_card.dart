import 'package:flutter/material.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class LatestTransactionCard extends StatelessWidget {
  const LatestTransactionCard({super.key});

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
          const Text(
            "Penjualan Terbaru",
            style: AppTypography.mediumNormalBlack,
          ),
          const SizedBox(height: 8),
          _transactionItem(
            name: 'Dawn Johnsonnn',
            code: 'SO-2511-00010',
            price: 'Rp 100.000',
            date: '15 Nov 2025 · 23:10',
          ),
          _transactionItem(
            name: 'Jihan Putri Sulaiman',
            code: 'SO-2511-00009',
            price: 'Rp 70.000.000',
            date: '15 Nov 2025 · 23:06',
          ),
          _transactionItem(
            name: 'H. Imron Saga',
            code: 'SO-2511-00008',
            price: 'Rp 38.000.000',
            date: '14 Nov 2025 · 18:00',
          ),
        ],
      ),
    );
  }

  Widget _transactionItem({
    required String name,
    required String code,
    required String price,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: AppTypography.smallBoldBlack),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(price, style: AppTypography.xSmallNormalGreen),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(code, style: AppTypography.smallNormalGrey),
              Text(date, style: AppTypography.smallNormalGrey),
            ],
          ),
        ],
      ),
    );
  }
}
