import 'purchase_order_item_request_model.dart';

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

  final String? ageCategory;
  final bool? isVaccinated;
  final DateTime? vaccineDate;

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
    this.ageCategory,
    this.isVaccinated,
    this.vaccineDate,
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
      ageCategory: json['age_category']?.toString(),
      isVaccinated: json['is_vaccinated'] == 1 || json['is_vaccinated'] == true,
      vaccineDate: json['vaccine_date'] != null
          ? DateTime.tryParse(json['vaccine_date'])
          : null,
    );
  }

  PurchaseOrderItemRequest toPurchaseOrderItemRequest() {
    return PurchaseOrderItemRequest(
      animalCode: animalCode,
      animalName: animalName,
      initialWeight: initialWeight,
      ageCategory: ageCategory != null ? int.tryParse(ageCategory!) : null,
      isVaccinated: isVaccinated,
      vaccineDate: vaccineDate,
      feedMedicineCode: feedMedicineCode,
      feedMedicineName: feedMedicineName,
      equipmentCode: equipmentCode,
      equipmentName: equipmentName,
      quantity: quantity,
      purchPrice: purchPrice,
      subtotal: subtotal,
      total: total,
    );
  }
}
