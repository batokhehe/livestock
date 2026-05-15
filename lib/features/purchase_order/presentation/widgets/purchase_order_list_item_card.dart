import 'package:flutter/material.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import '../../data/model/purchase_order_list_model.dart';

class PurchaseOrderAnimalCard extends StatelessWidget {
  final PurchaseOrderList item;
  const PurchaseOrderAnimalCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return _BasePurchaseOrderCard(
      item: item,
      typeLabel: 'hewan',
      tags: [
        InfoTag(label: item.supplierName.toString()),
      ],
    );
  }
}

class PurchaseOrderFeedCard extends StatelessWidget {
  final PurchaseOrderList item;
  const PurchaseOrderFeedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return _BasePurchaseOrderCard(
      item: item,
      typeLabel: 'pakan',
      tags: [
        InfoTag(label: item.supplierName.toString()),
      ],
    );
  }
}

class PurchaseOrderEquipmentCard extends StatelessWidget {
  final PurchaseOrderList item;
  const PurchaseOrderEquipmentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return _BasePurchaseOrderCard(
      item: item,
      typeLabel: 'peralatan',
      tags: [
        InfoTag(label: item.supplierName.toString()),
      ],
    );
  }
}

class _BasePurchaseOrderCard extends StatelessWidget {
  final PurchaseOrderList item;
  final String typeLabel;
  final List<Widget> tags;

  const _BasePurchaseOrderCard({
    required this.item,
    required this.typeLabel,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    final String statusText;
    switch (item.purchStatus) {
      case 'confirmed':
        statusColor = AppColors.success;
        statusText = 'Dikonfirmasi';
        break;
      case 'sell':
        statusColor = AppColors.primary;
        statusText = 'Terjual';
        break;
      case 'draft':
        statusColor = AppColors.grey2;
        statusText = 'Draft';
        break;
      case 'canceled':
        statusColor = AppColors.danger;
        statusText = 'Batal';
        break;
      default:
        statusColor = AppColors.grey2;
        statusText = '-';
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
                        color: statusColor.withValues(alpha: 0.15),
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
                      '${item.details.length} $typeLabel',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                    Text(
                      'Rp ${formatPrice(item.amountTotal.toInt())}',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tags,
            ),
          ),
        ],
      ),
    );
  }
}
