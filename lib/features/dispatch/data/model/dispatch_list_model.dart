import 'dispatch_lines_model.dart';

class DispatchList {
  final int id;
  final String dispatchDate;
  final String stockCode;
  final String? deliveryAddress;
  final String vehicleNumber;
  final String driverName;
  final String farmName;
  final int? farmLocationId;
  final String dispatchStatus;
  final String createdBy;
  final String farmLocationName;
  final String customerName;
  final String totalQuantity;
  final String shippingCost;
  final String shippingCostTotal;
  final String downPayment;
  final String additionalCost;
  final List<DispatchLine> items;

  DispatchList({
    required this.id,
    required this.dispatchDate,
    required this.stockCode,
    this.deliveryAddress,
    required this.vehicleNumber,
    required this.driverName,
    required this.farmName,
    this.farmLocationId,
    required this.dispatchStatus,
    required this.createdBy,
    required this.farmLocationName,
    required this.customerName,
    required this.totalQuantity,
    required this.shippingCost,
    required this.shippingCostTotal,
    required this.items,
    required this.downPayment,
    required this.additionalCost,
  });

  factory DispatchList.fromJson(Map<String, dynamic> json) {
    return DispatchList(
      id: json['id'],
      dispatchDate: json['dispatch_date'] ?? '',
      stockCode: json['stock_code'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      driverName: json['driver_name'] ?? '',
      farmName: json['farm_name'] ?? '',
      farmLocationId: json['farm_location_id'] ?? 0,
      dispatchStatus: json['dispatch_status'] ?? '',
      createdBy: json['created_by'] ?? '',
      farmLocationName: json['farm_location_name'] ?? '',
      customerName: json['customer_name'] ?? '',
      totalQuantity: json['total_quantity'] ?? '',
      shippingCost: json['shipping_cost'] ?? '',
      shippingCostTotal: json['shipping_cost_total'] ?? '',
      downPayment: json['down_payment'] ?? '',
      additionalCost: json['additional_cost'] ?? '',
      items: ((json['items'] ?? json['dispatch_lines']) as List? ?? [])
          .map((e) => DispatchLine.fromJson(e))
          .toList(),
    );
  }
}
