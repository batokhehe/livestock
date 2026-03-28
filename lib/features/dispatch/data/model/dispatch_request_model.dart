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
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "dispatch_date": dispatchDate,
      "vehicle_number": vehicleNumber,
      "driver_name": driverName,
      "farm_location_id": farmLocationId,
      "shipping_cost_total": shippingCostTotal, // ambil total items
      "additional_cost": additionalCost,
      "down_payment": downPayment,
      "dispatch_status": "ready", // ready , in_transit , delivered
      "remarks": "test created",
      "items": items?.map((e) => e.toJson()).toList(),
    };
  }

  int get totalShipping {
    return items?.fold(0, (sum, e) => sum! + e.shippingCost) ?? 0;
  }

  int get remainingPayment {
    final shipping = totalShipping;
    final dp = downPayment ?? 0;
    final additional = additionalCost ?? 0;

    return shipping + additional - dp;
  }
}
