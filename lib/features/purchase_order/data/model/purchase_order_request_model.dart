import 'package:livestock/core/data/model/animal_group_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/supplier_model.dart';

import 'purchase_order_item_request_model.dart';

class PurchaseOrderRequest {
  final DateTime? purchDate;
  final String? purchaseItemType;

  /// Animal Only
  final AnimalGroup? animalGroup;

  /// Common
  final Supplier? supplier;
  final String? supplierAddress;

  /// Animal Only
  final FarmLocation? farmLocation;
  final String? state;
  final String? city;
  final String? stateId;
  final String? cityId;

  /// Feed Only
  final String? feedType;

  /// Equipment Only
  final String? type;

  final double? shippingCost;
  final double? additionalCost;
  final String? notes;

  final List<PurchaseOrderItemRequest>? items;

  PurchaseOrderRequest({
    this.purchDate,
    this.purchaseItemType,
    this.animalGroup,
    this.supplier,
    this.supplierAddress,
    this.farmLocation,
    this.state,
    this.city,
    this.stateId,
    this.cityId,
    this.feedType,
    this.type,
    this.shippingCost,
    this.additionalCost,
    this.notes,
    this.items,
  });

  Map<String, dynamic> toJson() {
    final base = {
      "purch_date": purchDate?.toIso8601String().split('T').first,
      "supplier_id": supplier?.id ?? 0,
      "supplier_name": supplier?.name ?? '',
      "supplier_address": supplierAddress ?? '',
      "notes": notes,
      "items": items?.map((e) => e.toJson()).toList(),
    };

    if (purchaseItemType == 'animal') {
      return {
        ...base,
        "animal_group_id": animalGroup?.id ?? 0,
        "farm_location_id": farmLocation?.id ?? 0,
        "state": state,
        "city": city,
        "state_id": stateId,
        "city_id": cityId,
        "shipping_cost": shippingCost ?? 0,
        "additional_cost": additionalCost ?? 0,
      }..removeWhere((key, value) => value == null);
    }

    if (purchaseItemType == 'feed') {
      return {
        ...base,
        "feed_type": "feed",
      }..removeWhere((key, value) => value == null);
    }

    if (purchaseItemType == 'equipment') {
      return {
        ...base,
        "type": "equipment",
      }..removeWhere((key, value) => value == null);
    }

    return base..removeWhere((key, value) => value == null);
  }

  PurchaseOrderRequest copyWith({
    DateTime? purchDate,
    String? purchaseItemType,
    AnimalGroup? animalGroup,
    Supplier? supplier,
    String? supplierAddress,
    FarmLocation? farmLocation,
    String? state,
    String? city,
    String? stateId,
    String? cityId,
    String? feedType,
    String? type,
    double? shippingCost,
    double? additionalCost,
    String? notes,
    List<PurchaseOrderItemRequest>? items,
  }) {
    return PurchaseOrderRequest(
      purchDate: purchDate ?? this.purchDate,
      purchaseItemType: purchaseItemType ?? this.purchaseItemType,
      animalGroup: animalGroup ?? this.animalGroup,
      supplier: supplier ?? this.supplier,
      supplierAddress: supplierAddress ?? this.supplierAddress,
      farmLocation: farmLocation ?? this.farmLocation,
      state: state ?? this.state,
      city: city ?? this.city,
      stateId: stateId ?? this.stateId,
      cityId: cityId ?? this.cityId,
      feedType: feedType ?? this.feedType,
      type: type ?? this.type,
      shippingCost: shippingCost ?? this.shippingCost,
      additionalCost: additionalCost ?? this.additionalCost,
      notes: notes ?? this.notes,
      items: items ?? this.items,
    );
  }
}
