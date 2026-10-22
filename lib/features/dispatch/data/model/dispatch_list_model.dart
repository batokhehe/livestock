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
  final String amountRemaining;
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
    this.amountRemaining = '',
  });

  int get computedTotalQuantity {
    if (items.isNotEmpty) {
      final sum = items.fold<double>(
        0,
        (prev, el) => prev + (double.tryParse(el.quantity) ?? 0),
      );
      if (sum > 0) return sum.toInt();
    }
    return (double.tryParse(totalQuantity) ?? 0).toInt();
  }

  double get remainingPayment {
    final parsed = double.tryParse(amountRemaining);
    if (parsed != null && amountRemaining.isNotEmpty) {
      return parsed;
    }
    final shipping = double.tryParse(shippingCostTotal) ?? 0;
    final additional = double.tryParse(additionalCost) ?? 0;
    final dp = double.tryParse(downPayment) ?? 0;
    return shipping + additional - dp;
  }

  factory DispatchList.fromJson(Map<String, dynamic> json) {
    return DispatchList(
      id: json['id'] ?? 0,
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
      totalQuantity: json['total_quantity']?.toString() ?? '',
      shippingCost: json['shipping_cost']?.toString() ?? '',
      shippingCostTotal: json['shipping_cost_total']?.toString() ?? '',
      downPayment: json['down_payment']?.toString() ?? '',
      additionalCost: json['additional_cost']?.toString() ?? '',
      amountRemaining: (json['amount_remaining'] ??
              json['amount_remainder'] ??
              json['remaining_amount'])
          ?.toString() ??
          '',
      items: ((json['items'] ?? json['dispatch_lines']) as List? ?? [])
          .map((e) => DispatchLine.fromJson(e))
          .toList(),
    );
  }
}
