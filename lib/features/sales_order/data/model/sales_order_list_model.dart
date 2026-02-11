import 'package:livestock/features/sales_order/data/model/sales_order_item_model.dart';

import '../../../../core/data/model/customer_model.dart';

class SalesOrderList {
  final int id;
  final String orderId;
  final String orderDate;
  final String? dueDate;

  final int customerId;
  final Customer customer;
  final String customerName;

  final int subtotal;
  final int amountTotal;
  final int amountPaid;
  final int amountRemainder;

  final String salesStatus;
  final String salesType;
  final String salesItemType;

  final int totalDispatch;

  final List<SalesOrderItem> items;

  final DateTime createdAt;
  final DateTime updatedAt;

  SalesOrderList({
    required this.id,
    required this.orderId,
    required this.orderDate,
    this.dueDate,
    required this.customerId,
    required this.customer,
    required this.customerName,
    required this.subtotal,
    required this.amountTotal,
    required this.amountPaid,
    required this.amountRemainder,
    required this.salesStatus,
    required this.salesType,
    required this.salesItemType,
    required this.totalDispatch,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
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
      subtotal: json['subtotal'],
      amountTotal: json['amount_total'],
      amountPaid: json['amount_paid'],
      amountRemainder: json['amount_remainder'],
      salesStatus: json['sales_status'],
      salesType: json['sales_type'],
      salesItemType: json['sales_item_type'],
      totalDispatch: json['total_dispatch'],
      items: (json['items'] as List)
          .map((e) => SalesOrderItem.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// helper UI
  bool get isClosed => salesStatus == 'closed';

  bool get isCanceled => salesStatus == 'canceled';
}
