import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import '../../data/model/purchase_order_item_model.dart';

class PurchaseOrderItemCard extends StatelessWidget {
  final PurchaseOrderDetail data;

  const PurchaseOrderItemCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.animalName != null || data.animalCode != null) {
      return _AnimalItemCard(item: data);
    } else if (data.feedMedicineName != null || data.feedMedicineCode != null) {
      return _FeedItemCard(item: data);
    } else {
      return _EquipmentItemCard(item: data);
    }
  }
}

class _AnimalItemCard extends StatelessWidget {
  final PurchaseOrderDetail item;

  const _AnimalItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _BaseItemCard(
      title: item.animalCode ?? "-",
      subtitle: item.animalName ?? "-",
      icon: AppImages.icNavCow,
      isSvg: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${item.initialWeight} kg", style: AppTypography.smallBoldBlack),
            Text('Rp ${formatPrice(item.purchPrice)}', style: AppTypography.smallBoldBlack),
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
            Text("${item.ageCategory ?? "-"}", style: AppTypography.smallBoldBlack),
            if (item.isVaccinated == true && item.vaccineDate != null)
              Text(formatDateTime(item.vaccineDate), style: AppTypography.smallBoldBlack),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Kategori Umur', style: AppTypography.xSmallNormalBlack),
            if (item.isVaccinated == true && item.vaccineDate != null)
              const Text('Tanggal Vaksin', style: AppTypography.xSmallNormalBlack),
          ],
        ),
      ],
    );
  }
}

class _FeedItemCard extends StatelessWidget {
  final PurchaseOrderDetail item;

  const _FeedItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _BaseItemCard(
      title: item.feedMedicineCode ?? "-",
      subtitle: item.feedMedicineName ?? "-",
      icon: AppImages.icProduct,
      isSvg: false,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${item.quantity} item", style: AppTypography.smallBoldBlack),
            Text('Rp ${formatPrice(item.purchPrice)}', style: AppTypography.smallBoldBlack),
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

class _EquipmentItemCard extends StatelessWidget {
  final PurchaseOrderDetail item;

  const _EquipmentItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _BaseItemCard(
      title: item.equipmentName ?? "-",
      subtitle: item.equipmentCode ?? "-",
      icon: AppImages.icBox,
      isSvg: false,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${item.quantity} item", style: AppTypography.smallBoldBlack),
            Text('Rp ${formatPrice(item.purchPrice)}', style: AppTypography.smallBoldBlack),
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

class _BaseItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final bool isSvg;
  final List<Widget> children;

  const _BaseItemCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSvg,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _itemIcon(icon, isSvg: isSvg),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTypography.smallBoldBlack,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              subtitle,
                              style: AppTypography.smallNormalGrey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _itemIcon(String icon, {required bool isSvg}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: isSvg
            ? SvgPicture.asset(
                icon,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              )
            : Image.asset(icon, fit: BoxFit.contain),
      ),
    );
  }
}
