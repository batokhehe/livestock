import 'package:livestock/core/data/model/customer_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_item_request_model.dart';

class SalesOrderRequest {
  final Customer? customer;
  final String? category;
  final DateTime? forecastDate;
  final bool? useForecast;
  final DateTime? orderDate;
  final DateTime? dueDate;
  final String? salesItemType;
  final String? status;
  final String? salesType;
  final FarmLocation? farmLocation;
  final FarmArea? farmArea;
  final String? deliveryAddress;
  final String? recipientName;
  final String? recipientNumber;
  final double? shippingCost;
  final double? discountTotal;
  final String? notes;
  final List<SalesOrderItemRequest>? items;

  SalesOrderRequest({
    this.customer,
    this.category,
    this.forecastDate,
    this.useForecast,
    this.orderDate,
    this.dueDate,
    this.salesItemType,
    this.status,
    this.salesType,
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

  SalesOrderRequest copyWith({
    Customer? customer,
    String? category,
    DateTime? forecastDate,
    bool? useForecast,
    DateTime? orderDate,
    DateTime? dueDate,
    String? salesItemType,
    String? status,
    String? salesType,
    FarmLocation? farmLocation,
    FarmArea? farmArea,
    String? deliveryAddress,
    String? recipientName,
    String? recipientNumber,
    double? shippingCost,
    double? discountTotal,
    String? notes,
    List<SalesOrderItemRequest>? items,
  }) {
    return SalesOrderRequest(
      customer: customer ?? this.customer,
      category: category ?? this.category,
      forecastDate: forecastDate ?? this.forecastDate,
      useForecast: useForecast ?? this.useForecast,
      orderDate: orderDate ?? this.orderDate,
      dueDate: dueDate ?? this.dueDate,
      salesItemType: salesItemType ?? this.salesItemType,
      status: status ?? this.status,
      salesType: salesType ?? this.salesType,
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
      "order_date": orderDate != null ? formatDateTime(orderDate!) : null,
      "due_date": dueDate != null ? formatDateTime(dueDate!) : null,
      "sales_item_type": salesItemType ?? "animal",
      "status": status ?? "draft",
      "sales_type": salesType ?? "basic",
      "farm_location_id": farmLocation?.id,
      "farm_area_id": farmArea?.id,
      "delivery_address": deliveryAddress,
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
      dueDate != null &&
      farmLocation != null &&
      farmArea != null;
}
