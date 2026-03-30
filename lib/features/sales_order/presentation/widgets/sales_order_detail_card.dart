import 'package:flutter/material.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_detail_model.dart';

import '../../../../core/helpers/utils.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class SalesOrderDetailCard extends StatelessWidget {
  final SalesOrderDetail item;

  const SalesOrderDetailCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    final Color backgroundColor;
    final String statusText;
    switch (item.salesStatus) {
      case 'draft':
        statusColor = AppColors.primaryDark;
        backgroundColor = AppColors.bgColorShadeAwareness;
        statusText = 'Draft';
      case 'confirmed':
        statusColor = AppColors.emerald700;
        backgroundColor = AppColors.bgColorShadeSuccessFull;
        statusText = 'Terkonfirmasi';
        break;
      case 'closed':
        statusColor = AppColors.emerald700;
        backgroundColor = AppColors.emerald200;
        statusText = 'Selesai';
        break;
      default:
        statusColor = AppColors.danger;
        backgroundColor = AppColors.bgColorShadeError;
        statusText = 'Batal';
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
                        color: backgroundColor,
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
                      '${item.items.isNotEmpty ? item.items.first.qty : 0} hewan • ${item.items.isNotEmpty ? (item.items.first.animalProfile?.name ?? item.items.first.item) : '-'}',
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
                      ? '${item.items.first.weight} kg'
                      : '-',
                ),
                InfoTag(
                  label: item.items.isNotEmpty
                      ? (item.items.first.animalProfile?.animalGroup?.name ??
                          '-')
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
