import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/section_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/info_item_card.dart';
import '../../data/model/purchase_order_list_model.dart';
import '../../purchase_order_provider.dart';
import '../../data/model/purchase_invoice_model.dart';
import '../widgets/purchase_invoice_item_card.dart';
import '../widgets/purchase_order_item_card.dart';
import 'package:livestock/features/user/providers/user_provider.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:livestock/core/widgets/success_notification.dart';
import 'package:livestock/features/receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../widgets/cancel_purchase_invoice_bottom_sheet.dart';

class PurchaseOrderDetailPage extends ConsumerWidget {
  final int id;

  const PurchaseOrderDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(purchaseOrderDetailProvider(id));
    final invoiceState = ref.watch(purchaseInvoiceListProvider(id));
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Detail Pembelian",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (data) {
          final items = data.details;
          final totalItem = items.fold<int>(
            0,
            (sum, item) => sum + (item.quantity > 0 ? item.quantity : 1),
          );

          final subtotal = items.fold<double>(
            0,
            (sum, item) =>
                sum +
                (item.purchPrice * (item.quantity > 0 ? item.quantity : 1)),
          );
          final total = subtotal + (data.shippingCost);

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(purchaseOrderDetailProvider(id));
                  ref.invalidate(purchaseInvoiceListProvider(id));
                  return ref.read(purchaseOrderDetailProvider(id).future);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoPurchaseOrder(data),
                      const SizedBox(height: 12),
                      ...items.map((item) => PurchaseOrderItemCard(data: item)),
                      const SizedBox(height: 12),
                      _summaryCard(
                        totalItem: totalItem,
                        subtotal: subtotal,
                        shippingCost: data.shippingCost,
                        total: total,
                        isAnimal: data.animalGroup != null,
                        amountRemainder: data.amountRemainder,
                      ),
                      if (userAsync.value?.hasPermission('invoices-read') ??
                          false) ...[
                        const SizedBox(height: 12),
                        _invoiceListSection(context, ref, id, invoiceState),
                      ],
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _bottomAction(context, data, invoiceState.invoices, ref),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _bottomAction(
    BuildContext context,
    PurchaseOrderList data,
    List<PurchaseInvoice> invoices,
    WidgetRef ref,
  ) {
    if (data.purchStatus == 'closed' || data.purchStatus == 'canceled') {
      return const SizedBox.shrink();
    }

    final user = ref.watch(userProvider).value;
    final canCreateInvoice = user?.hasPermission('invoices-create') ?? false;
    bool canUpdatePO = true;

    // Validation: Hide edit button if already has invoices
    // EXCEPT if all invoices are canceled
    if (invoices.isNotEmpty) {
      final allCanceled = invoices.every(
        (inv) => inv.paymentStatus == 'canceled',
      );
      if (!allCanceled) {
        canUpdatePO = false;
      }
    }

    if (!canCreateInvoice && !canUpdatePO) return const SizedBox.shrink();

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
                  context.push('/purchase-order/create-invoice', extra: data);
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
          if (canUpdatePO) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                context.push('/purchase-order/edit', extra: data);
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
        ],
      ),
    );
  }

  Widget _invoiceListSection(
    BuildContext context,
    WidgetRef ref,
    int poId,
    PurchaseInvoiceState state,
  ) {
    if (state.invoices.isEmpty && !state.isLoading) return const SizedBox();

    return SectionCard(
      title: 'Daftar Nota',
      trailing: IconButton(
        onPressed: () {
          ref.read(purchaseInvoiceListProvider(poId).notifier).toggleExpand();
        },
        icon: Icon(
          state.isExpanded
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          color: AppColors.primary,
        ),
      ),
      children: [
        if (state.isExpanded) ...[
          ...state.invoices.map(
            (inv) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: PurchaseInvoiceItemCard(
                invoice: inv,
                onCancel: () => _onCancelInvoice(context, ref, inv),
              ),
            ),
          ),
          if (state.hasMore)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          ref
                              .read(purchaseInvoiceListProvider(poId).notifier)
                              .loadMore();
                        },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.fieldBorder),
                    ),
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Muat Lebih Banyak",
                          style: AppTypography.smallBoldPrimary,
                        ),
                ),
              ),
            ),
        ],
        if (!state.isExpanded && state.invoices.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "${state.invoices.length} Nota tersedia",
              style: AppTypography.xSmallNormalGrey,
            ),
          ),
      ],
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
            subtitle: data.animalGroup != null
                ? (data.farmLocation?.name ?? "-")
                : "Tanggal Pembelian",
          ),
          InfoItemCard(
            icon: AppImages.icUserTag,
            title: data.supplierName ?? "-",
            subtitle: data.supplierAddress ?? "-",
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
    required bool isAnimal,
    required double amountRemainder,
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
            _rowSummary("Biaya Pengiriman", formatPrice(shippingCost)),
            _rowSummary("Total Keseluruhan", formatPrice(total), isBold: true),
            _rowSummary("Sisa Pembayaran", formatPrice(amountRemainder)),
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

  Future<void> _onCancelInvoice(
    BuildContext context,
    WidgetRef ref,
    PurchaseInvoice invoice,
  ) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => CancelPurchaseInvoiceBottomSheet(
        onConfirm: (account) async {
          if (account == null) return;

          final isOk = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const ConfirmationBottomSheet(
              header: "Konfirmasi Pembatalan",
              title: "Batalkan Nota?",
              subTitle: "Apakah Anda yakin ingin membatalkan nota ini?",
              saveText: "Ya",
            ),
          );

          if (isOk != true) return;

          try {
            final payload = {
              "status": "canceled",
              "payment_status": "canceled",
              "amount_paid": invoice.amountPaid,
              "amount_total": invoice.amountTotal,
              "payment_type": invoice.paymentType ?? "cash",
              "purch_order_id": invoice.purchOrderId,
              "chart_of_account_id": "", //kosongkan
              "chart_of_account_id_reversed": account.id.toString(),
              "bank_account_id": "", //kosongkan
            };

            await ref
                .read(purchaseOrderApiProvider)
                .cancelPurchaseInvoice(invoice.id, payload);

            if (context.mounted) {
              SuccessNotification.show(
                title: "Berhasil",
                subtitle: "Nota berhasil dibatalkan",
              );
            }

            // Refresh state
            ref.invalidate(purchaseInvoiceListProvider(id));
            ref.invalidate(purchaseOrderDetailProvider(id));
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

              final errorMessage = msg ?? e.message ?? "Gagal membatalkan nota";

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
  }
}
