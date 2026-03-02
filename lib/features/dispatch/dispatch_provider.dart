import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';

import '../../core/data/model/customer_model.dart';
import '../../core/network/dio_client.dart';
import 'data/api/dispatch_api.dart';
import 'data/model/calculate_forecast_model.dart';
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

  void setDispatchItemType(String? value) {
    state = state.copyWith(dispatchItemType: value);
  }

  void setItems(List<DispatchItemRequest> items) {
    state = state.copyWith(items: items);
  }

  void addItem(DispatchItemRequest item) {
    final currentItems = state.items ?? [];
    state = state.copyWith(items: [...currentItems, item]);
  }

  void removeItem(DispatchItemRequest item) {
    final currentItems = state.items ?? [];
    currentItems.remove(item);
    state = state.copyWith(items: [...currentItems]);
  }

  void reset() {
    state = DispatchRequest();
  }

  void setRecipientName(String value) {
    state = state.copyWith(recipientName: value);
  }

  void setRecipientNumber(String value) {
    state = state.copyWith(recipientNumber: value);
  }

  /// =============================
  /// SUBMIT
  /// =============================

  Future<void> submitDispatch() async {
    final api = ref.read(dispatchApiProvider);
    print(state.toJson());
    if (state.customer == null) {
      throw Exception("Customer belum dipilih");
    }

    if (state.items == null || state.items!.isEmpty) {
      throw Exception("Item tidak boleh kosong");
    }

    await api.submitDispatch(state);
  }

  Future<CalculateForecast> calculateForecastForItem({
    required int animalGroupId,
  }) async {
    final repo = ref.read(dispatchRepositoryProvider);

    final forecastDate = state.forecastDate;

    if (forecastDate == null) {
      throw Exception("Forecast date belum dipilih");
    }

    return await repo.calculateForecast(
      animalGroupId: animalGroupId,
      forecastDate:
          "${forecastDate.year.toString().padLeft(4, '0')}-"
          "${forecastDate.month.toString().padLeft(2, '0')}-"
          "${forecastDate.day.toString().padLeft(2, '0')}",
    );
  }
}

final dispatchRepositoryProvider = Provider<DispatchRepository>((ref) {
  final api = ref.read(dispatchApiProvider);
  return DispatchRepository(api);
});
