import 'package:flutter/material.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_list_model.dart';

import '../../../../core/helpers/utils.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class SalesOrderItemDoubleCard extends StatelessWidget {
  final SalesOrderList item;

  const SalesOrderItemDoubleCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    final String statusText;
    switch (item.salesStatus) {
      case 'confirmed':
        statusColor = AppColors.success;
        statusText = 'Dikonfirmasi';
        break;
      case 'sell':
        statusColor = AppColors.primary;
        statusText = 'Terjual';
        break;
      default:
        statusColor = AppColors.grey2;
        statusText = 'Tutup';
    }

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
                    Text(item.orderId, style: AppTypography.smallBoldBlack),
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
                      '${item.items.first.qty} hewan • ${item.items.first.animalProfile?.name}',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                    Text(
                      'Rp. ${formatPrice(item.amountTotal)}',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoTag(label: item.customerName),
                InfoTag(
                  label: item.items.isNotEmpty
                      ? '${item.items.first.animalProfile?.weight ?? '-'} kg'
                      : '-',
                ),
                InfoTag(
                  label: item.items.isNotEmpty
                      ? (item.items.first.animalProfile?.animalGroupName ?? '-')
                      : '-',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
