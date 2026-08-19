import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/section_card.dart';

import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/card_wrapper.dart';
import '../../../../../core/widgets/info_item_card.dart';
import '../../../../../core/widgets/step_info_card.dart';
import '../../../../../core/widgets/success_notification.dart';
import '../../../../receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../../data/model/purchase_order_item_request_model.dart';
import '../../../data/model/purchase_order_list_model.dart';
import '../../../data/model/purchase_order_request_model.dart';
import '../../../purchase_order_provider.dart';

class EditPurchaseOrderConfirmationPage extends ConsumerWidget {
  final PurchaseOrderList data;

  const EditPurchaseOrderConfirmationPage({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(purchaseOrderFormProvider);
    final items = form.items ?? [];
    final totalItem = items.fold<int>(
      0,
      (sum, item) => sum + (item.quantity ?? 1),
    );

    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + ((item.purchPrice ?? 0) * (item.quantity ?? 1)),
    );

    final total = subtotal + (form.shippingCost ?? 0);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Edit Pembelian",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepInfoCard(
                  title: "Tinjau Rincian Pembelian",
                  step: 3,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),

                _infoPurchaseOrder(form),
                const SizedBox(height: 12),

                ...items.asMap().entries.map((entry) => _itemCard(entry.value)),

                const SizedBox(height: 12),

                _summaryCard(
                  totalItem: totalItem,
                  subtotal: subtotal,
                  shippingCost: form.shippingCost ?? 0,
                  total: total,
                  isAnimal: form.purchaseItemType == 'animal',
                ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: items.isEmpty
                      ? AppColors.grey
                      : AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: items.isEmpty
                    ? null
                    : () async {
                        final result = await showModalBottomSheet<bool>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const ConfirmationBottomSheet(
                            header: "Konfirmasi Edit Pembelian",
                            title: "Simpan Perubahan?",
                            subTitle:
                                "Mohon pastikan semua item dan detail sudah sesuai sebelum menyimpan perubahan",
                            saveText: "Simpan Perubahan",
                          ),
                        );
                        if (result == true) {
                          try {
                            await ref
                                .read(purchaseOrderFormProvider.notifier)
                                .updatePurchaseOrder(data.id);

                            ref
                                .read(purchaseOrderFormProvider.notifier)
                                .reset();

                            ref
                                .read(purchaseOrderListProvider.notifier)
                                .refresh();

                            SuccessNotification.show(
                              title: "Berhasil",
                              subtitle: "Pembelian berhasil diperbarui",
                            );

                            context.go('/purchase-order');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Gagal menyimpan: $e")),
                            );
                          }
                        }
                      },
                child: const Text(
                  "Simpan Perubahan",
                  style: AppTypography.mediumBoldWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoPurchaseOrder(PurchaseOrderRequest form) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Pemesanan", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),
          InfoItemCard(
            icon: AppImages.icCalendarTick,
            title: formatDateTime(form.purchDate),
            subtitle: "Tanggal Pembelian",
          ),
          InfoItemCard(
            icon: AppImages.icUserTag,
            title: form.supplier?.name ?? '-',
            subtitle: form.supplierAddress ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required int totalItem,
    required double subtotal,
    required double shippingCost,
    required double total,
    required bool isAnimal,
  }) {
    return SectionCard(
      title: 'Rincian Bayar',
      children: [
        SectionCard(
          children: [
            _rowSummary(
              isAnimal ? "Jumlah Hewan" : "Jumlah Item",
              "$totalItem ${isAnimal ? 'ekor' : 'item'}",
            ),
            _rowSummary("Subtotal", formatPrice(subtotal)),
            if (isAnimal)
              _rowSummary("Biaya Pengiriman", formatPrice(shippingCost)),
            _rowSummary("Total Keseluruhan", formatPrice(total), isBold: true),
          ],
        ),
      ],
    );
  }

  Widget _rowSummary(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isBold
                ? AppTypography.xSmallBoldBlack
                : AppTypography.xSmallNormalBlack,
          ),
          Text(
            value,
            style: isBold
                ? AppTypography.smallBoldPrimary
                : AppTypography.smallBoldBlack,
          ),
        ],
      ),
    );
  }

  Widget _itemCard(PurchaseOrderItemRequest item) {
    if (item.animalName != null || item.animalCode != null) {
      return _AnimalItemCard(item: item);
    } else if (item.feedMedicine != null || item.feedMedicineName != null) {
      return _FeedItemCard(item: item);
    } else {
      return _EquipmentItemCard(item: item);
    }
  }
}

class _AnimalItemCard extends StatelessWidget {
  final PurchaseOrderItemRequest item;

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

class _FeedItemCard extends StatelessWidget {
  final PurchaseOrderItemRequest item;

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

class _EquipmentItemCard extends StatelessWidget {
  final PurchaseOrderItemRequest item;

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
