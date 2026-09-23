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
                  ).format(sale.amountPaid);
                  
                  final date = DateTime.tryParse(sale.invoiceDate);
                  final dateFormatted = date != null 
                      ? DateFormat('dd MMM yyyy').format(date) 
                      : sale.invoiceDate;

                  return _transactionItem(
                    name: sale.customerName ?? '-',
                    code: sale.invoiceId,
                    price: priceFormatted,
                    date: dateFormatted,
                    paymentStatus: sale.paymentStatus,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getPaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'down_payment':
        return 'Uang Muka';
      case 'partial':
        return 'Pembayaran Sebagian';
      case 'full_payment':
      case 'paid':
        return 'Pelunasan';
      case 'canceled':
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status.isNotEmpty ? status : '-';
    }
  }

  Color _getPaymentStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'full_payment':
      case 'paid':
        return const Color(0xFFE6F7ED);
      case 'down_payment':
        return const Color(0xFFE3F2FD);
      case 'partial':
        return const Color(0xFFFFF7E6);
      case 'canceled':
      case 'cancelled':
        return const Color(0xFFFFF1F0);
      default:
        return AppColors.greyBg;
    }
  }

  Color _getPaymentStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'full_payment':
      case 'paid':
        return const Color(0xFF2E7D32);
      case 'down_payment':
        return const Color(0xFF1976D2);
      case 'partial':
        return const Color(0xFFD97706);
      case 'canceled':
      case 'cancelled':
        return AppColors.danger;
      default:
        return AppColors.grey2;
    }
  }

  Widget _transactionItem({
    required String name,
    required String code,
    required String price,
    required String date,
    required String paymentStatus,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTypography.smallBoldBlack,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
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

          if (paymentStatus.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: _getPaymentStatusBgColor(paymentStatus),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getPaymentStatus(paymentStatus),
                style: TextStyle(
                  color: _getPaymentStatusTextColor(paymentStatus),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
