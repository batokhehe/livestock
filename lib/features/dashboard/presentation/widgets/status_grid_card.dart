import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/dashboard/providers/dashboard_provider.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';

class StatusGridCard extends ConsumerWidget {
  const StatusGridCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(dashboardSalesProvider);

    return salesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Error: $e")),
      data: (sales) {
        return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.35,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _StatusCard(
          sales.salesOrderDraft.toString(),
          "Draft Pesanan\nPenjualan",
          "Menunggu diproses",
          AppColors.primary,
          AppImages.icReceiptEdit,
        ),
        _StatusCard(
          sales.salesOrderConfirmed.toString(),
          "Pesanan Penjualan\nDikonfirmasi",
          "Siap dijadwalkan",
          AppColors.info,
          AppImages.icReceiptSearch,
        ),
        _StatusCard(
          sales.salesInvoiceFullPayment.toString(), // Wait, Faktur lunas
          "Faktur Lunas",
          "Sudah dibayar",
          AppColors.success,
          AppImages.icMoneyTick,
        ),
        _StatusCard(
          (sales.salesInvoicePartial + sales.salesInvoiceDownPayment).toString(), // Faktur belum dibayar (atau DP/Partial)
          "Faktur Belum Dibayar",
          "Menunggu pembayaran",
          AppColors.primary,
          AppImages.icMoneyTime,
        ),
      ],
    );
      },
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String count;
  final String title;
  final String subtitle;
  final Color color;
  final String image;

  const _StatusCard(
    this.count,
    this.title,
    this.subtitle,
    this.color,
    this.image,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              CircleAvatar(
                radius: 14,
                backgroundColor: color.withOpacity(0.15),
                child: Text(
                  count,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Image.asset(image, width: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.grey1)),
        ],
      ),
    );
  }
}
