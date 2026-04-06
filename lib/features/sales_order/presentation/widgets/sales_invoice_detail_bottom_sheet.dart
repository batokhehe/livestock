import 'package:flutter/material.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/sales_order/data/model/sales_invoice_model.dart';

class SalesInvoiceDetailBottomSheet extends StatelessWidget {
  final SalesInvoice invoice;

  const SalesInvoiceDetailBottomSheet({super.key, required this.invoice});

  String _getPaymentStatus(String status) {
    switch (status) {
      case 'down_payment':
        return 'Sebagian';
      case 'paid':
        return 'Lunas';
      case 'unpaid':
        return 'Belum Dibayar';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Ringkasan Faktur", style: AppTypography.mediumBoldBlack),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Rincian Bayar", style: AppTypography.smallBoldBlack),
          const SizedBox(height: 12),
          _buildInfoRow("Pesanan Penjualan", invoice.orderId ?? '-'),
          _buildInfoRow("Nama Pelanggan", invoice.customerName ?? '-'),
          _buildInfoRow("Tipe Pembayaran", invoice.paymentType ?? '-'),
          _buildInfoRow("Akun keuangan", invoice.coaName ?? '-'),
          _buildInfoRow("Status pembayaran", _getPaymentStatus(invoice.paymentStatus)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1, color: AppColors.greyBg),
          ),
          _buildInfoRow("Total Item", invoice.totalItem.toString()),
          _buildInfoRow("Sub Total", "Rp ${formatPrice(invoice.subtotal)}"),
          _buildInfoRow("Diskon", "Rp ${formatPrice(invoice.discountTotal)}"),
          _buildInfoRow(
            "Total keseluruhan",
            "Rp ${formatPrice(invoice.amountTotal)}",
            isBoldValue: true,
          ),
          _buildInfoRow(
            "Jumlah dibayar",
            "Rp ${formatPrice(invoice.amountTotalPaid)}",
            isBold: true,
            valueColor: AppColors.primary, // Orange/Primary
          ),
          _buildInfoRow(
            "Sisa Pembayaran",
            "Rp ${formatPrice(invoice.sisaTagihan)}",
            isBold: true,
            valueColor: AppColors.success, // Green
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    bool isBoldValue = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold ? AppTypography.smallBoldBlack : AppTypography.smallNormalBlack,
          ),
          Text(
            value,
            style: isBold || isBoldValue
                ? AppTypography.smallBoldBlack.copyWith(color: valueColor)
                : AppTypography.smallNormalBlack.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
