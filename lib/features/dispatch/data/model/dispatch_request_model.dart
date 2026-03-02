import 'package:livestock/core/data/model/customer_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/helpers/utils.dart';

import 'dispatch_item_request_model.dart';

class DispatchRequest {
  final Customer? customer;
  final String? category;
  final DateTime? forecastDate;
  final bool? useForecast;
  final DateTime? orderDate;
  final DateTime? dueDate;
  final String? dispatchItemType;
  final String? status;
  final String? dispatchType;
  final FarmLocation? farmLocation;
  final FarmArea? farmArea;
  final String? deliveryAddress;
  final String? recipientName;
  final String? recipientNumber;
  final double? shippingCost;
  final double? discountTotal;
  final String? notes;
  final List<DispatchItemRequest>? items;

  DispatchRequest({
    this.customer,
    this.category,
    this.forecastDate,
    this.useForecast,
    this.orderDate,
    this.dueDate,
    this.dispatchItemType,
    this.status,
    this.dispatchType,
    this.farmLocation,
    this.farmArea,
    this.deliveryAddress,
    this.recipientName,
    this.recipientNumber,
    this.shippingCost,
    this.discountTotal,
    this.notes,
    this.items,
  });

  DispatchRequest copyWith({
    Customer? customer,
    String? category,
    DateTime? forecastDate,
    bool? useForecast,
    DateTime? orderDate,
    DateTime? dueDate,
    String? dispatchItemType,
    String? status,
    String? dispatchType,
    FarmLocation? farmLocation,
    FarmArea? farmArea,
    String? deliveryAddress,
    String? recipientName,
    String? recipientNumber,
    double? shippingCost,
    double? discountTotal,
    String? notes,
    List<DispatchItemRequest>? items,
  }) {
    return DispatchRequest(
      customer: customer ?? this.customer,
      category: category ?? this.category,
      forecastDate: forecastDate ?? this.forecastDate,
      useForecast: useForecast ?? this.useForecast,
      orderDate: orderDate ?? this.orderDate,
      dueDate: dueDate ?? this.dueDate,
      dispatchItemType: dispatchItemType ?? this.dispatchItemType,
      status: status ?? this.status,
      dispatchType: dispatchType ?? this.dispatchType,
      farmLocation: farmLocation ?? this.farmLocation,
      farmArea: farmArea ?? this.farmArea,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      recipientName: recipientName ?? this.recipientName,
      recipientNumber: recipientNumber ?? this.recipientNumber,
      shippingCost: shippingCost ?? this.shippingCost,
      discountTotal: discountTotal ?? this.discountTotal,
      notes: notes ?? this.notes,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customer_id": customer?.id,
      if (orderDate != null) "order_date": formatterJson.format(orderDate!),
      if (dueDate != null) "due_date": formatterJson.format(dueDate!),
      "dispatch_item_type": dispatchItemType ?? "animal",
      "status": status ?? "draft",
      "dispatch_type": dispatchType ?? "basic",
      "farm_location_id": farmLocation?.id ?? 0,
      "farm_area_id": farmArea?.id ?? 0,
      "delivery_address": deliveryAddress ?? '-',
      "recipient_name": recipientName,
      "recipient_number": recipientNumber,
      "shipping_cost": shippingCost ?? 0,
      "discount_total": discountTotal ?? 0,
      "notes": notes,
      "items": items?.map((e) => e.toJson()).toList() ?? [],
    };
  }

  bool get isValid =>
      customer != null &&
      orderDate != null &&
      farmLocation != null &&
      (dispatchItemType != 'animal' || dueDate != null);
}
