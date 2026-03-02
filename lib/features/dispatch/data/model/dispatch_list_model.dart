import 'dispatch_lines_model.dart';

class DispatchList {
  final int id;
  final String dispatchDate;
  final String stockCode;
  final String? deliveryAddress;
  final String vehicleNumber;
  final String dispatchStatus;
  final String createdBy;
  final String farmLocationName;
  final String customerName;
  final String totalQuantity;
  final String shippingCost;
  final List<DispatchLine> dispatchLines;

  DispatchList({
    required this.id,
    required this.dispatchDate,
    required this.stockCode,
    this.deliveryAddress,
    required this.vehicleNumber,
    required this.dispatchStatus,
    required this.createdBy,
    required this.farmLocationName,
    required this.customerName,
    required this.totalQuantity,
    required this.shippingCost,
    required this.dispatchLines,
  });

  factory DispatchList.fromJson(Map<String, dynamic> json) {
    return DispatchList(
      id: json['id'],
      dispatchDate: json['dispatch_date'],
      stockCode: json['stock_code'],
      deliveryAddress: json['delivery_address'],
      vehicleNumber: json['vehicle_number'],
      dispatchStatus: json['dispatch_status'],
      createdBy: json['created_by'],
      farmLocationName: json['farm_location_name'],
      customerName: json['customer_name'],
      totalQuantity: json['total_quantity'],
      shippingCost: json['shipping_cost'],
      dispatchLines: (json['dispatch_lines'] as List)
          .map((e) => DispatchLine.fromJson(e))
          .toList(),
    );
  }
}
