import 'package:flutter/material.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import '../../data/models/stock_inventory_model.dart';

class StockItemListCard extends StatelessWidget {
  final StockInventoryItem item;

  const StockItemListCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final typeLower = item.itemType.toLowerCase();
    final isPakan = typeLower == 'feed' || typeLower == 'pakan';
    final typeLabel = isPakan
        ? 'Pakan'
        : (typeLower == 'medicine' || typeLower == 'obat'
              ? 'Obat'
              : item.itemType);

    final locationText =
        item.farmLocationName != null && item.farmLocationName!.isNotEmpty
        ? item.farmLocationName!
        : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Item Name, Item Code, & Item Type Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: AppTypography.smallBoldBlack.copyWith(
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.itemCode,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isPakan
                        ? const Color(0xFFFFF7E6)
                        : const Color(0xFFE6F7ED),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    typeLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isPakan
                          ? AppColors.primary
                          : const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row 2: Location
            Row(
              children: [
                const Icon(
                  Icons.warehouse_outlined,
                  size: 13,
                  color: AppColors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    locationText,
                    style: const TextStyle(fontSize: 11, color: AppColors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Row 3: Stock Metrics (Awal, Masuk, Keluar, Stock Akhir)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.baseBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildMetric(
                    label: "Awal",
                    value: formatPrice(item.openingQty),
                    valueColor: AppColors.black,
                  ),
                  _buildDivider(),
                  _buildMetric(
                    label: "Masuk",
                    value: "+${formatPrice(item.incomingQty)}",
                    valueColor: AppColors.success,
                  ),
                  _buildDivider(),
                  _buildMetric(
                    label: "Keluar",
                    value: "-${formatPrice(item.outgoingQty)}",
                    valueColor: AppColors.danger,
                  ),
                  _buildDivider(),
                  _buildMetric(
                    label: item.uom.isNotEmpty
                        ? "Akhir (${item.uom})"
                        : "Akhir",
                    value: formatPrice(item.endingQty),
                    valueColor: AppColors.primary,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric({
    required String label,
    required String value,
    required Color valueColor,
    bool isBold = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? AppColors.black : AppColors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 11 : 11,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w500,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 20,
      width: 1,
      color: AppColors.fieldBorder,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
