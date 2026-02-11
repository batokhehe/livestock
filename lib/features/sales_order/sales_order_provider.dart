import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';

import '../../core/data/model/customer_model.dart';
import '../../core/network/dio_client.dart';
import 'data/api/sales_order_api.dart';
import 'data/model/sales_order_item_request_model.dart';
import 'data/model/sales_order_list_model.dart';
import 'data/model/sales_order_request_model.dart';

enum SalesOrderTab { all, sell, confirmed, closed }

extension SalesOrderTabX on SalesOrderTab {
  String get apiValue {
    switch (this) {
      case SalesOrderTab.all:
        return 'all';
      case SalesOrderTab.sell:
        return 'sell';
      case SalesOrderTab.confirmed:
        return 'confirmed';
      case SalesOrderTab.closed:
        return 'closed';
    }
  }

  String get label {
    switch (this) {
      case SalesOrderTab.all:
        return 'Semua';
      case SalesOrderTab.sell:
        return 'Terjual';
      case SalesOrderTab.confirmed:
        return 'Dikonfirmasi';
      case SalesOrderTab.closed:
        return 'Tutup';
    }
  }

  // String get ext {
  //   switch (this) {
  //     case SalesOrderTab.animal:
  //       return 'hewan';
  //     case SalesOrderTab.feed:
  //       return 'item';
  //     case SalesOrderTab.equipment:
  //       return 'item';
  //   }
  // }
}

final salesOrderSearchProvider = StateProvider<String>((ref) => '');

final salesOrderTabProvider = StateProvider<SalesOrderTab>((ref) {
  return SalesOrderTab.all;
});

final salesOrderApiProvider = Provider((ref) {
  return SalesOrderApi(ref.read(dioProvider));
});

final salesOrderListProvider = FutureProvider.autoDispose<List<SalesOrderList>>(
  (ref) async {
    final api = ref.read(salesOrderApiProvider);
    final tab = ref.watch(salesOrderTabProvider);

    return api.getSalesOrder(status: tab.apiValue);
  },
);

final salesOrderFormProvider =
    StateNotifierProvider<SalesOrderFormNotifier, SalesOrderRequest>(
      (ref) => SalesOrderFormNotifier(ref),
    );

class SalesOrderFormNotifier extends StateNotifier<SalesOrderRequest> {
  final Ref ref;

  SalesOrderFormNotifier(this.ref) : super(SalesOrderRequest());

  /// =============================
  /// SETTERS
  /// =============================

  void setSalesOrderDate(DateTime value) {
    state = state.copyWith(orderDate: value);
  }

  void setCustomer(Customer value) {
    state = state.copyWith(customer: value);
  }

  void setFarmLocation(FarmLocation value) {
    state = state.copyWith(farmLocation: value);
  }

  void setDueDate(DateTime value) {
    state = state.copyWith(dueDate: value);
  }

  void setForecastDate(DateTime value) {
    state = state.copyWith(forecastDate: value);
  }

  void setCategory(String value) {
    state = state.copyWith(category: value);
  }

  void setUseForecast(bool value) {
    state = state.copyWith(useForecast: value);
  }

  void setItems(List<SalesOrderItemRequest> items) {
    state = state.copyWith(items: items);
  }

  void addItem(SalesOrderItemRequest item) {
    final currentItems = state.items ?? [];
    state = state.copyWith(items: [...currentItems, item]);
  }

  void removeItem(SalesOrderItemRequest item) {
    final currentItems = state.items ?? [];
    currentItems.remove(item);
    state = state.copyWith(items: [...currentItems]);
  }

  void reset() {
    state = SalesOrderRequest();
  }

  /// =============================
  /// SUBMIT
  /// =============================

  Future<void> submitSalesOrder() async {
    try {
      final api = ref.read(salesOrderApiProvider);

      if (state.customer == null) {
        throw Exception("Customer belum dipilih");
      }

      if (state.items == null || state.items!.isEmpty) {
        throw Exception("Item tidak boleh kosong");
      }

      await api.submitSalesOrder(state);
    } catch (e) {
      rethrow;
    }
  }
}
