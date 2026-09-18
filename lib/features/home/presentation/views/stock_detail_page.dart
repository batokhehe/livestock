import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/search_bar_card.dart';
import '../../stock_inventory_provider.dart';
import '../widgets/stock_item_list_card.dart';

enum StockCategoryTab {
  all(label: 'Semua', apiKey: 'all'),
  pakan(label: 'Stock Pakan', apiKey: 'feed'),
  obat(label: 'Stock Obat', apiKey: 'medicine');

  final String label;
  final String apiKey;
  const StockCategoryTab({required this.label, required this.apiKey});
}

class StockDetailPage extends ConsumerStatefulWidget {
  final String? initialType;

  const StockDetailPage({super.key, this.initialType});

  @override
  ConsumerState<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends ConsumerState<StockDetailPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    String initialTabKey = 'all';
    if (widget.initialType == 'feed' || widget.initialType == 'pakan') {
      initialTabKey = 'feed';
    } else if (widget.initialType == 'medicine' ||
        widget.initialType == 'obat') {
      initialTabKey = 'medicine';
    }

    Future.microtask(() {
      ref.read(stockInventoryTabProvider.notifier).state = initialTabKey;
      ref.read(stockInventorySearchProvider.notifier).state = '';
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(stockInventoryNotifierProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        ref.read(stockInventorySearchProvider.notifier).state = value
            .trim()
            .toLowerCase();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTabKey = ref.watch(stockInventoryTabProvider);
    final state = ref.watch(stockInventoryNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          "Detail Persediaan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarCard(
            hint: 'Cari persediaan, kode, atau lokasi...',
            controller: _searchCtrl,
            onChanged: _onSearchChanged,
            onClear: () {
              _searchCtrl.clear();
              ref.read(stockInventorySearchProvider.notifier).state = '';
            },
          ),
          // Category Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: StockCategoryTab.values.map((tab) {
                final isActive = activeTabKey == tab.apiKey;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      if (!isActive) {
                        ref.read(stockInventoryTabProvider.notifier).state =
                            tab.apiKey;
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primaryShade
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.fieldBorder,
                        ),
                      ),
                      child: Text(
                        tab.label,
                        style: AppTypography.smallNormalPrimary.copyWith(
                          color: isActive ? AppColors.primary : AppColors.black,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Count Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   "Total: ${state.summary?.totalItems ?? state.items.length} Item",
                //   style: AppTypography.xSmallNormalGrey,
                // ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // List of Stock Items with infinite scroll & pull to refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(stockInventoryNotifierProvider.notifier)
                    .refresh();
              },
              color: AppColors.primary,
              child: _buildContent(state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(StockInventoryState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.danger,
              ),
              const SizedBox(height: 12),
              Text("Gagal memuat data", style: AppTypography.mediumBoldBlack),
              const SizedBox(height: 6),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: AppTypography.xSmallNormalGrey,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(stockInventoryNotifierProvider.notifier).refresh();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Coba Lagi"),
              ),
            ],
          ),
        ),
      );
    }

    if (state.items.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        }
        return StockItemListCard(item: state.items[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.icEmptyDefault,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            const Text(
              "Belum Ada Data yang Tersedia",
              style: AppTypography.mediumBoldBlack,
            ),
            const SizedBox(height: 8),
            Text(
              "Sesuaikan kata kunci pencarian atau filter untuk menemukan data persediaan yang dicari",
              textAlign: TextAlign.center,
              style: AppTypography.xSmallNormalGrey.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
