import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_item_request_model.dart';
import 'package:livestock/features/sales_order/sales_order_provider.dart';

class SalesOrderItemDetailBottomSheet extends ConsumerWidget {
  final SalesOrderItemRequest item;

  const SalesOrderItemDetailBottomSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(salesOrderFormProvider);

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
                    _buildOrderData(request),
                    const SizedBox(height: 8),
                    _buildTransactionDetail(request, item),
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
          const Text("Detail Hewan", style: AppTypography.largeBoldBlack),
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

  Widget _buildOrderData(dynamic request) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          Text("Data Pemesanan", style: AppTypography.smallNormalBlack),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: _buildInfoRow(
                    icon: AppImages.icCalendarNew,
                    title: formatDateTime(request.orderDate),
                    subtitle: request.farmLocation?.name ?? '-',
                  ),
                ),
                const Divider(color: AppColors.fieldBorder),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: _buildInfoRow(
                    icon: AppImages.icUserTagSvg,
                    title: request.customer?.name ?? '-',
                    subtitle: request.customer?.contactPhone ?? '-',
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetail(dynamic request, SalesOrderItemRequest item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          Text("Transaksi & Pelunasan", style: AppTypography.smallNormalGrey),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: _buildAnimalInfo(item),
                ),
                const Divider(color: AppColors.fieldBorder),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: _buildValueRow(
                    label1: request.useForecast
                        ? "Est. Harga Jual/kg"
                        : "Harga Jual/kg",
                    value1:
                        "Rp ${formatPrice(item.animalProfile?.refSalesPrice ?? 0)}",
                    label2: request.useForecast
                        ? "Est. Harga Jual Total"
                        : "Harga Jual Total",
                    value2:
                        "Rp ${formatPrice(item.animalProfile?.refSalesPriceTotal ?? 0)}",
                  ),
                ),
                if (request.useForecast ?? true) ...[
                  const Divider(color: AppColors.fieldBorder),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    child: _buildValueRow(
                      label1: "Tanggal Forecast",
                      value1: formatDateTime(request.forecastDate),
                      label2: "Berat Forecast",
                      value2: "${item.forecastWeight ?? 0} kg",
                    ),
                  ),
                  const Divider(color: AppColors.fieldBorder),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    child: _buildValueRow(
                      label1: "Harga/kg Forecast",
                      value1: "Rp ${formatPrice(item.unitPrice ?? 0)}",
                      label2: "Total Forecast",
                      value2: "Rp ${formatPrice(item.subtotal ?? 0)}",
                    ),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
          _buildSubtotalBox(item),
          if (request.useForecast ?? true)
            _buildSmallInfoCard(
              icon: AppImages.icReceipt,
              title: "Transaksi Forecast",
              subtitle: "kg • ${formatDateTime(request.forecastDate)}",
            ),
          _buildSmallInfoCard(
            icon: AppImages.icTruckFastSvg,
            title: formatDateTime(item.dlvDate),
            subtitle: "Tanggal Pengiriman",
          ),
          _buildSmallInfoCard(
            icon: AppImages.icMapSvg,
            title: "${item.state ?? '-'} • ${item.city ?? '-'}",
            subtitle: "${item.district ?? '-'} • ${item.village ?? '-'}",
          ),
          _buildSmallInfoCard(
            icon: AppImages.icBookmark,
            title: item.deliveryAddress ?? '-',
            subtitle: "Alamat Lengkap",
            isLast: true,
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
            child: SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
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
      ],
    );
  }

  Widget _buildAnimalInfo(SalesOrderItemRequest item) {
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
            child: SvgPicture.asset(
              AppImages.icNavCow,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.animalProfile?.animalCode ?? '-',
              style: AppTypography.smallBoldBlack,
            ),
            Text(
              "${item.animalProfile?.name ?? '-'} • ${item.animalProfile?.weight ?? 0} kg",
              style: AppTypography.xSmallNormalGrey,
            ),
          ],
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

  Widget _buildSubtotalBox(SalesOrderItemRequest item) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
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
                    child: SvgPicture.asset(
                      AppImages.icMoney,
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rp ${formatPrice(item.subtotal ?? 0)}",
                      style: AppTypography.smallBoldBlack,
                    ),
                    Text(
                      formatDateTime(item.dlvDate),
                      style: AppTypography.xSmallNormalGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.fieldBorder),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            child: _buildPricingRow(
              "Harga jual",
              "Rp ${formatPrice(item.unitPrice ?? 0)}",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            child: _buildPricingRow(
              "Harga diskon",
              "Rp ${formatPrice(item.discount ?? 0)}",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            child: _buildPricingRow(
              "Biaya Pengiriman",
              "Rp ${formatPrice(item.shippingCost ?? 0)}",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.smallNormalGrey,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: AppTypography.smallBoldBlack,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSmallInfoCard({
    required String icon,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              child: SvgPicture.asset(
                icon,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
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
