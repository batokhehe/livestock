class PurchaseOrderDetail {
  final int? id;
  final String? animalCode;
  final String? animalName;
  final String? feedMedicineCode;
  final String? feedMedicineName;
  final String? equipmentCode;
  final String? equipmentName;
  final int quantity;
  final double initialWeight;
  final double purchPrice;
  final double subtotal;
  final double total;

  PurchaseOrderDetail({
    this.id,
    this.animalCode,
    this.animalName,
    this.feedMedicineCode,
    this.feedMedicineName,
    this.equipmentCode,
    this.equipmentName,
    required this.quantity,
    required this.initialWeight,
    required this.purchPrice,
    required this.subtotal,
    required this.total,
  });

  factory PurchaseOrderDetail.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderDetail(
      id: json['id'] ?? 0,
      animalCode: json['animal_code'],
      animalName: json['animal_name'],
      feedMedicineCode: json['feed_medicine_code'],
      feedMedicineName: json['feed_medicine_name'],
      equipmentCode: json['equipment_code'],
      equipmentName: json['equipment_name'],
      quantity: json['quantity'] ?? 0,
      initialWeight: (json['initial_weight'] as num?)?.toDouble() ?? 0,
      purchPrice: (json['purch_price'] as num?)?.toDouble() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );
  }
}
