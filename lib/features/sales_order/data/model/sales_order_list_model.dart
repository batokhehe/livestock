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

  final String farmLocationName;

  final int subtotal;
  final int discountTotal;
  final int amountTotal;
  final int amountPaid;
  final int amountRemainder;

  final String salesStatus;
  final String salesType;
  final String salesItemType;

  final String recipientName;
  final String recipientNumber;

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
    required this.farmLocationName,
    required this.subtotal,
    required this.discountTotal,
    required this.amountTotal,
    required this.amountPaid,
    required this.amountRemainder,
    required this.salesStatus,
    required this.salesType,
    required this.salesItemType,
    required this.recipientName,
    required this.recipientNumber,
    required this.totalDispatch,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SalesOrderList.fromJson(Map<String, dynamic> json) {
    return SalesOrderList(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? '',
      orderDate: json['order_date'] ?? '',
      dueDate: json['due_date'],

      customerId: json['customer_id'] ?? 0,

      customer: json['customer'] is Map
          ? Customer.fromJson(json['customer'])
          : Customer(
              id: json['customer_id'] ?? 0,
              name: json['customer'] ?? '',
            ),

      customerName: json['customer_name'] ?? json['customer'] ?? '',

      farmLocationName: json['farm_location_name'] ?? '-',

      subtotal: int.parse(json['subtotal'].toString()),
      discountTotal: int.parse(json['discount_total'].toString()),
      amountTotal: int.parse(json['amount_total'].toString()),
      amountPaid: int.parse(json['amount_paid'].toString()),
      amountRemainder: int.parse(json['amount_remainder'].toString()),

      salesStatus: json['sales_status'] ?? '',
      salesType: json['sales_type'] ?? '',
      salesItemType: json['sales_item_type'] ?? '',

      recipientName: json['recipient_name'] ?? '-',
      recipientNumber: json['recipient_number'] ?? '-',

      totalDispatch: int.parse((json['total_dispatch'] ?? 0).toString()),

      items: (json['items'] as List? ?? [])
          .map((e) => SalesOrderItem.fromJson(e))
          .toList(),

      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// helper UI
  bool get isClosed => salesStatus == 'closed';

  bool get isCanceled => salesStatus == 'canceled';
}
