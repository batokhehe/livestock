import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/animal_group_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/supplier_model.dart';

import '../../core/network/dio_client.dart';
import 'data/api/purchase_order_api.dart';
import 'data/model/purchase_order_item_request_model.dart';
import 'data/model/purchase_order_list_model.dart';
import 'data/model/purchase_order_request_model.dart';
import 'data/model/purchase_invoice_model.dart';

enum PurchaseOrderTab { animal, feed, equipment }

extension PurchaseOrderTabX on PurchaseOrderTab {
  String get apiValue {
    switch (this) {
      case PurchaseOrderTab.animal:
        return 'animal';
      case PurchaseOrderTab.feed:
        return 'feed';
      case PurchaseOrderTab.equipment:
        return 'equipment';
    }
  }

  String get label {
    switch (this) {
      case PurchaseOrderTab.animal:
        return 'Hewan';
      case PurchaseOrderTab.feed:
        return 'Pakan & Obat';
      case PurchaseOrderTab.equipment:
        return 'Peralatan';
    }
  }
}

final purchaseOrderSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final purchaseOrderTabProvider =
    StateProvider.autoDispose<PurchaseOrderTab>((ref) {
      return PurchaseOrderTab.animal;
    });

final purchaseOrderApiProvider = Provider((ref) {
  return PurchaseOrderApi(ref.read(dioProvider));
});

final purchaseOrderListProvider =
    StateNotifierProvider.autoDispose<
      PurchaseOrderListNotifier,
      AsyncValue<List<PurchaseOrderList>>
    >((ref) => PurchaseOrderListNotifier(ref));

class PurchaseOrderListNotifier
    extends StateNotifier<AsyncValue<List<PurchaseOrderList>>> {
  final Ref ref;
  int _page = 1;
  final int _perPage = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  PurchaseOrderListNotifier(this.ref) : super(const AsyncLoading()) {
    _init();
  }

  void _init() {
    ref.listen(purchaseOrderTabProvider, (previous, next) {
      refresh();
    });
    ref.listen(purchaseOrderSearchProvider, (previous, next) {
      refresh();
    });

    fetch();
  }

  Future<void> fetch({bool isRefresh = false}) async {
    if (isRefresh) {
      _page = 1;
      _hasMore = true;
      _isLoadingMore = false;
    }

    if (!_hasMore || _isLoadingMore) return;

    if (_page > 1) {
      _isLoadingMore = true;
      state = AsyncData(state.value ?? []);
    } else {
      state = const AsyncLoading();
    }

    try {
      final api = ref.read(purchaseOrderApiProvider);
      final tab = ref.read(purchaseOrderTabProvider);
      final search = ref.read(purchaseOrderSearchProvider);

      final items = await api.getPurchaseOrder(
        type: tab.apiValue,
        search: search,
        page: _page,
        perPage: _perPage,
      );

      if (isRefresh) {
        state = AsyncData(items);
      } else {
        final currentItems = state.value ?? [];
        state = AsyncData([...currentItems, ...items]);
      }

      _hasMore = items.length == _perPage;
      _page++;
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refresh() async {
    await fetch(isRefresh: true);
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

final purchaseOrderFormProvider =
    StateNotifierProvider.autoDispose<
      PurchaseOrderFormNotifier,
      PurchaseOrderRequest
    >((ref) => PurchaseOrderFormNotifier(ref));

class PurchaseOrderFormNotifier extends StateNotifier<PurchaseOrderRequest> {
  final Ref ref;

  PurchaseOrderFormNotifier(this.ref) : super(PurchaseOrderRequest());

  /// =============================
  /// SETTERS
  /// =============================

  void setPurchaseOrderDate(DateTime value) {
    state = state.copyWith(purchDate: value);
  }

  void setPurchaseItemType(String? value) {
    state = state.copyWith(purchaseItemType: value);
  }

  void setSupplier(Supplier value) {
    state = state.copyWith(supplier: value, supplierAddress: value.address);
  }

  void setSupplierAddress(String value) {
    state = state.copyWith(supplierAddress: value);
  }

  void setFarmLocation(FarmLocation value) {
    state = state.copyWith(farmLocation: value);
  }

  void setAnimalGroup(AnimalGroup value) {
    state = state.copyWith(animalGroup: value);
  }

  void setItems(List<PurchaseOrderItemRequest> items) {
    state = state.copyWith(items: items);
  }

  void addItem(PurchaseOrderItemRequest item) {
    final currentItems = state.items ?? [];
    state = state.copyWith(items: [...currentItems, item]);
  }

  void removeItem(PurchaseOrderItemRequest item) {
    final currentItems = state.items ?? [];
    currentItems.remove(item);
    state = state.copyWith(items: [...currentItems]);
  }

  void reset() {
    state = PurchaseOrderRequest();
  }

  void setShippingCost(String value) {
    state = state.copyWith(shippingCost: double.tryParse(value));
  }

  void setAdditionalCost(String value) {
    state = state.copyWith(additionalCost: double.tryParse(value));
  }

  /// =============================
  /// SUBMIT
  /// =============================

  Future<void> submitPurchaseOrder() async {
    final api = ref.read(purchaseOrderApiProvider);
    if (state.supplier == null) {
      throw Exception("Suplier belum dipilih");
    }

    if (state.items == null || state.items!.isEmpty) {
      throw Exception("Item tidak boleh kosong");
    }

    await api.submitPurchaseOrder(state);
  }

  Future<void> updatePurchaseOrder(int id) async {
    final api = ref.read(purchaseOrderApiProvider);
    if (state.supplier == null) {
      throw Exception("Suplier belum dipilih");
    }

    if (state.items == null || state.items!.isEmpty) {
      throw Exception("Item tidak boleh kosong");
    }

    await api.updatePurchaseOrder(id, state);
  }
}

extension PurchaseOrderValidation on PurchaseOrderRequest {
  bool get isValid {
    final isBasicFilled =
        purchDate != null &&
        supplier != null &&
        supplierAddress != null &&
        supplierAddress!.trim().isNotEmpty;

    if (purchaseItemType == 'animal') {
      return isBasicFilled && animalGroup != null && farmLocation != null;
    }

    return isBasicFilled;
  }
}

final purchaseOrderDetailProvider = FutureProvider.family
    .autoDispose<PurchaseOrderList, int>((ref, id) async {
      final api = ref.read(purchaseOrderApiProvider);
      final res = await api.getPurchaseOrderDetail(id);
      return res.data;
    });


class PurchaseInvoiceState {
  final List<PurchaseInvoice> invoices;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final bool isExpanded;

  PurchaseInvoiceState({
    this.invoices = const [],
    this.isLoading = false,
    this.hasMore = false,
    this.currentPage = 1,
    this.isExpanded = true,
  });

  PurchaseInvoiceState copyWith({
    List<PurchaseInvoice>? invoices,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    bool? isExpanded,
  }) {
    return PurchaseInvoiceState(
      invoices: invoices ?? this.invoices,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class PurchaseInvoiceListNotifier extends StateNotifier<PurchaseInvoiceState> {
  final Ref ref;
  final int poId;

  PurchaseInvoiceListNotifier(this.ref, this.poId) : super(PurchaseInvoiceState()) {
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    state = state.copyWith(isLoading: true);
    try {
      final api = ref.read(purchaseOrderApiProvider);
      final result = await api.getPurchaseInvoices(poId, page: 1);
      state = state.copyWith(
        invoices: result.invoices,
        hasMore: result.hasMore,
        currentPage: 1,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    try {
      final api = ref.read(purchaseOrderApiProvider);
      final nextPage = state.currentPage + 1;
      final result = await api.getPurchaseInvoices(poId, page: nextPage);
      state = state.copyWith(
        invoices: [...state.invoices, ...result.invoices],
        hasMore: result.hasMore,
        currentPage: nextPage,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void toggleExpand() {
    state = state.copyWith(isExpanded: !state.isExpanded);
  }
}

final purchaseInvoiceListProvider = StateNotifierProvider.family
    .autoDispose<PurchaseInvoiceListNotifier, PurchaseInvoiceState, int>((ref, id) {
  return PurchaseInvoiceListNotifier(ref, id);
});
