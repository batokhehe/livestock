import 'package:flutter/material.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';

class StatusGridCard extends StatelessWidget {
  const StatusGridCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _StatusCard(
          "1",
          "Draft Pesanan Penjualan",
          "Menunggu diproses",
          Colors.orange,
          AppImages.icReceiptEdit,
        ),
        _StatusCard(
          "6",
          "Pesanan Penjualan Dikonfirmasi",
          "Siap dijadwalkan",
          Colors.blue,
          AppImages.icReceiptSearch,
        ),
        _StatusCard(
          "4",
          "Faktur Lunas",
          "Sudah dibayar",
          Colors.green,
          AppImages.icMoneyTick,
        ),
        _StatusCard(
          "0",
          "Faktur Belum Dibayar",
          "Menunggu pembayaran",
          Colors.orange,
          AppImages.icMoneyTime,
        ),
      ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
