class ReceivingItem {
  final int id;
  final int supplierId;
  final String supplierName;
  final int purchOrderId;
  final int purchOrderDetailId;
  final String purchOrderNo;

  final String item;
  final String itemName;
  String itemCode;
  final String poel;

  final String? initialWeight;
  final int? ageCategory;
  final bool? isVaccinated;
  final String? vaccineDate;
  final String? gender;

  final String? qty;
  final String? unitPrice;
  final int amountRemainder;
  final String subtotal;
  int? animalGroupId;
  final String codeRef;

  bool selected;
  double? receivedWeight;
  String? notes;
  String? feedType;
  String? type;

  ReceivingItem({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.purchOrderId,
    required this.purchOrderDetailId,
    required this.purchOrderNo,
    required this.item,
    required this.itemName,
    required this.itemCode,
    required this.poel,
    this.initialWeight,
    this.ageCategory,
    this.isVaccinated,
    this.vaccineDate,
    this.gender,
    this.qty,
    this.feedType,
    this.type,
    required this.unitPrice,
    required this.amountRemainder,
    required this.subtotal,
    this.animalGroupId,
    required this.codeRef,

    required this.selected,
    this.receivedWeight,
    this.notes,
  });

  factory ReceivingItem.fromJson(Map<String, dynamic> json) {
    return ReceivingItem(
      id: json['id'],
      supplierId: json['supplier_id'],
      supplierName: json['supplier_name'],
      purchOrderId: json['purch_order_id'],
      purchOrderDetailId: json['purch_order_detail_id'],
      purchOrderNo: json['purch_order_no'],
      item: json['item'],
      itemName: json['item_name'],
      itemCode: json['item_code'],
      poel: json['poel'] ?? '',
      initialWeight: json['initial_weight'] ?? '0',
      ageCategory: json['age_category'] ?? 0,
      isVaccinated: json['is_vaccinated'] ?? false,
      vaccineDate: json['vaccine_date'] ?? '',
      gender: json['gender'] ?? '0',
      qty: json['qty'] ?? json['quantity'],
      unitPrice: json['unit_price'],
      amountRemainder: json['amount_remainder'],
      subtotal: json['subtotal'],
      selected: false,
      animalGroupId: json['animal_group_id'] ?? 0,
      codeRef: json['code_ref'] ?? '',
      feedType: json['feed_type'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toAnimalJson() {
    return {
      "purch_order_detail_id": purchOrderDetailId,
      "item_code": itemCode,
      "item_name": itemName,
      "qty": qty,
      "weight": receivedWeight,
      "animal_group_id": animalGroupId,
      "age_category": ageCategory,
      "code_ref": codeRef,
      "notes": notes,
    };
  }

  Map<String, dynamic> toItemJson() {
    return {
      "purch_order_detail_id": purchOrderDetailId,
      "item_code": itemCode,
      "qty": double.tryParse(qty ?? '0') ?? 0,
      "unit_price": int.tryParse(unitPrice ?? '0') ?? 0,
      "feed_type": feedType,
      "type": type,
      "notes": notes,
    };
  }
}
