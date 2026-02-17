import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../../../../core/theme/AppColors.dart';
import '../../data/model/purchase_order_list_model.dart';
import 'purchase_order_item_double_card.dart';

class PurchaseOrderDateGroupCard extends StatelessWidget {
  final String dateLabel;
  final List<PurchaseOrderList> items;

  const PurchaseOrderDateGroupCard({
    super.key,
    required this.dateLabel,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDateString(dateLabel),
            style: AppTypography.smallNormalBlack,
          ),
          const SizedBox(height: 8),
          ...items.map(
            (e) => InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                context.push('/purchase-order/detail/${e.id}');
              },
              child: PurchaseOrderItemDoubleCard(item: e),
            ),
          ),
        ],
      ),
    );
  }
}
