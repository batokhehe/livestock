import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/animal_group_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/supplier_model.dart';

import '../../core/network/dio_client.dart';
import 'data/api/purchase_order_api.dart';
import 'data/model/purchase_order_item_request_model.dart';
import 'data/model/purchase_order_list_model.dart';
import 'data/model/purchase_order_request_model.dart';

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

final purchaseOrderSearchProvider = StateProvider<String>((ref) => '');

final purchaseOrderTabProvider = StateProvider<PurchaseOrderTab>((ref) {
  return PurchaseOrderTab.animal;
});

final purchaseOrderApiProvider = Provider((ref) {
  return PurchaseOrderApi(ref.read(dioProvider));
});

final purchaseOrderListProvider =
    FutureProvider.autoDispose<List<PurchaseOrderList>>((ref) async {
      final api = ref.read(purchaseOrderApiProvider);
      final tab = ref.watch(purchaseOrderTabProvider);

      return api.getPurchaseOrder(type: tab.apiValue);
    });

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
}

extension PurchaseOrderValidation on PurchaseOrderRequest {
  bool get isValid {
    final isBasicFilled =
        purchDate != null &&
        animalGroup != null &&
        supplier != null &&
        supplierAddress != null &&
        supplierAddress!.trim().isNotEmpty;

    if (purchaseItemType == 'animal') {
      return isBasicFilled && farmLocation != null;
    }

    return isBasicFilled;
  }
}

final purchaseOrderDetailProvider =
    FutureProvider.family<PurchaseOrderList, int>((ref, id) async {
      final api = ref.read(purchaseOrderApiProvider);
      final res = await api.getPurchaseOrderDetail(id);
      return res.data;
    });
