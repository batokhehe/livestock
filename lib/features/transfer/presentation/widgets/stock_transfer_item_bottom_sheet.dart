import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import '../../data/model/stock_transfer_item_model.dart';
import '../../transfer_provider.dart';

class StockTransferItemBottomSheet extends ConsumerStatefulWidget {
  final StockTransferItem? initialSelected;
  final String title;
  final String description;
  final bool showSearch;

  const StockTransferItemBottomSheet({
    super.key,
    this.initialSelected,
    this.title = "Pilih Item Stock",
    this.description = "Silakan pilih salah satu item stock untuk pemindahan.",
    this.showSearch = true,
  });

  @override
  ConsumerState<StockTransferItemBottomSheet> createState() =>
      _StockTransferItemBottomSheetState();
}

class _StockTransferItemBottomSheetState
    extends ConsumerState<StockTransferItemBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  StockTransferItem? _currentSelected;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.initialSelected;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(paginatedStockTransferItemsProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(paginatedStockTransferItemsProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(widget.title, style: AppTypography.largeBoldBlack),
          const SizedBox(height: 8),
          Text(widget.description, style: AppTypography.smallNormalGrey),
          const SizedBox(height: 20),

          if (widget.showSearch) ...[
            TextField(
              onChanged: (val) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  ref.read(stockTransferSearchProvider.notifier).state = val;
                });
              },
              decoration: InputDecoration(
                hintText: "Cari item...",
                hintStyle: AppTypography.smallNormalGrey,
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                filled: true,
                fillColor: AppColors.greyBg,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          Expanded(
            child: asyncData.when(
              data: (res) {
                final items = res.data;
                final total = res.total ?? res.totalRows ?? 0;
                final hasMore = items.length < total;

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada item ditemukan.",
                      style: AppTypography.smallNormalGrey,
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: items.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = items[index];
                    final isSelected = _currentSelected?.id == item.id &&
                        _currentSelected?.farmLocationId == item.farmLocationId;

                    return _buildItem(
                      item: item,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _currentSelected = item;
                        });
                        Navigator.pop(context, item);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildItem({
    required StockTransferItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final qtyStr = item.qty % 1 == 0 ? item.qty.toInt().toString() : item.qty.toString();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.fieldBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style: isSelected
                        ? AppTypography.smallBoldBlack
                        : AppTypography.smallNormalBlack,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item.itemCode} • ${item.farmLocationName}${item.farmAreaName != null ? ' (${item.farmAreaName})' : ''}",
                    style: AppTypography.xSmallNormalGrey,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.emerald700.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "$qtyStr ${item.uom ?? 'Unit'}",
                style: AppTypography.xSmallNormalPrimary.copyWith(
                  color: AppColors.emerald700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
