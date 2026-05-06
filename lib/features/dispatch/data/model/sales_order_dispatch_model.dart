import 'dispatch_item_request_model.dart';
import 'sales_order_dispatch_item_model.dart';

class SalesOrderDispatch {
  final int id;
  final String orderId;
  final int customerId;
  final String customerName;
  final String orderDate;

  final String deliveryAddress;

  final String state;
  final String stateId;

  final String city;
  final String cityId;

  final String district;
  final String districtId;

  final String village;
  final String villageId;

  final String recipientName;
  final String recipientNumber;

  final String farmAreaName;
  final int? farmAreaId;

  final int farmLocationId;
  final String farmLocationName;

  final double shippingCost;
  final double amountTotal;
  final int amountInvoiced;
  final double amountPaid;
  final double amountRemainder;

  final List<SalesOrderDispatchItem> items;

  SalesOrderDispatch({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.orderDate,
    required this.deliveryAddress,
    required this.state,
    required this.stateId,
    required this.city,
    required this.cityId,
    required this.district,
    required this.districtId,
    required this.village,
    required this.villageId,
    required this.recipientName,
    required this.recipientNumber,
    required this.farmAreaName,
    this.farmAreaId,
    required this.farmLocationId,
    required this.farmLocationName,
    required this.shippingCost,
    required this.amountTotal,
    required this.amountInvoiced,
    required this.amountPaid,
    required this.amountRemainder,
    required this.items,
  });

  factory SalesOrderDispatch.fromJson(Map<String, dynamic> json) {
    return SalesOrderDispatch(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? '',
      customerId: json['customer_id'] ?? 0,
      customerName: json['customer_name'] ?? '',
      orderDate: json['order_date'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      state: json['state'] ?? '',
      stateId: json['state_id'] ?? '',
      city: json['city'] ?? '',
      cityId: json['city_id'] ?? '',
      district: json['district'] ?? '',
      districtId: json['district_id'] ?? '',
      village: json['village'] ?? '',
      villageId: json['village_id'] ?? '',
      recipientName: json['recipient_name'] ?? '',
      recipientNumber: json['recipient_number'] ?? '',
      farmAreaName: json['farm_area_name'] ?? '',
      farmAreaId: json['farm_area_id'],
      farmLocationId: json['farm_location_id'] ?? 0,
      farmLocationName: json['farm_location_name'] ?? '',
      shippingCost: double.tryParse(json['shipping_cost'].toString()) ?? 0,
      amountTotal: double.tryParse(json['amount_total'].toString()) ?? 0,
      amountInvoiced: json['amount_invoiced'] ?? 0,
      amountPaid: double.tryParse(json['amount_paid'].toString()) ?? 0,
      amountRemainder:
          double.tryParse(json['amount_remainder'].toString()) ?? 0,
      items: (json['items'] as List? ?? [])
          .map((e) => SalesOrderDispatchItem.fromJson(e))
          .toList(),
    );
  }
}

extension SalesOrderDispatchItemMapper on SalesOrderDispatchItem {
  DispatchItemRequest toDispatchRequest({
    required String recipientName,
    required String recipientNumber,
    required String orderId,
    required int orderRemainder,
    required int orderPaid,
    required int orderTotal,
  }) {
    return DispatchItemRequest(
      animalProfileId: animalProfileId,
      animalProfileCode: animalProfileIdCode,
      animalProfileName: animalProfileName,
      qty: qty,
      dlvDate: dlvDate,
      deliveryAddress: deliveryAddress,
      state: state,
      stateId: stateId,
      city: city,
      cityId: cityId,
      district: district,
      districtId: districtId,
      village: village,
      villageId: villageId,
      recipientName: recipientName,
      recipientNumber: recipientNumber,
      shippingCost: shippingCost,
      orderId: orderId,
      downPayment: 0,
      additionalCost: 0,
      totalShippingCost: 0,
      salesOrderId: salesOrderId,
      salesOrderDetailId: salesOrderDetailId,
      amountRemainder: orderRemainder,
      amountPaid: orderPaid,
      amountTotal: orderTotal,
    );
  }
}
