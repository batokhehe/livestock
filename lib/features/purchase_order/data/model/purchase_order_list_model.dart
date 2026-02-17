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
      amountRemainder: (json['amount_remainder'] as num?)?.toDouble() ?? 0,
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
    );
  }
}
