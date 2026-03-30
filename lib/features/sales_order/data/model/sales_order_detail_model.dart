import '../../../../core/data/model/customer_model.dart';
import 'sales_order_item_model.dart';

class SalesOrderDetail {
  final int id;
  final String orderId;
  final String orderDate;
  final String? dueDate;
  final int customerId;
  final Customer customer;
  final String customerName;
  final String farmLocationName;
  final String? address;
  final String? phone;
  final String? email;
  final String? deliveryAddress;
  final String? city;
  final int? cityId;
  final String? state;
  final int? stateId;
  final String? district;
  final String? districtId;
  final String? village;
  final String? villageId;
  final double shippingCost;
  final int? farmLocationId;
  final int? farmAreaId;
  final String farmAreaName;
  final double subtotal;
  final double discountTotal;
  final double amountTotal;
  final double amountPaid;
  final double amountRemainder;
  final String salesStatus;
  final String salesType;
  final String salesItemType;
  final String recipientName;
  final String recipientNumber;
  final String? isForecast;
  final String? forecastDate;
  final double forecastPrice;
  final double forecastWeight;
  final String? notes;
  final bool isBooking;
  final int totalDispatch;
  final List<SalesOrderItem> items;

  SalesOrderDetail({
    required this.id,
    required this.orderId,
    required this.orderDate,
    this.dueDate,
    required this.customerId,
    required this.customer,
    required this.customerName,
    required this.farmLocationName,
    this.address,
    this.phone,
    this.email,
    this.deliveryAddress,
    this.city,
    this.cityId,
    this.state,
    this.stateId,
    this.district,
    this.districtId,
    this.village,
    this.villageId,
    required this.shippingCost,
    this.farmLocationId,
    this.farmAreaId,
    required this.farmAreaName,
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
    this.isForecast,
    this.forecastDate,
    required this.forecastPrice,
    required this.forecastWeight,
    this.notes,
    required this.isBooking,
    required this.totalDispatch,
    required this.items,
  });

  factory SalesOrderDetail.fromJson(Map<String, dynamic> json) {
    return SalesOrderDetail(
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
      customerName: json['customer_name'] ?? (json['customer'] is Map ? json['customer']['name'] : json['customer'] ?? ''),
      farmLocationName: json['farm_location_name'] ?? (json['farm_location'] is Map ? json['farm_location']['name'] : '-'),
      address: json['address'],
      phone: json['phone'] ?? (json['customer'] is Map ? json['customer']['contact_phone'] : null),
      email: json['email'] ?? (json['customer'] is Map ? json['customer']['contact_email'] : null),
      deliveryAddress: json['delivery_address'],
      city: json['city'],
      cityId: json['city_id'],
      state: json['state'],
      stateId: json['state_id'],
      district: json['district'],
      districtId: json['district_id'],
      village: json['village'],
      villageId: json['village_id'],
      shippingCost: double.tryParse(json['shipping_cost'].toString()) ?? 0,
      farmLocationId: json['farm_location_id'],
      farmAreaId: json['farm_area_id'],
      farmAreaName: json['farm_area_name'] ?? (json['farm_area'] is Map ? json['farm_area']['name'] : ''),
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0,
      discountTotal: double.tryParse(json['discount_total'].toString()) ?? 0,
      amountTotal: double.tryParse(json['amount_total'].toString()) ?? 0,
      amountPaid: double.tryParse(json['amount_paid'].toString()) ?? 0,
      amountRemainder:
          double.tryParse(json['amount_remainder'].toString()) ?? 0,
      salesStatus: json['sales_status'] ?? '',
      salesType: json['sales_type'] ?? '',
      salesItemType: json['sales_item_type'] ?? '',
      recipientName: json['recipient_name'] ?? '-',
      recipientNumber: json['recipient_number'] ?? '-',
      isForecast: json['is_forecast']?.toString(),
      forecastDate: json['forecast_date'],
      forecastPrice: double.tryParse(json['forecast_price']?.toString() ?? '0') ?? 0,
      forecastWeight: double.tryParse(json['forecast_weight']?.toString() ?? '0') ?? 0,
      notes: json['notes'],
      isBooking: json['is_booking'] ?? false,
      totalDispatch: json['total_dispatch'] ?? 0,
      items: (json['items'] as List? ?? [])
          .map((e) => SalesOrderItem.fromJson(e))
          .toList(),
    );
  }

  /// helper UI
  bool get isClosed => salesStatus == 'closed';
  bool get isCanceled => salesStatus == 'canceled';
}
