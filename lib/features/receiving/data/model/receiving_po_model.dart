import 'receiving_item_model.dart';

class ReceivingPo {
  final int id;
  final int supplierId;
  final String supplierName;
  final String purchOrderNo;
  final String purchDate;
  final String? farmLocationName;
  final String? farmLocationNameTo;
  final int? animalGroupId;
  final int? farmLocationId;
  final String amountTotal;
  final String amountPaid;
  final String amountRemainder;
  final String? feedType;
  final String? unitPrice;
  final List<ReceivingItem> items;

  ReceivingPo({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.purchOrderNo,
    required this.purchDate,
    this.farmLocationName,
    this.farmLocationNameTo,
    this.farmLocationId,
    this.animalGroupId,
    this.feedType,
    this.unitPrice,
    required this.amountTotal,
    required this.amountPaid,
    required this.amountRemainder,
    required this.items,
  });

  factory ReceivingPo.fromJson(Map<String, dynamic> json) {
    return ReceivingPo(
      id: json['id'],
      supplierId: json['supplier_id'],
      supplierName: json['supplier_name'],
      purchOrderNo: json['purch_order_no'],
      purchDate: json['purch_date'],
      farmLocationName: json['farm_location_name'] ?? '-',
      farmLocationNameTo: json['farm_location_name_to'] ?? '-',
      farmLocationId: json['farm_location_id'] ?? 0,
      animalGroupId: json['animal_group_id'] ?? 0,
      amountTotal: json['amount_total'],
      amountPaid: json['amount_paid'],
      amountRemainder: json['amount_remainder'],
      feedType: json['feed_type'],
      unitPrice: json['unit_price'],
      items: (json['items'] as List? ?? [])
          .map((e) => ReceivingItem.fromJson(e))
          .toList(),
    );
  }
}
