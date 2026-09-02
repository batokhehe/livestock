import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:livestock/features/dashboard/providers/dashboard_provider.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class LatestTransactionCard extends ConsumerWidget {
  const LatestTransactionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestSalesAsync = ref.watch(latestSalesOrderProvider);

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
          Text(
            "Penjualan Terbaru",
            style: AppTypography.mediumNormalBlack.copyWith(color: AppColors.grey2),
          ),
          const SizedBox(height: 12),
          latestSalesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text("Error: $e")),
            data: (sales) {
              if (sales.isEmpty) {
                return const Center(child: Text("Belum ada penjualan terbaru"));
              }
              return Column(
                children: sales.map((sale) {
                  final priceFormatted = NumberFormat.currency(
                    locale: 'id',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(sale.amountTotal);
                  
                  final date = DateTime.tryParse(sale.invoiceDate);
                  final dateFormatted = date != null 
                      ? DateFormat('dd MMM yyyy').format(date) 
                      : sale.invoiceDate;

                  return _transactionItem(
                    name: sale.customerName ?? '-',
                    code: sale.invoiceId,
                    price: priceFormatted,
                    date: dateFormatted,
                  );
                }).toList(),
              );
            },
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
