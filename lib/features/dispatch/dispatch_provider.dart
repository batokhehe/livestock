import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/features/dispatch/data/model/dispatch_list_model.dart';
import 'package:livestock/features/dispatch/data/model/sales_order_dispatch_model.dart';

import '../../core/network/dio_client.dart';
import 'data/api/dispatch_api.dart';
import 'data/model/dispatch_item_request_model.dart';
import 'data/model/dispatch_lines_model.dart';
import 'data/model/dispatch_request_model.dart';
import 'data/repository/dispatch_repository.dart';

enum DispatchTab { all, ready, inTransit, delivered }

extension DispatchTabX on DispatchTab {
  String get apiValue {
    switch (this) {
      case DispatchTab.all:
        return 'all';
      case DispatchTab.ready:
        return 'ready';
      case DispatchTab.inTransit:
        return 'in_transit';
      case DispatchTab.delivered:
        return 'delivered';
    }
  }

  String get label {
    switch (this) {
      case DispatchTab.all:
        return 'Semua';
      case DispatchTab.ready:
        return 'Siap Dikirim';
      case DispatchTab.inTransit:
        return 'Sedang Dikirim';
      case DispatchTab.delivered:
        return 'Selesai Dikirim';
    }
  }
}

extension DispatchTabParser on DispatchTab {
  static DispatchTab fromApi(String? value) {
    switch (value) {
      case 'ready':
        return DispatchTab.ready;
      case 'in_transit':
        return DispatchTab.inTransit;
      case 'delivered':
        return DispatchTab.delivered;
      default:
        return DispatchTab.all;
    }
  }
}

enum DispatchSOTab { all, paid, unpaid }

extension DispatchSOTabX on DispatchSOTab {
  String get apiValue {
    switch (this) {
      case DispatchSOTab.all:
        return 'all';
      case DispatchSOTab.paid:
        return 'paid';
      case DispatchSOTab.unpaid:
        return 'unpaid';
    }
  }

  String get label {
    switch (this) {
      case DispatchSOTab.all:
        return 'Semua';
      case DispatchSOTab.paid:
        return 'Lunas';
      case DispatchSOTab.unpaid:
        return 'Belum Lunas';
    }
  }
}

final dispatchSearchProvider =
    StateNotifierProvider<DispatchSearchNotifier, String>((ref) {
      return DispatchSearchNotifier();
    });

class DispatchSearchNotifier extends StateNotifier<String> {
  DispatchSearchNotifier() : super('');

  Timer? _debounce;

  void onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      state = value;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final dispatchTabProvider = StateProvider<DispatchTab>((ref) {
  return DispatchTab.all;
});

final dispatchSoTabProvider = StateProvider<DispatchSOTab>((ref) {
  return DispatchSOTab.all;
});

final dispatchApiProvider = Provider((ref) {
  return DispatchApi(ref.read(dioProvider));
});

final dispatchListProvider = FutureProvider((ref) async {
  final api = ref.read(dispatchApiProvider);
  final tab = ref.watch(dispatchTabProvider);

  final search = ref.watch(dispatchSearchProvider);

  return api.getDispatch(status: tab.apiValue, search: search);
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

  void setFarmLocation(FarmLocation value) {
    state = state.copyWith(farmLocation: value, farmLocationId: value.id);
  }

  void setItems(List<DispatchItemRequest> items) {
    state = state.copyWith(items: items);
  }

  void addItem(DispatchItemRequest item) {
    final currentItems = state.items ?? [];
    final updated = [...currentItems, item];

    final totalShipping = updated.fold<int>(
      0,
      (sum, e) => sum + e.shippingCost,
    );

    state = state.copyWith(items: updated, shippingCostTotal: totalShipping);
  }

  void removeItem(DispatchItemRequest item) {
    final currentItems = state.items ?? [];
    final updated = [...currentItems]..remove(item);

    final totalShipping = updated.fold<int>(
      0,
      (sum, e) => sum + e.shippingCost,
    );

    state = state.copyWith(items: updated, shippingCostTotal: totalShipping);
  }

  void setStatus(String status) {
    state = state.copyWith(dispatchStatus: status);
  }

  void reset() {
    state = DispatchRequest();
  }

  void setFromDetail(DispatchList detail) {
    final dp = int.tryParse(detail.downPayment) ?? 0;
    final additional = int.tryParse(detail.additionalCost) ?? 0;

    final items = detail.items.map((e) {
      return e.toRequest(downPayment: dp, additionalCost: additional);
    }).toList();

    state = state.copyWith(
      dispatchDate: DateTime.tryParse(detail.dispatchDate),
      vehicleNumber: detail.vehicleNumber,
      driverName: detail.driverName,
      downPayment: dp,
      additionalCost: additional,
      farmLocationId: detail.farmLocationId,
      dispatchStatus: detail.dispatchStatus,
      items: items,
    );
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

  Future<void> updateDispatch(int id) async {
    final api = ref.read(dispatchApiProvider);

    if (state.items == null || state.items!.isEmpty) {
      throw Exception("Item tidak boleh kosong");
    }

    await api.updateDispatch(state, id);
  }
}

final dispatchRepositoryProvider = Provider<DispatchRepository>((ref) {
  final api = ref.read(dispatchApiProvider);
  return DispatchRepository(api);
});

// SO Dispatch
final selectedSoProvider = StateProvider<SalesOrderDispatch?>((ref) => null);
final soSearchProvider = StateNotifierProvider<SoSearchNotifier, String>((ref) {
  return SoSearchNotifier();
});

class SoSearchNotifier extends StateNotifier<String> {
  SoSearchNotifier() : super('');

  Timer? _debounce;

  void onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      state = value;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final dispatchDetailProvider = FutureProvider.autoDispose
    .family<DispatchList, int>((ref, id) async {
      final api = ref.read(dispatchApiProvider);
      return api.getDispatchDetail(id);
    });
