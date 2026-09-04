import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:livestock/features/user/providers/user_provider.dart';

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:livestock/features/receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../../../core/widgets/success_notification.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/bottom_button.dart';
import '../../../../core/widgets/search_bar_card.dart';
import '../../../../core/helpers/utils.dart';
import '../../data/model/sales_order_list_model.dart';
import '../../data/model/sales_invoice_model.dart';
import '../../sales_order_provider.dart';
import '../widgets/sales_order_date_group_card.dart';
import '../widgets/sales_order_filter_bottom_sheet.dart';
import '../widgets/sales_invoice_detail_bottom_sheet.dart';
import '../widgets/cancel_sales_invoice_bottom_sheet.dart';
import 'invoice_downloader_provider.dart';

class SalesOrderPage extends ConsumerStatefulWidget {
  const SalesOrderPage({super.key});

  @override
  ConsumerState<SalesOrderPage> createState() => _SalesOrderPageState();
}

class _SalesOrderPageState extends ConsumerState<SalesOrderPage> {
  late final TextEditingController searchCtrl;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();
    Future.microtask(() {
      ref.read(salesOrderSearchProvider.notifier).state = '';
      ref.read(salesOrderMainTabProvider.notifier).state =
          SalesOrderMainTab.penjualan;
      ref.read(salesOrderTabProvider.notifier).state = SalesOrderTab.all;
      ref.read(salesInvoiceFilterProvider.notifier).state =
          SalesInvoiceFilter.all;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    if (value.length < 2 && value.isNotEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(salesOrderSearchProvider.notifier).state = value;
    });
  }

  void _clearSearch() {
    searchCtrl.clear();
    _debounce?.cancel();
    ref.read(salesOrderSearchProvider.notifier).state = '';
  }

  Widget _buildErrorWidget(Object err, StackTrace stack) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Terjadi Error:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(err.toString()),
          const SizedBox(height: 16),
          const Text(
            "Stacktrace:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(stack.toString()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainTab = ref.watch(salesOrderMainTabProvider);
    final salesOrderAsync = ref.watch(salesOrderListProvider);
    final invoiceAsync = ref.watch(salesInvoiceListAllProvider);
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Penjualan", style: AppTypography.largeBoldBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Column(
        children: [
          SearchBarCard(
            hint: mainTab == SalesOrderMainTab.penjualan
                ? 'Cari Penjualan'
                : 'Cari Nota',
            controller: searchCtrl,
            onChanged: _onSearchChanged,
            onClear: _clearSearch,
            showFilter: true,
            onFilterTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const SalesOrderFilterBottomSheet(),
              );
            },
          ),

          /// 🔥 TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _mainTabItem(
                  SalesOrderMainTab.penjualan,
                  mainTab == SalesOrderMainTab.penjualan,
                  "Penjualan",
                ),
                const SizedBox(width: 8),
                _mainTabItem(
                  SalesOrderMainTab.nota,
                  mainTab == SalesOrderMainTab.nota,
                  "Nota",
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                if (mainTab == SalesOrderMainTab.penjualan) {
                  await ref.refresh(salesOrderListProvider.future);
                } else {
                  await ref.refresh(salesInvoiceListAllProvider.future);
                }
              },
              child: mainTab == SalesOrderMainTab.penjualan
                  ? salesOrderAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => _buildErrorWidget(err, stack),
                      data: (list) => _SalesOrderList(list),
                    )
                  : invoiceAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => _buildErrorWidget(err, stack),
                      data: (list) => _SalesInvoiceList(list),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          mainTab == SalesOrderMainTab.penjualan &&
              (userAsync.value?.hasPermission('salesorder-create') ?? false)
          ? BottomButton(
              text: 'Tambah Penjualan',
              onPressed: () {
                showSalesTypeBottomSheet(context);
              },
            )
          : null,
    );
  }

  Widget _mainTabItem(SalesOrderMainTab value, bool isActive, String label) {
    return GestureDetector(
      onTap: () {
        ref.read(salesOrderMainTabProvider.notifier).state = value;
        _clearSearch();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryShade : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.smallNormalPrimary.copyWith(
            color: isActive ? AppColors.primary : AppColors.black,
          ),
        ),
      ),
    );
  }

  void showSalesTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pilih Penjualan',
                    style: AppTypography.largeBoldBlack,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.iconColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.close_rounded, size: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Hewan
              _SalesTypeItem(
                title: 'Hewan',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/sales-order/add?type=animal');
                },
              ),

              const SizedBox(height: 12),

              /// Pakan / Obat
              _SalesTypeItem(
                title: 'Pakan',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/sales-order/add?type=feed');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SalesOrderList extends StatelessWidget {
  final List<SalesOrderList> list;

  const _SalesOrderList(this.list);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
          children: [
            Image.asset(
              AppImages.icEmptyDefault,
              width: 250,
              height: 250,
              fit: BoxFit.fitWidth,
            ),
            Text(
              "Belum Ada Data yang Tersedia",
              style: AppTypography.mediumBoldBlack,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Tambahkan data baru atau sesuaikan filter untuk\nmelihat informasi di kategori ini",
                textAlign: TextAlign.center,
                style: AppTypography.smallNormalWhite.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final Map<String, List<SalesOrderList>> grouped = {};

    for (final item in list) {
      grouped.putIfAbsent(item.orderDate, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) {
        return SalesOrderDateGroupCard(
          dateLabel: entry.key,
          items: entry.value,
        );
      }).toList(),
    );
  }
}

class _SalesTypeItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SalesTypeItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: AppTypography.mediumBoldBlack.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _SalesInvoiceList extends StatelessWidget {
  final List<SalesInvoice> list;

  const _SalesInvoiceList(this.list);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
          children: [
            Image.asset(
              AppImages.icEmptyDefault,
              width: 250,
              height: 250,
              fit: BoxFit.fitWidth,
            ),
            const Text(
              "Belum Ada Data yang Tersedia",
              style: AppTypography.mediumBoldBlack,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Tambahkan data baru atau sesuaikan filter untuk\nmelihat informasi di kategori ini",
                textAlign: TextAlign.center,
                style: AppTypography.smallNormalWhite.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return _SalesInvoiceCard(invoice: item);
      },
    );
  }
}

class _SalesInvoiceCard extends ConsumerWidget {
  final SalesInvoice invoice;

  const _SalesInvoiceCard({required this.invoice});

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
        return status;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final formattedAmount = currencyFormat.format(invoice.amountTotal);
    final isCanceled = invoice.paymentStatus == 'canceled';
    final isSetor = invoice.setoranStatus == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) =>
                  SalesInvoiceDetailBottomSheet(invoice: invoice),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      invoice.invoiceId,
                      style: AppTypography.mediumBoldBlack,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Setoran Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSetor
                            ? const Color(0xFFE6F7ED) // light green
                            : const Color(0xFFFFF1F0), // light red
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isSetor ? 'Sudah Disetor' : 'Belum Disetor',
                        style: AppTypography.xSmallBoldBlack.copyWith(
                          color: isSetor
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828),
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Payment Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isCanceled
                            ? AppColors.danger.withValues(alpha: 0.1)
                            : const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getPaymentStatus(invoice.paymentStatus),
                        style: isCanceled
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
                const SizedBox(height: 12),
                if (invoice.customerName != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        invoice.customerName!,
                        style: AppTypography.smallNormalBlack,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formatDateString(invoice.invoiceDate),
                          style: AppTypography.smallNormalBlack,
                        ),
                      ],
                    ),
                    Text(
                      formattedAmount,
                      style: AppTypography.mediumBoldPrimary,
                    ),
                  ],
                ),
                const Divider(height: 24, color: AppColors.fieldBorder),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isCanceled) ...[
                      Consumer(
                        builder: (context, ref, _) {
                          final canDestroy =
                              ref
                                  .watch(userProvider)
                                  .value
                                  ?.hasPermission('invoices-destroy') ??
                              false;
                          if (!canDestroy) return const SizedBox.shrink();

                          return OutlinedButton(
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
                                        "amount_paid": invoice.amountPaid,
                                        "amount_total": invoice.amountTotal,
                                        "payment_type":
                                            invoice.paymentType ?? "cash",
                                        "sales_order_id": invoice.salesOrderId,
                                        "chart_of_account_id": "",
                                        "chart_of_account_id_reversed": account
                                            .id
                                            .toString(),
                                        "bank_account_id": "",
                                      };

                                      await ref
                                          .read(salesOrderApiProvider)
                                          .cancelSalesInvoice(
                                            invoice.id,
                                            payload,
                                          );

                                      if (context.mounted) {
                                        SuccessNotification.show(
                                          title: "Berhasil",
                                          subtitle: "Nota berhasil dibatalkan",
                                        );
                                        ref.invalidate(
                                          salesInvoiceListAllProvider,
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
                                    }
                                  },
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: const BorderSide(color: AppColors.danger),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              minimumSize: const Size(100, 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Batalkan",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                    Consumer(
                      builder: (context, ref, _) {
                        final progress = ref.watch(
                          invoiceDownloadProgressProvider(invoice.id),
                        );

                        return ElevatedButton(
                          onPressed: progress > 0
                              ? null
                              : () async {
                                  try {
                                    final path = await ref
                                        .read(invoiceDownloaderProvider)
                                        .downloadInvoice(
                                          invoice.id,
                                          "${invoice.invoiceId}.pdf",
                                        );
                                    if (path != null) {
                                      await OpenFilex.open(path);
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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
                            minimumSize: const Size(100, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            progress > 0
                                ? "${(progress * 100).toInt()}%"
                                : "Unduh",
                            style: AppTypography.xSmallBoldPrimary.copyWith(
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
