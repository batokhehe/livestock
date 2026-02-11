import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../../receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../data/model/sales_order_item_request_model.dart';
import '../../sales_order_provider.dart';

class AddSalesOrderConfirmationPage extends ConsumerWidget {
  const AddSalesOrderConfirmationPage({super.key});

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
    final form = ref.watch(salesOrderFormProvider);
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
          "Tambah Penjualan",
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
                  (entry) => _itemCard(
                    index: entry.key + 1,
                    item: entry.value,
                    formatCurrency: formatCurrency,
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
                            header: "Konfirmasi Penjualan",
                            title: "Lanjutkan Penjualan Item?",
                            subTitle:
                                "Mohon pastikan semua item dan detail sudah sesuai sebelum melanjutkan transaksi",
                            saveText: "Simpan Penjualan",
                          ),
                        );

                        if (result == true) {
                          try {
                            await ref
                                .read(salesOrderFormProvider.notifier)
                                .submitSalesOrder();

                            ref.read(salesOrderFormProvider.notifier).reset();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Penjualan berhasil disimpan",
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            context.go('/sales-order');
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
  /// INFORMASI PENJUALAN
  /// =========================

  Widget _infoSalesOrder(dynamic form) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Pemesanan", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),

          _rowInfo("Tanggal Penjualan", form.orderDate?.toString() ?? "-"),
          _rowInfo("Tanggal Pelunasan", form.dueDate?.toString() ?? "-"),
          _rowInfo("Nama Pelanggan", form.customer?.name ?? "-"),
        ],
      ),
    );
  }

  Widget _rowInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.smallNormalGrey),
          Text(value, style: AppTypography.smallBoldBlack),
        ],
      ),
    );
  }

  /// =========================
  /// ITEM CARD
  /// =========================

  Widget _itemCard({
    required int index,
    required SalesOrderItemRequest item,
    required String Function(double) formatCurrency,
  }) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Item $index", style: AppTypography.smallNormalGrey),
          const SizedBox(height: 8),

          Text(
            item.animalProfile?.name ?? "-",
            style: AppTypography.mediumBoldBlack,
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatCurrency(item.unitPrice ?? 0),
                style: AppTypography.smallBoldBlack,
              ),
              Text(
                formatCurrency(item.subtotal ?? 0),
                style: AppTypography.smallBoldBlack,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "Pengiriman: ${item.dlvDate?.toString() ?? "-"}",
            style: AppTypography.xSmallNormalGrey,
          ),

          const SizedBox(height: 6),

          Text(
            "${item.state ?? "-"}, ${item.city ?? "-"}",
            style: AppTypography.xSmallNormalGrey,
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
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ringkasan Bayar", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),

          _rowSummary("Jumlah Item", totalItem.toString()),
          _rowSummary("Subtotal", formatCurrency(subtotal)),
          _rowSummary("Diskon", formatCurrency(discount)),

          const Divider(),

          _rowSummary("Total Keseluruhan", formatCurrency(total), isBold: true),
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
                ? AppTypography.smallBoldBlack
                : AppTypography.smallNormalGrey,
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
