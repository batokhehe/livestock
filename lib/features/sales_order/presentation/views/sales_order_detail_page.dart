import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_detail_model.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_item_model.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/info_item_card.dart';
import '../../../../core/widgets/product_header_card.dart';
import '../../../../core/widgets/two_column_row_card.dart';
import '../../sales_order_provider.dart';
import '../widgets/sales_order_detail_card.dart';
import 'package:livestock/features/sales_order/data/model/sales_invoice_model.dart';
import 'invoice_downloader_provider.dart';

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
    final invoiceListAsync = ref.watch(salesInvoiceListProvider(id));

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
                    const SizedBox(height: 12),

                    SalesOrderDetailCard(item: data),

                    _infoSalesOrder(data),

                    const SizedBox(height: 12),

                    ...items.asMap().entries.map(
                      (entry) => _ProductInfoCard(
                        counter: entry.key + 1,
                        detailData: data,
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
                    const SizedBox(height: 12),
                    invoiceListAsync.when(
                      data: (invoices) => _invoiceListSection(invoices),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, s) => const SizedBox(),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _bottomActions(context, data),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoSalesOrder(SalesOrderDetail data) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Pemesanan", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),
          InfoItemCard(
            label: 'Tanggal Penjualan:',
            icon: AppImages.icCalendarNew,
            title: data.orderDate,
            subtitle: data.farmLocationName,
          ),
          InfoItemCard(
            label: 'Nama Pembeli:',
            icon: AppImages.icUserTagSvg,
            title: data.customer.name.toString(),
            subtitle: data.customer.contactPhone ?? '-',
          ),
          InfoItemCard(
            label: 'Nama Penerima:',
            icon: AppImages.icDirectBoxReceive,
            title: data.recipientName ?? '-',
            subtitle: data.recipientNumber ?? '-',
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

  Widget _bottomActions(BuildContext context, SalesOrderDetail data) {
    if (data.salesStatus != 'draft') return const SizedBox.shrink();
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push('/sales-order/create-invoice', extra: data);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Buat Nota",
                style: AppTypography.mediumBoldWhite,
              ),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              context.push('/sales-order/edit', extra: data);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Edit Data",
                    style: AppTypography.smallBoldPrimary.copyWith(
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.edit_rounded,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _invoiceListSection(List<SalesInvoice> invoices) {
    if (invoices.isEmpty) return const SizedBox();
    return SectionCard(
      title: 'Daftar Nota',
      children: invoices
          .map(
            (inv) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _invoiceItem(
                inv.id,
                inv.invoiceId,
                formatDateString(inv.invoiceDate),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _invoiceItem(int id, String title, String date) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.smallBoldBlack),
                const SizedBox(height: 4),
                Text(date, style: AppTypography.xSmallNormalGrey),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              final progress = ref.watch(invoiceDownloadProgressProvider(id));

              return ElevatedButton(
                onPressed: progress > 0
                    ? null
                    : () async {
                        try {
                          final path = await ref
                              .read(invoiceDownloaderProvider)
                              .downloadInvoice(id, "$title.pdf");
                          if (path != null) {
                            // Use open_filex for direct preview
                            await OpenFilex.open(path);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Gagal mengunduh: $e")),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF7E6),
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  progress > 0 ? "${(progress * 100).toInt()}%" : "Unduh",
                  style: AppTypography.xSmallBoldPrimary,
                ),
              );
            },
          ),
        ],
      ),
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
  final SalesOrderDetail detailData;
  final SalesOrderItem data;
  final int counter;

  const _ProductInfoCard({
    required this.detailData,
    required this.data,
    required this.counter,
  });

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
              title: code,
              subtitle: '${data.animalProfile?.name} • $secondValue',
              image: AppImages.icNavCow,
            ),
            const SizedBox(height: 12),
            Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
            if (detailData.isForecast == 'yes')
              TwoColumnRowCard(
                leftValue: 'Rp ${formatPrice(data.unitPrice)}',
                leftLabel: "Harga/kg Forecast",
                rightValue: 'Rp ${formatPrice(data.subtotal)}',
                rightLabel: "Total Forecast",
              )
            else
              TwoColumnRowCard(
                leftValue: 'Rp ${formatPrice(data.unitPrice)}',
                leftLabel: "Harga",
                rightValue: 'Rp ${formatPrice(data.subtotal)}',
                rightLabel: "Subtotal",
              ),
          ],
        ),
        if (isAnimal) ...[
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: 'Rp ${formatPrice(data.subtotal)}',
                subtitle: formatDateString(data.dlvDate ?? "-"),
                image: AppImages.icMoney,
              ),
              const SizedBox(height: 12),
              Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
              TwoColumnRowCard(
                leftValue: "Rp ${formatPrice(data.priceTotal)}",
                leftLabel: "Harga jual",
                rightValue: "Rp ${formatPrice(data.discount)}",
                rightLabel: "Harga diskon",
              ),
            ],
          ),
          if (detailData.isForecast == 'yes') ...[
            const SizedBox(height: 12),
            SectionCard(
              children: [
                ProductHeaderCard(
                  title: 'Transaksi Forecast',
                  subtitle:
                      '${data.forecastWeight} kg • ${data.forecastDate == null || data.forecastDate!.isEmpty ? '-' : formatDateString(data.forecastDate!)}',
                  image: AppImages.icReceipt,
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: formatDateString(data.dlvDate ?? "-"),
                subtitle: 'Tanggal Pengiriman',
                image: AppImages.icTruckFastSvg,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: '${data.state} • ${data.city}',
                subtitle: '${data.district} • ${data.village}',
                image: AppImages.icMapSvg,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            children: [
              ProductHeaderCard(
                title: data.deliveryAddress!,
                image: AppImages.icBookmark,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
