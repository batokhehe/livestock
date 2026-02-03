import 'package:flutter/material.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

import '../../../../core/constant/enum.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../data/model/receiving_po_model.dart';

class ReceivingItemDoubleCard extends StatelessWidget {
  final ReceivingPo item;
  final ReceivingTab tab;

  const ReceivingItemDoubleCard({
    super.key,
    required this.item,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    final bool isReceived = true;
    // item.receiveStatus == ItemStatus.received ||
    // item.receiveStatus == ItemStatus.confirmed;

    final Color statusColor = isReceived
        ? AppColors.success
        : AppColors.primary;

    final String statusText = isReceived ? 'Diterima' : 'Menunggu';
    final double totalQty = item.items.fold<double>(
      0,
      (sum, e) => sum + (double.tryParse(e.qty ?? '0') ?? 0),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.purchOrderNo,
                      style: AppTypography.smallBoldBlack,
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
                        style: AppTypography.xSmallNormalPrimary.copyWith(
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$totalQty ${tab.ext} • Lunas',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                    Text('0 Diterima', style: AppTypography.xSmallNormalBlack),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.supplierName,
                      style: AppTypography.smallBoldBlack,
                    ),
                    Text(item.purchDate, style: AppTypography.smallBoldBlack),
                  ],
                ),

                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nama Pemasok',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                    Text(
                      'Tanggal Pembelian',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
