import '../../../../core/data/model/customer_model.dart';

class SalesOrderList {
  final int id;
  final String orderId;
  final String orderDate;
  final String? dueDate;

  final int customerId;
  final Customer customer;
  final String customerName;

  final String? deliveryAddress;
  final String? recipientName;
  final String? recipientNumber;

  final int farmLocationId;
  final int? farmAreaId;

  final int subtotal;
  final int discountTotal;
  final int shippingCost;
  final int amountTotal;
  final int amountPaid;
  final int amountRemainder;

  final String salesStatus;
  final String salesType;
  final String salesItemType;

  final String? notes;
  final int totalDispatch;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  SalesOrderList({
    required this.id,
    required this.orderId,
    required this.orderDate,
    this.dueDate,
    required this.customerId,
    required this.customer,
    required this.customerName,
    this.deliveryAddress,
    this.recipientName,
    this.recipientNumber,
    required this.farmLocationId,
    this.farmAreaId,
    required this.subtotal,
    required this.discountTotal,
    required this.shippingCost,
    required this.amountTotal,
    required this.amountPaid,
    required this.amountRemainder,
    required this.salesStatus,
    required this.salesType,
    required this.salesItemType,
    this.notes,
    required this.totalDispatch,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory SalesOrderList.fromJson(Map<String, dynamic> json) {
    return SalesOrderList(
      id: json['id'],
      orderId: json['order_id'],
      orderDate: json['order_date'],
      dueDate: json['due_date'],

      customerId: json['customer_id'],
      customer: Customer.fromJson(json['customer']),
      customerName: json['customer_name'],

      deliveryAddress: json['delivery_address'],
      recipientName: json['recipient_name'],
      recipientNumber: json['recipient_number'],

      farmLocationId: json['farm_location_id'],
      farmAreaId: json['farm_area_id'],

      subtotal: json['subtotal'],
      discountTotal: json['discount_total'],
      shippingCost: json['shipping_cost'],
      amountTotal: json['amount_total'],
      amountPaid: json['amount_paid'],
      amountRemainder: json['amount_remainder'],

      salesStatus: json['sales_status'],
      salesType: json['sales_type'],
      salesItemType: json['sales_item_type'],

      notes: json['notes'],
      totalDispatch: json['total_dispatch'],

      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  /// Helper biar enak di UI
  bool get isClosed => salesStatus == 'closed';

  bool get isCanceled => salesStatus == 'canceled';
}
