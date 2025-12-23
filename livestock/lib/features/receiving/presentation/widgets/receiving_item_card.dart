import 'package:flutter/material.dart';

import '../../../../core/theme/AppColors.dart';
import '../../data/receiving_model.dart';

class ReceivingItemCard extends StatelessWidget {
  final Receiving item;

  const ReceivingItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isReceived = item.status == ReceivingStatus.received;

    final Color statusColor = isReceived
        ? AppColors.success
        : AppColors.primary;

    final String statusText = isReceived ? 'Diterima' : 'Menunggu';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ROW ATAS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.code,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /// ROW BAWAH (KIRI + KANAN)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.subtitle, // "2 hewan • Sapi Jawara"
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              Text(
                '${item.total} Diterima',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
