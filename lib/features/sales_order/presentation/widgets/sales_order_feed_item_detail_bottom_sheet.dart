import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_item_request_model.dart';
import 'package:livestock/features/sales_order/sales_order_provider.dart';

class SalesOrderFeedItemDetailBottomSheet extends ConsumerWidget {
  final SalesOrderItemRequest item;

  const SalesOrderFeedItemDetailBottomSheet({super.key, required this.item});

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
                    _buildTransactionDetail(item),
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
          const Text(
            "Detail Pakan / Obat",
            style: AppTypography.largeBoldBlack,
          ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tanggal Pengiriman",
                        style: AppTypography.xSmallNormalGrey,
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        icon: AppImages.icCalendarNew,
                        title: formatDateTime(request.orderDate),
                        subtitle: request.farmLocation?.name ?? '-',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nama Pembeli",
                        style: AppTypography.xSmallNormalGrey,
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        icon: AppImages.icUserTagSvg,
                        title: request.customer?.name ?? '-',
                        subtitle: request.customer?.contactPhone ?? '-',
                      ),
                    ],
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

  Widget _buildTransactionDetail(SalesOrderItemRequest item) {
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
                  child: _buildFeedInfo(item),
                ),
                const Divider(color: AppColors.fieldBorder),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: _buildValueRow(
                    label1: "Jumlah",
                    value1: "${item.qty ?? 0} ${item.uom ?? '-'}",
                    label2: "Harga Satuan",
                    value2: "Rp ${formatPrice(item.unitPrice ?? 0)}",
                  ),
                ),
                const Divider(color: AppColors.fieldBorder),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: _buildValueRow(
                    label1: "Total Harga",
                    value1: "Rp ${formatPrice(item.subtotal ?? 0)}",
                    label2: "",
                    value2: "",
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          if (item.note != null && item.note!.isNotEmpty) _buildNoteBox(item),
        ],
      ),
    );
  }

  Widget _buildNoteBox(SalesOrderItemRequest item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Catatan", style: AppTypography.smallNormalGrey),
          const SizedBox(height: 8),
          Text(item.note!, style: AppTypography.smallNormalBlack),
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

  Widget _buildFeedInfo(SalesOrderItemRequest item) {
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
            child: Image.asset(AppImages.icProduct, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.feedMedicine?.code ?? '-',
              style: AppTypography.smallBoldBlack,
            ),
            Text(
              "${item.feedMedicine?.name ?? '-'} • ${item.feedMedicine?.feedType ?? '-'}",
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
