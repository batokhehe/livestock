import '../../../../core/data/model/animal_group_model.dart';
import '../../../../core/data/model/farm_location_model.dart';
import '../../../../core/data/model/supplier_model.dart';
import 'purchase_order_item_model.dart';

class PurchaseOrderList {
  final int id;
  final String purchOrderNo;
  final DateTime? purchDate;
  final AnimalGroup? animalGroup;
  final Supplier? supplier;
  final String? supplierName;
  final String? supplierAddress;
  final double amountTotal;
  final double amountPurchased;
  final double amountPaid;
  final double amountRemainder;
  final String purchStatus;
  final String? feedType;
  final FarmLocation? farmLocation;
  final double shippingCost;
  final double additionalCost;
  final List<PurchaseOrderDetail> details;
  final DateTime? createdAt;
  final String? paymentStatus;

  PurchaseOrderList({
    required this.id,
    required this.purchOrderNo,
    this.purchDate,
    this.animalGroup,
    this.supplier,
    this.supplierName,
    this.supplierAddress,
    required this.amountTotal,
    required this.amountPurchased,
    required this.amountPaid,
    required this.amountRemainder,
    required this.purchStatus,
    this.feedType,
    this.farmLocation,
    required this.shippingCost,
    required this.additionalCost,
    required this.details,
    this.createdAt,
    this.paymentStatus,
  });

  factory PurchaseOrderList.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderList(
      id: json['id'],
      purchOrderNo: json['purch_order_no'],
      purchDate: json['purch_date'] != null
          ? DateTime.parse(json['purch_date'])
          : null,
      animalGroup: json['animal_group'] != null
          ? AnimalGroup.fromJson(json['animal_group'])
          : null,
      supplier: json['supplier'] != null
          ? Supplier.fromJson(json['supplier'])
          : null,
      supplierName: json['supplier_name'],
      supplierAddress: json['supplier_address'],
      amountTotal: (json['amount_total'] as num?)?.toDouble() ?? 0,
      amountPurchased: (json['amount_purchased'] as num?)?.toDouble() ?? 0,
      amountPaid: (json['amount_paid'] as num?)?.toDouble() ?? 0,
      amountRemainder: (json['amount_remainder'] as num?)?.toDouble() ??
          (((json['amount_total'] as num?)?.toDouble() ?? 0) -
              ((json['amount_paid'] as num?)?.toDouble() ?? 0)),
      purchStatus: json['purch_status'] ?? '-',
      feedType: json['feed_type'],
      farmLocation: json['farm_location'] != null
          ? FarmLocation.fromJson(json['farm_location'])
          : null,
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0,
      additionalCost: (json['additional_cost'] as num?)?.toDouble() ?? 0,
      details: (json['details'] as List? ?? [])
          .map((e) => PurchaseOrderDetail.fromJson(e))
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      paymentStatus: json['payment_status'] ?? json['settlement_status'],
    );
  }

  bool get isPaid {
    if (paymentStatus != null && paymentStatus!.isNotEmpty) {
      final s = paymentStatus!.toLowerCase();
      if (s == 'paid' || s == 'settled' || s == 'lunas' || s == 'full_payment') {
        return true;
      }
      if (s == 'unpaid' ||
          s == 'not_settled' ||
          s == 'belum_lunas' ||
          s == 'partial' ||
          s == 'down_payment') {
        return false;
      }
    }
    if (amountTotal <= 0) return false;
    return amountRemainder <= 0 || amountPaid >= amountTotal;
  }

  String get paymentStatusLabel => isPaid ? 'Lunas' : 'Belum Lunas';
}
