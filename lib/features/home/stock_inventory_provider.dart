import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import 'data/api/stock_inventory_api.dart';
import 'data/models/stock_inventory_model.dart';

final stockInventoryApiProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return StockInventoryApi(dio);
});

final stockInventoryTabProvider = StateProvider.autoDispose<String>((ref) => 'all');
final stockInventorySearchProvider = StateProvider.autoDispose<String>((ref) => '');

class StockInventoryState {
  final List<StockInventoryItem> items;
  final StockInventorySummary? summary;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final String? error;

  const StockInventoryState({
    this.items = const [],
    this.summary,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.error,
  });

  StockInventoryState copyWith({
    List<StockInventoryItem>? items,
    StockInventorySummary? summary,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    String? error,
  }) {
    return StockInventoryState(
      items: items ?? this.items,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error,
    );
  }
}

class StockInventoryNotifier extends StateNotifier<StockInventoryState> {
  final StockInventoryApi _api;
  final String tab;
  final String search;

  static const int perPage = 15;

  StockInventoryNotifier(
    this._api, {
    required this.tab,
    required this.search,
  }) : super(const StockInventoryState(isLoading: true)) {
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    state = state.copyWith(
      isLoading: true,
      page: 1,
      hasMore: true,
      error: null,
    );
    try {
      final String? itemType =
          (tab == 'all' || tab.isEmpty) ? null : tab;
      final response = await _api.getStockInventories(
        itemType: itemType,
        page: 1,
        perPage: perPage,
        search: search.isEmpty ? null : search,
      );

      final hasMore = response.data.length >= perPage;
      state = state.copyWith(
        items: response.data,
        summary: response.summary,
        isLoading: false,
        hasMore: hasMore,
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.page + 1;

    try {
      final String? itemType =
          (tab == 'all' || tab.isEmpty) ? null : tab;
      final response = await _api.getStockInventories(
        itemType: itemType,
        page: nextPage,
        perPage: perPage,
        search: search.isEmpty ? null : search,
      );

      final hasMore = response.data.length >= perPage;
      state = state.copyWith(
        items: [...state.items, ...response.data],
        summary: response.summary ?? state.summary,
        isLoadingMore: false,
        hasMore: hasMore,
        page: nextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        hasMore: false,
      );
    }
  }

  Future<void> refresh() async {
    await fetchInitial();
  }
}

final stockInventoryNotifierProvider = StateNotifierProvider.autoDispose<
    StockInventoryNotifier, StockInventoryState>((ref) {
  final api = ref.read(stockInventoryApiProvider);
  final tab = ref.watch(stockInventoryTabProvider);
  final search = ref.watch(stockInventorySearchProvider);

  return StockInventoryNotifier(api, tab: tab, search: search);
});
