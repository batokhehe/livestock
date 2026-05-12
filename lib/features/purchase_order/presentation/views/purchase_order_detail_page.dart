import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_item_model.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/info_item_card.dart';
import '../../../../core/widgets/product_header_card.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../../../core/widgets/two_column_row_card.dart';
import '../../data/model/purchase_order_list_model.dart';
import '../../purchase_order_provider.dart';

class PurchaseOrderDetailPage extends ConsumerWidget {
  final int id;

  const PurchaseOrderDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(purchaseOrderDetailProvider(id));

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
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (data) {
          final items = data.details;

          final subtotal = items.fold<double>(
            0,
            (sum, item) => sum + (item.purchPrice ?? 0),
          );

          final total = subtotal + (data.shippingCost ?? 0);

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepInfoCard(
                      title: "Detail Pembelian",
                      step: 3,
                      totalStep: 3,
                    ),
                    const SizedBox(height: 12),

                    _infoPurchaseOrder(data),
                    const SizedBox(height: 12),

                    ...items.asMap().entries.map(
                      (entry) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ProductInfoCard(
                            counter: entry.key + 1,
                            data: entry.value,
                          ),
                          SizedBox(height: 12.0),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    _summaryCard(
                      totalItem: items.length,
                      subtotal: subtotal,
                      shippingCost: data.shippingCost ?? 0,
                      total: total,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoPurchaseOrder(PurchaseOrderList data) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Pemesanan", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),
          InfoItemCard(
            icon: AppImages.icCalendarTick,
            title: formatDateTime(data.purchDate),
            subtitle: data.farmLocation?.name ?? "-",
          ),
          InfoItemCard(
            icon: AppImages.icUserTag,
            title: data.supplierName ?? "-",
            subtitle: data.supplierAddress ?? "-",
          ),
          InfoItemCard(
            icon: AppImages.icMoneys,
            title: formatPrice(data.amountTotal),
            subtitle: "Total Pembelian",
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
  final PurchaseOrderDetail data;
  final int counter;

  const _ProductInfoCard({required this.data, required this.counter});

  @override
  Widget build(BuildContext context) {
    final isAnimal = data.animalName != null;

    final code = isAnimal ? data.animalCode : data.feedMedicineCode;

    final secondValue = isAnimal ? "${data.animalCode}" : data.feedMedicineName;

    return SectionCard(
      title: 'Item ${counter.toString()}',
      children: [
        SectionCard(
          children: [
            ProductHeaderCard(
              title: data.animalName ?? data.feedMedicineName ?? "-",
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
      ],
    );
  }
}
