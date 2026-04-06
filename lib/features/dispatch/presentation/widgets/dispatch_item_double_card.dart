import 'package:flutter/material.dart';
import 'package:livestock/core/widgets/info_tag.dart';

import '../../../../core/helpers/utils.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../data/model/dispatch_list_model.dart';

class DispatchItemDoubleCard extends StatelessWidget {
  final DispatchList item;

  const DispatchItemDoubleCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    final String statusText;
    switch (item.dispatchStatus) {
      case 'ready':
        statusColor = AppColors.primary;
        statusText = 'Siap Dikirim';
        break;
      case 'delivered':
        statusColor = AppColors.success;
        statusText = 'Selesai Dikirim';
        break;
      default:
        statusColor = AppColors.grey2;
        statusText = 'Sedang Dikirim';
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
                    Text(item.stockCode, style: AppTypography.smallBoldBlack),
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
                      '${(double.tryParse(item.totalQuantity) ?? 0).toInt()} Hewan • ${item.vehicleNumber}',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                    Text(
                      'Rp. ${formatPrice(double.tryParse(item.shippingCostTotal) ?? 0)}',
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
