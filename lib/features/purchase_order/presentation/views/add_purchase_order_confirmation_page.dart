import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/section_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/info_item_card.dart';
import '../../../../core/widgets/product_header_card.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../../../core/widgets/two_column_row_card.dart';
import '../../../receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../data/model/purchase_order_item_request_model.dart';
import '../../data/model/purchase_order_request_model.dart';
import '../../purchase_order_provider.dart';

class AddPurchaseOrderConfirmationPage extends ConsumerWidget {
  const AddPurchaseOrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(purchaseOrderFormProvider);
    final items = form.items ?? [];

    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + (item.purchPrice ?? 0),
    );

    final total = subtotal + (form.shippingCost ?? 0);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Pembelian",
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

                if (form.purchaseItemType == 'animal') _infoPurchaseOrder(form),
                const SizedBox(height: 12),

                ...items.asMap().entries.map(
                  (entry) => _ProductInfoCard(
                    counter: entry.key + 1,
                    data: entry.value,
                  ),
                ),

                const SizedBox(height: 12),

                _summaryCard(
                  totalItem: items.length,
                  subtotal: subtotal,
                  shippingCost: form.shippingCost ?? 0,
                  total: total,
                ),
              ],
            ),
          ),

          /// BUTTON
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
                            header: "Konfirmasi Pembelian",
                            title: "Lanjutkan Pembelian Item?",
                            subTitle:
                                "Mohon pastikan semua item dan detail sudah sesuai sebelum melanjutkan transaksi",
                            saveText: "Simpan Pembelian",
                          ),
                        );
                        if (result == true) {
                          try {
                            await ref
                                .read(purchaseOrderFormProvider.notifier)
                                .submitPurchaseOrder();

                            ref
                                .read(purchaseOrderFormProvider.notifier)
                                .reset();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Pembelian berhasil disimpan",
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            context.go('/purchase-order');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Gagal menyimpan: $e")),
                            );
                          }
                        }
                      },

                child: Text(
                  "Selanjutnya",
                  style: AppTypography.mediumBoldWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// INFORMASI Pembelian
  /// =========================

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
            subtitle: form.farmLocation!.name,
          ),
          InfoItemCard(
            icon: AppImages.icUserTag,
            title: form.supplier!.name,
            subtitle: form.supplier!.name.toString(),
          ),
          InfoItemCard(
            icon: AppImages.icMoneys,
            title: form.shippingCost.toString(),
            subtitle: form.additionalCost.toString(),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// SUMMARY CARD
  /// =========================

  Widget _summaryCard({
    required int totalItem,
    required double subtotal,
    required double shippingCost,
    required double total,
  }) {
    return SectionCard(
      title: 'Rincian Bayar',
      children: [
        SectionCard(
          children: [
            _rowSummary("Jumlah Item", totalItem.toString()),
            _rowSummary("Subtotal", formatPrice(subtotal)),
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
}

class _ProductInfoCard extends StatelessWidget {
  final PurchaseOrderItemRequest data;
  final int counter;

  const _ProductInfoCard({required this.data, required this.counter});

  @override
  Widget build(BuildContext context) {
    final isAnimal = data.animalName != null;

    final code = isAnimal ? data.animalCode : data.feedMedicine!.code;

    final secondValue = isAnimal
        ? "${data.animalCode}"
        : data.feedMedicine!.feedType;

    return SectionCard(
      title: 'Item ${counter.toString()}',
      children: [
        SectionCard(
          children: [
            ProductHeaderCard(
              title: data.animalName ?? data.feedMedicine!.name,
              subtitle: '$code • $secondValue',
              image: AppImages.icProduct,
            ),
            const SizedBox(height: 12),
            Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
            TwoColumnRowCard(
              leftValue: formatPrice(data.purchPrice as num),
              leftLabel: "Harga/kg Forecast",
              rightValue: formatPrice(data.subtotal),
              rightLabel: "Total Forecast",
            ),
          ],
        ),
        // if (isAnimal) ...[
        //   const SizedBox(height: 12),
        //   SectionCard(
        //     children: [
        //       ProductHeaderCard(
        //         title: data.subtotal.toString(),
        //         subtitle: formatDateTime(data.dlvDate),
        //         image: AppImages.icMoneys,
        //       ),
        //       Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
        //       TwoColumnRowCard(
        //         leftValue: data.unitPrice.toString(),
        //         leftLabel: "Harga jual",
        //         rightValue: data.discount.toString(),
        //         rightLabel: "Harga diskon",
        //       ),
        //     ],
        //   ),
        //   const SizedBox(height: 12),
        //   SectionCard(
        //     children: [
        //       ProductHeaderCard(
        //         title: 'Transaksi Forecast',
        //         subtitle: 'kg • ${formatDateTime(data.dlvDate)}',
        //         image: AppImages.icMoneys,
        //       ),
        //     ],
        //   ),
        //   const SizedBox(height: 12),
        //   SectionCard(
        //     children: [
        //       ProductHeaderCard(
        //         title: formatDateTime(data.dlvDate),
        //         subtitle: 'Tanggal Pengiriman',
        //         image: AppImages.icTruckFast,
        //       ),
        //     ],
        //   ),
        //   const SizedBox(height: 12),
        //   SectionCard(
        //     children: [
        //       ProductHeaderCard(
        //         title: '${data.state} • ${data.city}',
        //         subtitle: '${data.district} • ${data.village}',
        //         image: AppImages.icMap,
        //       ),
        //     ],
        //   ),
        //   const SizedBox(height: 12),
        //   SectionCard(
        //     children: [
        //       ProductHeaderCard(
        //         title: data.deliveryAddress!,
        //         image: AppImages.icMap,
        //       ),
        //     ],
        //   ),
        // ],
      ],
    );
  }
}
