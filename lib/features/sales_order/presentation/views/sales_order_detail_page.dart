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
import '../widgets/sales_invoice_detail_bottom_sheet.dart';
import '../widgets/cancel_sales_invoice_bottom_sheet.dart';
import 'invoice_downloader_provider.dart';
import 'package:livestock/features/receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import 'package:livestock/features/user/domain/user_model.dart';
import 'package:livestock/features/user/providers/user_provider.dart';

import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/widgets/success_notification.dart';

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
    final userAsync = ref.watch(userProvider);

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
                      amountPaid: data.amountPaid.toDouble(),
                      amountRemainder: data.amountRemainder.toDouble(),
                      formatCurrency: formatCurrency,
                    ),
                    if (userAsync.value?.hasPermission('invoices-read') ??
                        false) ...[
                      const SizedBox(height: 12),
                      invoiceListAsync.when(
                        data: (invoices) =>
                            _invoiceListSection(context, invoices),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, s) => const SizedBox(),
                      ),
                    ],
                    const SizedBox(height: 70),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _bottomActions(
                  context,
                  data,
                  userAsync.value,
                  invoiceListAsync.value ?? [],
                ),
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
            title: data.recipientName,
            subtitle: data.recipientNumber,
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
    required double amountPaid,
    required double amountRemainder,
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
            _rowSummary(
              "Jumlah dibayar",
              formatCurrency(amountPaid),
              isBold: true,
            ),
            _rowSummary(
              "Sisa Pembayaran",
              formatCurrency(amountRemainder),
              isBold: true,
              valueColor: amountRemainder <= 0
                  ? AppColors.emerald700
                  : AppColors.danger,
            ),
          ],
        ),
      ],
    );
  }

  Widget _bottomActions(
    BuildContext context,
    SalesOrderDetail data,
    UserModel? user,
    List<SalesInvoice> invoices,
  ) {
    if (data.salesStatus == 'closed' || data.salesStatus == 'canceled') {
      return const SizedBox.shrink();
    }
    final canCreateInvoice = user?.hasPermission('invoices-create') ?? false;
    bool canUpdateSO = user?.hasPermission('salesorder-update') ?? false;

    // Validasi: Hide tombol edit jika status confirmed dan sudah ada nota
    // KECUALI jika semua nota statusnya canceled, maka boleh edit
    if (data.salesStatus == 'confirmed' && invoices.isNotEmpty) {
      final allCanceled = invoices.every((inv) => inv.paymentStatus == 'canceled');
      if (!allCanceled) {
        canUpdateSO = false;
      }
    }

    if (!canCreateInvoice && !canUpdateSO) return const SizedBox.shrink();

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canCreateInvoice)
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
          if (canCreateInvoice && canUpdateSO) const SizedBox(height: 12),
          if (canUpdateSO)
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

  Widget _invoiceListSection(
    BuildContext context,
    List<SalesInvoice> invoices,
  ) {
    if (invoices.isEmpty) return const SizedBox();
    return SectionCard(
      title: 'Daftar Nota',
      children: invoices
          .map(
            (inv) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _invoiceItem(context, inv),
            ),
          )
          .toList(),
    );
  }

  String _getPaymentStatus(String status) {
    switch (status) {
      case 'down_payment':
        return 'Uang Muka';
      case 'partial':
        return 'Pembayaran Sebagian';
      case 'full_payment':
        return 'Pelunasan';
      case 'canceled':
        return 'Dibatalkan';
      default:
        return "-";
    }
  }

  Widget _invoiceItem(BuildContext context, SalesInvoice inv) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SalesInvoiceDetailBottomSheet(invoice: inv),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.fieldBorder.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(inv.invoiceId, style: AppTypography.smallBoldBlack),
                  const SizedBox(height: 4),
                  Text(
                    formatDateString(inv.invoiceDate),
                    style: AppTypography.xSmallNormalGrey,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: inv.paymentStatus == 'canceled'
                          ? AppColors.danger.withValues(alpha: 0.1)
                          : const Color(0xFFFFF7E6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getPaymentStatus(inv.paymentStatus),
                      style: inv.paymentStatus == 'canceled'
                          ? AppTypography.xSmallBoldBlack.copyWith(
                              color: AppColors.danger,
                              fontSize: 10,
                            )
                          : AppTypography.xSmallBoldPrimary.copyWith(
                              fontSize: 10,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final progress = ref.watch(
                      invoiceDownloadProgressProvider(inv.id),
                    );

                    return ElevatedButton(
                      onPressed: progress > 0
                          ? null
                          : () async {
                              try {
                                final path = await ref
                                    .read(invoiceDownloaderProvider)
                                    .downloadInvoice(
                                      inv.id,
                                      "${inv.invoiceId}.pdf",
                                    );
                                if (path != null) {
                                  // Use open_filex for direct preview
                                  await OpenFilex.open(path);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Gagal mengunduh: $e"),
                                    ),
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF7E6),
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(120, 32),
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
                if (inv.paymentStatus != 'canceled') ...[
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, ref, _) {
                      final canDestroy =
                          ref
                              .watch(userProvider)
                              .value
                              ?.hasPermission('invoices-destroy') ??
                          false;
                      if (!canDestroy) return const SizedBox.shrink();

                      return ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (sheetCtx) => CancelSalesInvoiceBottomSheet(
                              onConfirm: (account) async {
                                if (account == null) return;

                                final isOk = await showModalBottomSheet<bool>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => const ConfirmationBottomSheet(
                                    header: "Konfirmasi Pembatalan",
                                    title: "Batalkan Nota?",
                                    subTitle:
                                        "Apakah Anda yakin ingin membatalkan nota ini?",
                                    saveText: "Ya",
                                  ),
                                );

                                if (isOk != true) return;

                                try {
                                  final payload = {
                                    "status": "canceled",
                                    "payment_status": "canceled",
                                    "amount_paid": inv.amountPaid,
                                    "amount_total": inv.amountTotal,
                                    "payment_type": inv.paymentType ?? "cash",
                                    "sales_order_id": inv.salesOrderId,
                                    "chart_of_account_id": "", //kosongkan
                                    "chart_of_account_id_reversed": account.id
                                        .toString(),
                                    "bank_account_id": "", //kosongkan
                                  };

                                  await ref
                                      .read(salesOrderApiProvider)
                                      .cancelSalesInvoice(inv.id, payload);

                                  if (context.mounted) {
                                    SuccessNotification.show(
                                      title: "Berhasil",
                                      subtitle: "Nota berhasil dibatalkan",
                                    );
                                    ref.invalidate(
                                      salesInvoiceListProvider(id),
                                    );
                                    ref.invalidate(
                                      salesOrderDetailProvider(id),
                                    );
                                  }
                                } on DioException catch (e) {
                                  if (context.mounted) {
                                    String? msg;
                                    final rd = e.response?.data;
                                    if (rd is Map) {
                                      msg = rd['message'];
                                    } else if (rd is String) {
                                      try {
                                        final parsed = jsonDecode(rd);
                                        if (parsed is Map) {
                                          msg = parsed['message'];
                                        }
                                      } catch (_) {}
                                    }

                                    final errorMessage =
                                        msg ??
                                        e.message ??
                                        "Gagal membatalkan nota";

                                    SuccessNotification.show(
                                      title: "Peringatan",
                                      subtitle: errorMessage.toString(),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    SuccessNotification.show(
                                      title: "Peringatan",
                                      subtitle: "Gagal membatalkan nota: $e",
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger.withValues(
                            alpha: 0.1,
                          ),
                          foregroundColor: AppColors.danger,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          minimumSize: const Size(120, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Batalkan Nota",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.danger,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.navigate_next_rounded,
              color: AppColors.iconColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowSummary(
    String title,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
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
                ? AppTypography.smallBoldPrimary.copyWith(color: valueColor)
                : AppTypography.smallBoldBlack.copyWith(color: valueColor),
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
        ? "${data.weight} Kg"
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
