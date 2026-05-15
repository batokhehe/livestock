import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_invoice_model.dart';
import 'package:livestock/features/purchase_order/presentation/views/create_invoice/purchase_invoice_downloader_provider.dart';
import 'package:livestock/features/user/providers/user_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'purchase_invoice_detail_bottom_sheet.dart';

class PurchaseInvoiceItemCard extends ConsumerWidget {
  final PurchaseInvoice invoice;
  final VoidCallback? onCancel;

  const PurchaseInvoiceItemCard({
    super.key,
    required this.invoice,
    this.onCancel,
  });

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) =>
              PurchaseInvoiceDetailBottomSheet(invoice: invoice),
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
                  Text(invoice.invoiceId, style: AppTypography.smallBoldBlack),
                  const SizedBox(height: 4),
                  Text(
                    formatDateString(invoice.invoiceDate),
                    style: AppTypography.xSmallNormalGrey,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: invoice.paymentStatus == 'canceled'
                          ? AppColors.danger.withValues(alpha: 0.1)
                          : const Color(0xFFFFF7E6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getPaymentStatus(invoice.paymentStatus),
                      style: invoice.paymentStatus == 'canceled'
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
                _downloadButton(ref, context),
                if (invoice.paymentStatus != 'canceled') ...[
                  const SizedBox(height: 8),
                  _cancelButton(ref, context),
                ],
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.navigate_next_rounded, color: AppColors.grey),
          ],
        ),
      ),
    );
  }

  Widget _downloadButton(WidgetRef ref, BuildContext context) {
    final progress = ref.watch(
      purchaseInvoiceDownloadProgressProvider(invoice.id),
    );

    return ElevatedButton(
      onPressed: progress > 0
          ? null
          : () async {
              try {
                final path = await ref
                    .read(purchaseInvoiceDownloaderProvider)
                    .downloadInvoice(invoice.id, "${invoice.invoiceId}.pdf");
                if (path != null) {
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
        minimumSize: const Size(120, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        progress > 0 ? "${(progress * 100).toInt()}%" : "Unduh",
        style: AppTypography.xSmallBoldPrimary,
      ),
    );
  }

  Widget _cancelButton(WidgetRef ref, BuildContext context) {
    final canDestroy =
        ref.watch(userProvider).value?.hasPermission('invoices-destroy') ??
        false;
    if (!canDestroy) return const SizedBox.shrink();

    return ElevatedButton(
      onPressed: onCancel,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.danger.withValues(alpha: 0.1),
        foregroundColor: AppColors.danger,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(120, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
  }
}
