import 'package:flutter/material.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_item_request_model.dart';
import 'edit_purchase_order_item_base_card.dart';

class EditFeedItemCard extends StatelessWidget {
  final PurchaseOrderItemRequest item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const EditFeedItemCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return EditPurchaseOrderItemBaseCard(
      title: item.feedMedicineCode ?? "-",
      subtitle: item.feedMedicineName ?? "-",
      icon: AppImages.icProduct,
      isSvg: false,
      onDelete: onDelete,
      onEdit: onEdit,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${item.quantity} item", style: AppTypography.smallBoldBlack),
            Text(
              'Rp ${formatPrice(item.purchPrice ?? 0)}',
              style: AppTypography.smallBoldBlack,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Kuantitas', style: AppTypography.xSmallNormalBlack),
            Text('Harga Beli', style: AppTypography.xSmallNormalBlack),
          ],
        ),
      ],
    );
  }
}
