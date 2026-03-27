import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/success_notification.dart';
import 'package:livestock/features/receiving/presentation/widgets/confirmation_bottom_sheet.dart';

import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/card_wrapper.dart';
import '../../../../../core/widgets/info_item_card.dart';
import '../../../../../core/widgets/product_header_card.dart';
import '../../../../../core/widgets/step_info_card.dart';
import '../../../../../core/widgets/two_column_row_card.dart';
import '../../../data/model/sales_order_detail_model.dart';
import '../../../data/model/sales_order_item_request_model.dart';
import '../../../sales_order_provider.dart';

class EditSalesOrderConfirmationPage extends ConsumerWidget {
  final SalesOrderDetail detail;

  const EditSalesOrderConfirmationPage({super.key, required this.detail});

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
    final form = ref.watch(editSalesOrderFormProvider);
    final items = form.items ?? [];

    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + (item.subtotal ?? 0),
    );

    final discount = items.fold<double>(
      0,
      (sum, item) => sum + (item.discount ?? 0),
    );

    final total = subtotal - discount;

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Edit Penjualan",
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
                  title: "Tinjau Rincian Penjualan",
                  step: 3,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                _infoSalesOrder(form),
                const SizedBox(height: 12),
                ...items.asMap().entries.map(
                      (entry) => _ProductInfoCard(
                        counter: entry.key + 1,
                        data: entry.value,
                        useForecast: form.useForecast ?? true,
                        forecastDate: form.forecastDate,
                      ),
                    ),
                const SizedBox(height: 12),
                _summaryCard(
                  totalItem: items.length,
                  subtotal: subtotal,
                  discount: discount,
                  total: total,
                  formatCurrency: formatCurrency,
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
                  backgroundColor:
                      items.isEmpty ? AppColors.grey : AppColors.primary,
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
                          backgroundColor: AppColors.greyBg,
                          builder: (_) => const ConfirmationBottomSheet(
                            header: "Konfirmasi Edit",
                            title: "Simpan Perubahan Penjualan?",
                            subTitle:
                                "Mohon pastikan semua item dan detail sudah sesuai sebelum menyimpan perubahan",
                            saveText: "Simpan Perubahan",
                          ),
                        );

                        if (result == true) {
                          try {
                            await ref
                                .read(editSalesOrderFormProvider.notifier)
                                .updateSalesOrder(detail.id);

                            SuccessNotification.show(
                              title: "Penjualan Berhasil Diperbarui",
                              subtitle:
                                  "Data penjualan telah berhasil disimpan.",
                            );

                             if (context.mounted) {
                               ref.read(editSalesOrderFormProvider.notifier).reset();
                               ref.invalidate(salesOrderListProvider);
                               ref.invalidate(salesOrderDetailProvider(detail.id));
                               ref.read(salesOrderTabProvider.notifier).state = SalesOrderTab.all;
                               context.go('/sales-order');
                             }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Gagal menyimpan: $e")),
                              );
                            }
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

  Widget _infoSalesOrder(dynamic form) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Pemesanan", style: AppTypography.smallNormalBlack),
          const SizedBox(height: 12),
          InfoItemCard(
            label: 'Tanggal Penjualan:',
            icon: AppImages.icCalendarNew,
            title: formatDateTime(form.orderDate),
            subtitle: form.farmLocation?.name ?? '-',
          ),
          InfoItemCard(
            label: 'Nama Pembeli:',
            icon: AppImages.icUserTagSvg,
            title: form.customer?.name ?? '-',
            subtitle: form.customer?.contactPhone?.toString() ?? '-',
          ),
          InfoItemCard(
            label: 'Nama Penerima:',
            icon: AppImages.icDirectBoxReceive,
            title: form.recipientName ?? '-',
            subtitle: form.recipientNumber ?? '-',
          ),
        ],
      ),
    );
  }

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
  final SalesOrderItemRequest data;
  final int counter;
  final bool useForecast;
  final DateTime? forecastDate;

  const _ProductInfoCard({
    required this.data,
    required this.counter,
    required this.useForecast,
    this.forecastDate,
  });

  @override
  Widget build(BuildContext context) {
    final isAnimal = data.animalProfile != null;

    final code =
        isAnimal ? data.animalProfile!.animalCode : data.feedMedicine!.code;

    final secondValue = isAnimal
        ? "${data.animalProfile!.weight} Kg"
        : data.feedMedicine!.feedType;

    return SectionCard(
      title: 'Item ${counter.toString()}',
      children: [
        SectionCard(
          children: [
            ProductHeaderCard(
              title: data.animalProfile?.name ?? data.feedMedicine!.name,
              subtitle: '$code • $secondValue',
              image: AppImages.icNavCow,
            ),
            const SizedBox(height: 12),
            const Divider(
                height: 1, thickness: 1, color: AppColors.fieldBorder),
            if (useForecast)
              TwoColumnRowCard(
                leftValue: 'Rp ${formatPrice(data.unitPrice ?? 0)}',
                leftLabel: "Harga/kg Forecast",
                rightValue: 'Rp ${formatPrice(data.subtotal ?? 0)}',
                rightLabel: "Total Forecast",
              )
            else
              TwoColumnRowCard(
                leftValue: 'Rp ${formatPrice(data.unitPrice ?? 0)}',
                leftLabel: "Harga",
                rightValue: 'Rp ${formatPrice(data.subtotal ?? 0)}',
                rightLabel: "Subtotal",
              ),
          ],
        ),
        if (isAnimal) ...[
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: 'Rp ${formatPrice(data.subtotal ?? 0)}',
                subtitle: formatDateTime(data.dlvDate),
                image: AppImages.icMoney,
              ),
              const SizedBox(height: 12),
              const Divider(
                  height: 1, thickness: 1, color: AppColors.fieldBorder),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Harga jual",
                      style: AppTypography.xSmallNormalBlack),
                  Text("Rp ${formatPrice(data.unitPrice ?? 0)}",
                      style: AppTypography.smallBoldBlack),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Harga diskon",
                      style: AppTypography.xSmallNormalBlack),
                  Text("Rp ${formatPrice(data.discount ?? 0)}",
                      style: AppTypography.smallBoldBlack),
                ],
              ),
            ],
          ),
          if (useForecast) ...[
            const SizedBox(height: 12),
            SectionCard(
              children: [
                ProductHeaderCard(
                  title: 'Transaksi Forecast',
                  subtitle:
                      '${data.forecastWeight ?? 0} kg • ${formatDateTime(forecastDate)}',
                  image: AppImages.icReceipt,
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: formatDateTime(data.dlvDate),
                subtitle: 'Tanggal Pengiriman',
                image: AppImages.icTruckFastSvg,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: '${data.state ?? '-'} • ${data.city ?? '-'}',
                subtitle: '${data.district ?? '-'} • ${data.village ?? '-'}',
                image: AppImages.icMapSvg,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: data.deliveryAddress ?? '-',
                image: AppImages.icBookmark,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
