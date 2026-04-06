import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/item_double_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/features/dispatch/data/model/dispatch_lines_model.dart';
import 'package:livestock/features/dispatch/data/model/dispatch_list_model.dart';
import 'package:livestock/features/dispatch/presentation/widgets/dispatch_item_double_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/info_item_card.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../../../core/widgets/two_column_row_card.dart';
import '../../dispatch_provider.dart';

class DispatchDetailPage extends ConsumerWidget {
  final int id;

  const DispatchDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(dispatchDetailProvider(id));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Detail Pengiriman",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (detail) {
          return Scaffold(
            backgroundColor: AppColors.greyBg,
            body: _body(context, detail),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.push('/dispatch/edit/${detail.id}');
                  },
                  child: Text(
                    "Perbarui Pengiriman",
                    style: AppTypography.mediumBoldWhite,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, DispatchList detail) {
    final items = detail.items;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoDispatch(detail),
          const SizedBox(height: 12),
          _infoItem(items),
          const SizedBox(height: 12),
          _summaryCard(
            totalItem: items.length,
            deliveryFee: double.parse(detail.shippingCostTotal),
            downPayment: double.parse(detail.downPayment),
            additionalFee: double.parse(detail.additionalCost),
            total: double.parse(detail.shippingCostTotal),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(List<DispatchLine> items) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Item"),
          const SizedBox(height: 12),

          ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) => _itemCard(items[i]),
          ),
        ],
      ),
    );
  }

  Widget _itemCard(DispatchLine item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // ICON
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryShade,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset(
                      AppImages.icProduct,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.animalProfileName,
                        style: AppTypography.smallBoldBlack,
                      ),
                      Text(
                        item.salesOrderCode,
                        style: AppTypography.smallNormalGrey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
            child: TwoColumnRowCard(
              leftValue: item.city,
              leftLabel: "Kota Tujuan",
              rightValue: item.dlvDate,
              rightLabel: "Tanggal Kirim",
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Biaya Kirim", style: AppTypography.smallNormalGrey),
                Text(
                  "Rp ${formatPrice(double.tryParse(item.shippingCost) as num)}",
                  style: AppTypography.mediumBoldPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoDispatch(DispatchList detail) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Pengiriman"),
          const SizedBox(height: 12),
          DispatchItemDoubleCard(item: detail),
          InfoItemCard(
            title: formatDateString(detail.dispatchDate),
            subtitle: "Tanggal Pengiriman",
          ),
          InfoItemCard(
            title: detail.vehicleNumber,
            subtitle: detail.driverName,
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
    required double deliveryFee,
    required double downPayment,
    required double additionalFee,
    required double total,
  }) {
    return SectionCard(
      title: 'Rincian Bayar',
      children: [
        SectionCard(
          children: [
            _rowSummary("Jumlah Item", totalItem.toString()),
            _rowSummary("Total Biaya Kirim", formatPrice(deliveryFee)),
            _rowSummary("Uang Muka Pengiriman", formatPrice(downPayment)),
            _rowSummary("Biaya Tambahan", formatPrice(additionalFee)),
            _rowSummary(
              "Total Sisa Pembayaran",
              formatPrice(total),
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
