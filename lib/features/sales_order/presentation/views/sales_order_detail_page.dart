import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_item_model.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_list_model.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/info_item_card.dart';
import '../../../../core/widgets/product_header_card.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../../../core/widgets/two_column_row_card.dart';
import '../../data/model/sales_order_item_request_model.dart';
import '../../sales_order_provider.dart';

class SalesOrderDetailPage extends ConsumerWidget {
  final int id;

  const SalesOrderDetailPage({super.key, required this.id});

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(salesOrderDetailProvider(id));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Detail Penjualan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())),
        data: (data) {
          final items = data.items;
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepInfoCard(
                      title: "Detail Penjualan",
                      step: 3,
                      totalStep: 3,
                    ),

                    const SizedBox(height: 12),

                    _infoSalesOrder(data),

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
                      subtotal: data.subtotal.toDouble(),
                      discount: data.discountTotal.toDouble(),
                      total: data.amountTotal.toDouble(),
                      formatCurrency: formatCurrency,
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

  /// =========================
  /// INFORMASI PENJUALAN
  /// =========================

  Widget _infoSalesOrder(SalesOrderList data) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Pemesanan", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),
          InfoItemCard(
            icon: AppImages.icCalendarTick,
            title: data.orderDate,
            subtitle: data.farmLocationName,
          ),
          InfoItemCard(
            icon: AppImages.icUserTag,
            title: data.customer.toString(),
            subtitle: data.customer.contactPhone.toString(),
          ),
          InfoItemCard(
            icon: AppImages.icUser,
            title: data.recipientName ?? '-',
            subtitle: data.recipientNumber ?? '-',
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
    required double discount,
    required double total,
    required String Function(double) formatCurrency,
  }) {
    return SectionCard(
      title: 'Rincian Bayar',
      children: [
        SectionCard(
          children: [
            _rowSummary("Jumlah Item", totalItem.toString()),
            _rowSummary("Subtotal", formatCurrency(subtotal)),
            _rowSummary("Diskon", formatCurrency(discount)),
            _rowSummary(
              "Total Keseluruhan",
              formatCurrency(total),
              isBold: true,
            ),
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
  final SalesOrderItem data;
  final int counter;

  const _ProductInfoCard({required this.data, required this.counter});

  @override
  Widget build(BuildContext context) {
    final isAnimal = data.animalProfile != null;

    final code = isAnimal
        ? data.animalProfile!.animalCode
        : data.feedMedicineCode;

    final secondValue = isAnimal
        ? "${data.animalProfile!.weight} Kg"
        : '-'; //data.feedMedicine!.feedType;

    return SectionCard(
      title: 'Item ${counter.toString()}',
      children: [
        SectionCard(
          children: [
            ProductHeaderCard(
              title: data.animalProfile?.name ?? data.feedMedicineCode,
              subtitle: '$code • $secondValue',
              image: AppImages.icProduct,
            ),
            const SizedBox(height: 12),
            Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
            TwoColumnRowCard(
              leftValue: data.unitPrice.toString(),
              leftLabel: "Harga/kg Forecast",
              rightValue: data.subTotal.toString(),
              rightLabel: "Total Forecast",
            ),
          ],
        ),
        if (isAnimal) ...[
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: data.subTotal.toString(),
                subtitle: data.dlvDate,
                image: AppImages.icMoneys,
              ),
              Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
              TwoColumnRowCard(
                leftValue: data.unitPrice.toString(),
                leftLabel: "Harga jual",
                rightValue: data.discount.toString(),
                rightLabel: "Harga diskon",
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: 'Transaksi Forecast',
                subtitle: 'kg • ${data.dlvDate}',
                image: AppImages.icMoneys,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: data.dlvDate.toString(),
                subtitle: 'Tanggal Pengiriman',
                image: AppImages.icTruckFast,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: '${data.state} • ${data.city}',
                subtitle: '${data.district} • ${data.village}',
                image: AppImages.icMap,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: data.deliveryAddress!,
                image: AppImages.icMap,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
