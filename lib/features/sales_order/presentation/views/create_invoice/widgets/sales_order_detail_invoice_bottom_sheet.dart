import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_detail_model.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_item_model.dart';

class SalesOrderDetailInvoiceBottomSheet extends StatelessWidget {
  final SalesOrderDetail item;

  const SalesOrderDetailInvoiceBottomSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  children: [
                    _buildOrderData(),
                    const SizedBox(height: 12),
                    ...item.items.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildItemDetail(entry.value, entry.key + 1),
                      );
                    }).toList(),
                    _buildPaymentSummary(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Detail Penjualan", style: AppTypography.largeBoldBlack),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.iconColor, width: 2),
              ),
              child: const Icon(Icons.close_rounded, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderData() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Data Pemesanan", style: AppTypography.smallNormalGrey),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: AppImages.icCalendarNew,
                  title: item.orderDate,
                  subtitle: item.farmLocationName,
                ),
                const Divider(height: 24, color: AppColors.fieldBorder),
                _buildInfoRow(
                  icon: AppImages.icUserTagSvg,
                  title: item.customerName,
                  subtitle: item.phone ?? '-',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetail(SalesOrderItem orderItem, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Item $index", style: AppTypography.smallNormalGrey),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: AppImages.icNavCow,
                  title: orderItem.item,
                  subtitle:
                      "${orderItem.animalCode ?? orderItem.feedMedicineCode} • ${orderItem.weight} kg",
                ),
                const Divider(height: 24, color: AppColors.fieldBorder),
                _buildValueRow(
                  label1: "Harga/kg Forecast",
                  value1: "Rp ${formatPrice(orderItem.unitPrice)}",
                  label2: "Total Forecast",
                  value2: "Rp ${formatPrice(orderItem.subtotal)}",
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildSubItemBox(orderItem),
          if (item.isForecast == "yes" || item.isForecast == "1") ...[
            const SizedBox(height: 12),
            _buildSmallInfoCard(
              icon: AppImages.icReceipt,
              title: "Transaksi Forecast",
              subtitle:
                  "${orderItem.forecastWeight > 0 ? orderItem.forecastWeight : ''} kg • ${orderItem.forecastDate == null || orderItem.forecastDate!.isEmpty ? '-' : formatDateString(orderItem.forecastDate!)}",
            ),
          ],
          const SizedBox(height: 12),
          _buildSmallInfoCard(
            icon: AppImages.icTruckFastSvg,
            title: orderItem.dlvDate ?? '-',
            subtitle: "Tanggal Pengiriman",
          ),
          const SizedBox(height: 12),
          _buildSmallInfoCard(
            icon: AppImages.icMapSvg,
            title: "${orderItem.state ?? '-'} • ${orderItem.city ?? '-'}",
            subtitle:
                "${orderItem.district ?? '-'} • ${orderItem.village ?? '-'}",
          ),
          const SizedBox(height: 12),
          _buildSmallInfoCard(
            icon: AppImages.icBookmark,
            title: orderItem.deliveryAddress ?? '-',
            subtitle: "Alamat Lengkap",
          ),
        ],
      ),
    );
  }

  Widget _buildSubItemBox(SalesOrderItem orderItem) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: AppImages.icMoney,
            title: "Rp ${formatPrice(orderItem.subtotal)}",
            subtitle: orderItem.dlvDate ?? '-',
          ),
          const Divider(height: 24, color: AppColors.fieldBorder),
          _buildPricingRow(
            "Harga jual",
            "Rp ${formatPrice(orderItem.unitPrice)}",
          ),
          const SizedBox(height: 8),
          _buildPricingRow(
            "Harga diskon",
            "Rp ${formatPrice(orderItem.discount)}",
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rincian Bayar", style: AppTypography.smallNormalGrey),
          const SizedBox(height: 12),
          _buildPricingRow("Jumlah Item", item.items.length.toString()),
          const SizedBox(height: 8),
          _buildPricingRow("Subtotal", "Rp ${formatPrice(item.subtotal)}"),
          const SizedBox(height: 8),
          _buildPricingRow("Diskon", "Rp ${formatPrice(item.discountTotal)}"),
          const Divider(height: 24, color: AppColors.fieldBorder),
          _buildPricingRow(
            "Subtotal",
            "Rp ${formatPrice(item.amountTotal)}",
            isBold: true,
            valueColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    final bool isSvg = icon.endsWith('.svg');
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: isSvg
                ? SvgPicture.asset(
                    icon,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  )
                : Image.asset(icon, color: AppColors.primary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.smallBoldBlack,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: AppTypography.xSmallNormalGrey,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildValueRow({
    required String label1,
    required String value1,
    required String label2,
    required String value2,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value1,
                style: AppTypography.smallBoldBlack,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label1,
                style: AppTypography.xSmallNormalGrey,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value2,
                style: AppTypography.smallBoldBlack,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label2,
                style: AppTypography.xSmallNormalGrey,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.smallNormalGrey),
        Text(
          value,
          style: isBold
              ? AppTypography.smallBoldPrimary.copyWith(color: valueColor)
              : AppTypography.smallBoldBlack.copyWith(color: valueColor),
        ),
      ],
    );
  }

  Widget _buildSmallInfoCard({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    final bool isSvg = icon.endsWith('.svg');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.greyBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: isSvg
                  ? SvgPicture.asset(
                      icon,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    )
                  : Image.asset(icon, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.smallBoldBlack),
                Text(subtitle, style: AppTypography.xSmallNormalGrey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
