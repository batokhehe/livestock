import 'package:flutter/material.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_item_request_model.dart';
import 'edit_purchase_order_item_base_card.dart';

class EditAnimalItemCard extends StatelessWidget {
  final PurchaseOrderItemRequest item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const EditAnimalItemCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return EditPurchaseOrderItemBaseCard(
      title: item.animalCode ?? "-",
      subtitle: item.animalName ?? "-",
      icon: AppImages.icNavCow,
      isSvg: true,
      onDelete: onDelete,
      onEdit: onEdit,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${item.initialWeight} kg",
              style: AppTypography.smallBoldBlack,
            ),
            Text(
              'Rp ${formatPrice(item.purchPrice ?? 0)}',
              style: AppTypography.smallBoldBlack,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Berat', style: AppTypography.xSmallNormalBlack),
            Text('Harga Beli', style: AppTypography.xSmallNormalBlack),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (item.ageCategory != null)
              Text(
                "${item.ageCategory ?? "-"}",
                style: AppTypography.smallBoldBlack,
              ),
            if (item.isVaccinated == true && item.vaccineDate != null)
              Text(
                formatDateTime(item.vaccineDate),
                style: AppTypography.smallBoldBlack,
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (item.ageCategory != null)
              const Text(
                'Kategori Umur',
                style: AppTypography.xSmallNormalBlack,
              ),
            if (item.isVaccinated == true && item.vaccineDate != null)
              const Text(
                'Tanggal Vaksin',
                style: AppTypography.xSmallNormalBlack,
              ),
          ],
        ),
      ],
    );
  }
}
