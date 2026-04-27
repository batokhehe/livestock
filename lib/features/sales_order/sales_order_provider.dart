import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/payment_type_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/features/sales_order/data/model/calculate_forecast_model.dart';

import '../../core/data/model/customer_model.dart';
import '../../core/network/dio_client.dart';
import 'data/api/sales_order_api.dart';
import 'data/model/sales_order_detail_model.dart';
import 'data/model/sales_order_item_request_model.dart';
import 'data/model/sales_order_list_model.dart';
import 'data/model/sales_order_request_model.dart';
import 'data/model/sales_invoice_model.dart';
import 'data/repository/sales_order_repository.dart';

final salesInvoiceListProvider = FutureProvider.autoDispose
    .family<List<SalesInvoice>, int>((ref, soId) async {
      return ref.read(salesOrderApiProvider).getSalesInvoices(soId);
    });

enum SalesOrderTab { draft, confirmed, closed, canceled, all }

extension SalesOrderTabX on SalesOrderTab {
  String get apiValue {
    switch (this) {
      case SalesOrderTab.all:
        return 'all';
      case SalesOrderTab.draft:
        return 'draft';
      case SalesOrderTab.confirmed:
        return 'confirmed';
      case SalesOrderTab.closed:
        return 'closed';
      case SalesOrderTab.canceled:
        return 'canceled';
    }
  }

  String get label {
    switch (this) {
      case SalesOrderTab.all:
        return 'Semua';
      case SalesOrderTab.draft:
        return 'Draft';
      case SalesOrderTab.confirmed:
        return 'Terkonfirmasi';
      case SalesOrderTab.closed:
        return 'Selesai';
      case SalesOrderTab.canceled:
        return 'Batal';
    }
  }
}

final salesOrderListFilterProvider = StateProvider<SalesOrderTab>((ref) {
  return SalesOrderTab.all;
});

final salesOrderRepositoryProvider = Provider((ref) {
  final api = ref.read(salesOrderApiProvider);
  return SalesOrderRepository(api);
});

final salesOrderSearchProvider = StateProvider<String>((ref) => '');

final salesOrderTabProvider = StateProvider<SalesOrderTab>((ref) {
  return SalesOrderTab.all;
});

final salesOrderApiProvider = Provider((ref) {
  return SalesOrderApi(ref.read(dioProvider));
});

// PAYMENT TYPE
final paymentTypeListProvider = FutureProvider.autoDispose<List<PaymentType>>((
  ref,
) async {
  return ref.read(salesOrderApiProvider).getPaymentTypes();
});
final selectedPaymentTypeProvider = StateProvider<PaymentType?>((ref) => null);
final paymentTypeSearchProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final salesOrderListProvider = FutureProvider.autoDispose<List<SalesOrderList>>(
  (ref) async {
    final api = ref.read(salesOrderApiProvider);
    final tab = ref.watch(salesOrderTabProvider);
    final search = ref.watch(salesOrderSearchProvider);

    return api.getSalesOrder(status: tab.apiValue, search: search);
  },
);

final salesOrderFormProvider =
    StateNotifierProvider<SalesOrderFormNotifier, SalesOrderRequest>(
      (ref) => SalesOrderFormNotifier(ref),
    );

class SalesOrderFormNotifier extends StateNotifier<SalesOrderRequest> {
  final Ref ref;

  SalesOrderFormNotifier(this.ref)
    : super(SalesOrderRequest(category: 'kg', useForecast: true));

  void setSalesOrderDate(DateTime date) {
    state = state.copyWith(orderDate: date);
  }

  void setDueDate(DateTime date) {
    state = state.copyWith(dueDate: date);
  }

  void setCustomer(Customer customer) {
    state = state.copyWith(customer: customer);
  }

  void setFarmLocation(FarmLocation location) {
    if (state.farmLocation?.id != location.id) {
      state = state.copyWith(
        farmLocation: location,
        items: [],
        farmArea: null,
      );
    }
  }

  void setFarmArea(FarmArea area) {
    state = state.copyWith(farmArea: area);
  }

  void setDeliveryAddress(String address) {
    state = state.copyWith(deliveryAddress: address);
  }

  void setUseForecast(bool useForecast) {
    state = state.copyWith(
      useForecast: useForecast,
      isForecast: useForecast ? 'yes' : 'no',
    );
  }

  void setForecastDate(DateTime date) {
    state = state.copyWith(forecastDate: date);
  }

  void clearForecastDate() {
    state = state.clearForecastDate();
  }

  void setNotes(String note) {
    state = state.copyWith(notes: note);
  }

  void setRecipientName(String name) {
    state = state.copyWith(recipientName: name);
  }

  void setRecipientNumber(String number) {
    state = state.copyWith(recipientNumber: number);
  }

  void setSalesItemType(String? type) {
    state = state.copyWith(salesItemType: type);
  }

  void setCategory(String category) {
    if (state.category != category) {
      state = state.copyWith(category: category, items: []);
    }
  }

  void addItem(SalesOrderItemRequest item) {
    final items = List<SalesOrderItemRequest>.from(state.items ?? []);
    items.add(item);
    state = state.copyWith(items: items);
  }

  void removeItem(SalesOrderItemRequest item) {
    final items = List<SalesOrderItemRequest>.from(state.items ?? []);
    items.remove(item);
    state = state.copyWith(items: items);
  }

  void setItems(List<SalesOrderItemRequest> items) {
    state = state.copyWith(items: items);
  }

  void reset() {
    state = SalesOrderRequest(category: 'kg', useForecast: true);
  }

  Future<void> submitSalesOrder() async {
    final api = ref.read(salesOrderApiProvider);

    final isForecastStr = (state.useForecast ?? true) ? "yes" : "no";
    final forecastDate = (state.useForecast ?? true)
        ? state.forecastDate
        : null;

    final updatedItems = state.items?.map((item) {
      return item.copyWith(
        isForecast: isForecastStr,
        forecastDate: forecastDate,
      );
    }).toList();

    state = state.copyWith(isForecast: isForecastStr, items: updatedItems);

    if (state.customer == null) {
      throw Exception("Customer belum dipilih");
    }

    if (state.items == null || state.items!.isEmpty) {
      throw Exception("Item tidak boleh kosong");
    }

    await api.submitSalesOrder(state);
  }

  Future<CalculateForecast> calculateForecastForItem({
    required int animalGroupId,
  }) async {
    final repo = ref.read(salesOrderRepositoryProvider);

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

final salesOrderDetailProvider = FutureProvider.family
    .autoDispose<SalesOrderDetail, int>((ref, id) async {
      final api = ref.read(salesOrderApiProvider);
      return api.getSalesOrderDetail(id);
    });

final editSalesOrderFormProvider =
    StateNotifierProvider<EditSalesOrderFormNotifier, SalesOrderRequest>(
      (ref) => EditSalesOrderFormNotifier(ref),
    );

class EditSalesOrderFormNotifier extends StateNotifier<SalesOrderRequest> {
  final Ref ref;

  EditSalesOrderFormNotifier(this.ref)
    : super(SalesOrderRequest(category: 'kg', useForecast: true));

  void initFromDetail(SalesOrderDetail detail) {
    final List<SalesOrderItemRequest> items = detail.items.map((e) {
      return SalesOrderItemRequest(
        animalProfile: e.animalProfile,
        qty: e.qty.toInt(),
        unitPrice: e.unitPrice,
        weight: e.weight,
        subtotal: e.subtotal,
        discount: e.discount,
        shippingCost: e.shippingCost,
        dlvDate: e.dlvDate != null ? DateTime.tryParse(e.dlvDate!) : null,
        stateId: e.stateId,
        state: e.state,
        cityId: e.cityId,
        city: e.city,
        districtId: e.districtId,
        district: e.district,
        villageId: e.villageId,
        village: e.village,
        deliveryAddress: e.deliveryAddress,
        forecastWeight: e.forecastWeight,
        forecastDate: e.forecastDate != null
            ? DateTime.tryParse(e.forecastDate!)
            : null,
        isForecast: e.isForecast,
      );
    }).toList();

    state = SalesOrderRequest(
      customer: detail.customer,
      farmLocation: FarmLocation(
        id: detail.farmLocationId ?? 0,
        name: detail.farmLocationName,
      ),
      farmArea: FarmArea(id: detail.farmAreaId ?? 0, name: detail.farmAreaName),
      deliveryAddress: detail.deliveryAddress,
      useForecast: detail.isForecast == 'yes',
      isForecast: detail.isForecast,
      forecastDate: detail.forecastDate != null
          ? DateTime.tryParse(detail.forecastDate!)
          : null,
      notes: detail.notes,
      items: items,
      recipientName: detail.recipientName,
      recipientNumber: detail.recipientNumber,
      orderDate: DateTime.tryParse(detail.orderDate),
      dueDate: detail.dueDate != null
          ? DateTime.tryParse(detail.dueDate!)
          : null,
      salesItemType: detail.salesItemType,
      salesType: detail.salesType,
      status: detail.salesStatus,
    );
  }

  void setCategory(String category) {
    if (state.category != category) {
      state = state.copyWith(category: category, items: []);
    }
  }

  void addItem(SalesOrderItemRequest item) {
    final items = List<SalesOrderItemRequest>.from(state.items ?? []);
    items.add(item);
    state = state.copyWith(items: items);
  }

  void removeItem(SalesOrderItemRequest item) {
    final items = List<SalesOrderItemRequest>.from(state.items ?? []);
    items.remove(item);
    state = state.copyWith(items: items);
  }

  void setItems(List<SalesOrderItemRequest> items) {
    state = state.copyWith(items: items);
  }

  void setSalesOrderDate(DateTime date) {
    state = state.copyWith(orderDate: date);
  }

  void setDueDate(DateTime date) {
    state = state.copyWith(dueDate: date);
  }

  void setCustomer(Customer customer) {
    state = state.copyWith(customer: customer);
  }

  void setFarmLocation(FarmLocation location) {
    if (state.farmLocation?.id != location.id) {
      state = state.copyWith(
        farmLocation: location,
        items: [],
        farmArea: null,
      );
    }
  }

  void setFarmArea(FarmArea area) {
    state = state.copyWith(farmArea: area);
  }

  void setDeliveryAddress(String address) {
    state = state.copyWith(deliveryAddress: address);
  }

  void setUseForecast(bool useForecast) {
    state = state.copyWith(
      useForecast: useForecast,
      isForecast: useForecast ? 'yes' : 'no',
    );
  }

  void setForecastDate(DateTime date) {
    state = state.copyWith(forecastDate: date);
  }

  void clearForecastDate() {
    state = state.clearForecastDate();
  }

  void setNotes(String note) {
    state = state.copyWith(notes: note);
  }

  void setRecipientName(String name) {
    state = state.copyWith(recipientName: name);
  }

  void setRecipientNumber(String number) {
    state = state.copyWith(recipientNumber: number);
  }

  void reset() {
    state = SalesOrderRequest(category: 'kg', useForecast: true);
  }

  Future<void> updateSalesOrder(int id) async {
    final api = ref.read(salesOrderApiProvider);

    final isForecastStr = (state.useForecast ?? true) ? "yes" : "no";
    final forecastDate = (state.useForecast ?? true)
        ? state.forecastDate
        : null;

    final updatedItems = state.items?.map((item) {
      return item.copyWith(
        isForecast: isForecastStr,
        forecastDate: forecastDate,
      );
    }).toList();

    state = state.copyWith(isForecast: isForecastStr, items: updatedItems);

    if (state.customer == null) {
      throw Exception("Customer belum dipilih");
    }

    if (state.items == null || state.items!.isEmpty) {
      throw Exception("Item tidak boleh kosong");
    }

    await api.updateSalesOrder(id, state);
  }

  Future<CalculateForecast> calculateForecastForItem({
    required int animalGroupId,
  }) async {
    final repo = ref.read(salesOrderRepositoryProvider);

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
