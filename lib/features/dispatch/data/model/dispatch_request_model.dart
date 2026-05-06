import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/features/dispatch/data/model/dispatch_item_request_model.dart';

class DispatchRequest {
  final DateTime? dispatchDate;
  final String? vehicleNumber;
  final String? driverName;
  final int? farmLocationId;
  final int? downPayment;
  final int? additionalCost;
  final int? shippingCostTotal;
  final String? dispatchStatus;
  final FarmLocation? farmLocation;
  final List<DispatchItemRequest>? items;

  DispatchRequest({
    this.dispatchDate,
    this.vehicleNumber,
    this.driverName,
    this.farmLocationId,
    this.farmLocation,
    this.downPayment,
    this.additionalCost,
    this.shippingCostTotal,
    this.dispatchStatus,
    this.items,
  });

  DispatchRequest copyWith({
    DateTime? dispatchDate,
    String? vehicleNumber,
    String? driverName,
    int? farmLocationId,
    FarmLocation? farmLocation,
    int? downPayment,
    int? additionalCost,
    int? shippingCostTotal,
    String? dispatchStatus,
    List<DispatchItemRequest>? items,
  }) {
    return DispatchRequest(
      dispatchDate: dispatchDate ?? this.dispatchDate,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      driverName: driverName ?? this.driverName,
      farmLocationId: farmLocationId ?? this.farmLocationId,
      farmLocation: farmLocation ?? this.farmLocation,
      downPayment: downPayment ?? this.downPayment,
      additionalCost: additionalCost ?? this.additionalCost,
      shippingCostTotal: shippingCostTotal ?? this.shippingCostTotal,
      dispatchStatus: dispatchStatus ?? this.dispatchStatus,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "dispatch_date": dispatchDate?.toIso8601String(),
      "vehicle_number": vehicleNumber,
      "driver_name": driverName,
      "farm_location_id": farmLocationId,
      "shipping_cost_total": shippingCostTotal,
      // ambil total items
      "additional_cost": additionalCost,
      "down_payment": downPayment,
      "dispatch_status": dispatchStatus ?? "ready",
      // ready , in_transit , delivered
      "remarks": "test created",
      "items": items?.map((e) => e.toJson()).toList(),
    };
  }

  int get totalShipping {
    if (items == null || items!.isEmpty) return 0;

    final uniqueOrders = <String, int>{};
    for (var item in items!) {
      uniqueOrders[item.orderId] = item.shippingCost;
    }

    return uniqueOrders.values.fold(0, (sum, val) => sum + val);
  }

  int get totalItemRemainder {
    if (items == null || items!.isEmpty) return 0;

    final uniqueOrders = <String, int>{};
    for (var item in items!) {
      uniqueOrders[item.orderId] = item.amountRemainder;
    }

    return uniqueOrders.values.fold(0, (sum, val) => sum + val);
  }

  int get remainingPayment {
    final itemRemainder = totalItemRemainder;
    final shipping = totalShipping;
    final dp = downPayment ?? 0;
    final additional = additionalCost ?? 0;

    return itemRemainder + shipping + additional - dp;
  }
}
