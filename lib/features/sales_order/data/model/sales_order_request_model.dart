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
  final String? isForecast;
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
    this.isForecast,
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
    String? isForecast,
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
      isForecast: isForecast ?? this.isForecast,
      notes: notes ?? this.notes,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customer_id": customer?.id,
      if (orderDate != null) "order_date": formatterJson.format(orderDate!),
      if (dueDate != null) "due_date": formatterJson.format(dueDate!),
      if (forecastDate != null) "forecast_date": formatterJson.format(forecastDate!),
      "sales_item_type": salesItemType ?? "animal",
      "status": status ?? "draft",
      "sales_type": salesType ?? "basic",
      "farm_location_id": farmLocation?.id ?? 0,
      "farm_area_id": farmArea?.id ?? 0,
      "delivery_address": deliveryAddress ?? '-',
      "recipient_name": recipientName,
      "recipient_number": recipientNumber,
      "shipping_cost": shippingCost ?? 0,
      "discount_total": discountTotal ?? 0,
      "notes": notes,
      "is_forecast": isForecast ?? ((useForecast ?? true) ? "yes" : "no"),
      "items": items?.map((e) => e.toJson()).toList() ?? [],
    };
  }

  SalesOrderRequest clearForecastDate() {
    return SalesOrderRequest(
      customer: customer,
      category: category,
      forecastDate: null,
      useForecast: useForecast,
      orderDate: orderDate,
      dueDate: dueDate,
      salesItemType: salesItemType,
      status: status,
      salesType: salesType,
      farmLocation: farmLocation,
      farmArea: farmArea,
      deliveryAddress: deliveryAddress,
      recipientName: recipientName,
      recipientNumber: recipientNumber,
      shippingCost: shippingCost,
      discountTotal: discountTotal,
      notes: notes,
      items: items,
    );
  }

  bool get isValid {
    bool animalValid = true;
    if (salesItemType == 'animal') {
      bool isForecastSelected = useForecast ?? true;
      animalValid = dueDate != null &&
          (!isForecastSelected || forecastDate != null) &&
          (recipientName != null && recipientName!.isNotEmpty) &&
          (recipientNumber != null && recipientNumber!.isNotEmpty);
    }
    return customer != null &&
        orderDate != null &&
        farmLocation != null &&
        animalValid;
  }
}
