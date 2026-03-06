import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/dispatch/data/model/sales_order_dispatch_model.dart';

import '../../core/network/dio_client.dart';
import 'data/api/dispatch_api.dart';
import 'data/model/dispatch_item_request_model.dart';
import 'data/model/dispatch_list_model.dart';
import 'data/model/dispatch_request_model.dart';
import 'data/repository/dispatch_repository.dart';

enum DispatchTab { all, sell, confirmed, closed }

extension DispatchTabX on DispatchTab {
  String get apiValue {
    switch (this) {
      case DispatchTab.all:
        return 'all';
      case DispatchTab.sell:
        return 'sell';
      case DispatchTab.confirmed:
        return 'confirmed';
      case DispatchTab.closed:
        return 'closed';
    }
  }

  String get label {
    switch (this) {
      case DispatchTab.all:
        return 'Semua';
      case DispatchTab.sell:
        return 'Terjual';
      case DispatchTab.confirmed:
        return 'Dikonfirmasi';
      case DispatchTab.closed:
        return 'Tutup';
    }
  }

  // String get ext {
  //   switch (this) {
  //     case dispatchTab.animal:
  //       return 'hewan';
  //     case dispatchTab.feed:
  //       return 'item';
  //     case dispatchTab.equipment:
  //       return 'item';
  //   }
  // }
}

final dispatchSearchProvider = StateProvider<String>((ref) => '');

final dispatchTabProvider = StateProvider<DispatchTab>((ref) {
  return DispatchTab.all;
});

final dispatchApiProvider = Provider((ref) {
  return DispatchApi(ref.read(dioProvider));
});

final dispatchListProvider = FutureProvider.autoDispose<List<DispatchList>>((
  ref,
) async {
  final api = ref.read(dispatchApiProvider);
  final tab = ref.watch(dispatchTabProvider);

  return api.getDispatch(status: tab.apiValue);
});

final dispatchFormProvider =
    StateNotifierProvider<DispatchFormNotifier, DispatchRequest>(
      (ref) => DispatchFormNotifier(ref),
    );

class DispatchFormNotifier extends StateNotifier<DispatchRequest> {
  final Ref ref;

  DispatchFormNotifier(this.ref) : super(DispatchRequest());

  /// =============================
  /// SETTERS
  /// =============================

  void setDispatchDate(DateTime value) {
    state = state.copyWith(dispatchDate: value);
  }

  void setDriver(String value) {
    state = state.copyWith(driverName: value);
  }

  void setVehicle(String value) {
    state = state.copyWith(vehicleNumber: value);
  }

  void setDownPayment(int value) {
    state = state.copyWith(downPayment: value);
  }

  void setAdditionalCost(int value) {
    state = state.copyWith(additionalCost: value);
  }

  void setTotalShippingCost(int value) {
    state = state.copyWith(shippingCostTotal: value);
  }

  void setItems(List<DispatchItemRequest> items) {
    state = state.copyWith(items: items);
  }

  void addItem(DispatchItemRequest item) {
    final currentItems = state.items ?? [];
    final updated = [...currentItems, item];

    final totalShipping =
    updated.fold<int>(0, (sum, e) => sum + e.shippingCost);

    state = state.copyWith(
      items: updated,
      shippingCostTotal: totalShipping,
    );
  }

  void removeItem(DispatchItemRequest item) {
    final currentItems = state.items ?? [];
    final updated = [...currentItems]..remove(item);

    final totalShipping =
    updated.fold<int>(0, (sum, e) => sum + e.shippingCost);

    state = state.copyWith(
      items: updated,
      shippingCostTotal: totalShipping,
    );
  }

  void reset() {
    state = DispatchRequest();
  }

  /// =============================
  /// SUBMIT
  /// =============================

  Future<void> submitDispatch() async {
    final api = ref.read(dispatchApiProvider);

    if (state.items == null || state.items!.isEmpty) {
      throw Exception("Item tidak boleh kosong");
    }

    await api.submitDispatch(state);
  }
}

final dispatchRepositoryProvider = Provider<DispatchRepository>((ref) {
  final api = ref.read(dispatchApiProvider);
  return DispatchRepository(api);
});

// SO Dispatch
final selectedSoProvider = StateProvider<SalesOrderDispatch?>((ref) => null);
final soSearchProvider = StateProvider.autoDispose<String>((ref) => '');
