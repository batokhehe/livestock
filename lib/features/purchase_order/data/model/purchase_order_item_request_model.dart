import 'package:livestock/core/data/model/feed_medicine_model.dart';

class PurchaseOrderItemRequest {
  /// Animal
  final String? animalCode;
  final String? animalName;
  final String? poel;
  final String? gender;
  final double? initialWeight;
  final int? ageCategory;
  final bool? isVaccinated;
  final DateTime? vaccineDate;

  /// Feed / Medicine
  final FeedMedicine? feedMedicine;
  final String? feedMedicineName;
  final String? feedMedicineCode;
  final String? feedMedicineType;

  /// Equipment
  final int? equipmentId;
  final String? equipmentCode;
  final String? equipmentName;

  /// Common
  final int? quantity;
  final double? purchPrice;
  final double subtotal;
  final double total;
  final String? notes;

  PurchaseOrderItemRequest({
    this.animalCode,
    this.animalName,
    this.poel,
    this.gender,
    this.initialWeight,
    this.ageCategory,
    this.isVaccinated,
    this.vaccineDate,
    this.feedMedicine,
    this.feedMedicineName,
    this.feedMedicineCode,
    this.feedMedicineType,
    this.equipmentId,
    this.equipmentCode,
    this.equipmentName,
    this.quantity,
    this.purchPrice,
    required this.subtotal,
    required this.total,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      /// Animal
      "animal_code": animalCode,
      "animal_name": animalName,
      "poel": poel,
      "gender": gender,
      "initial_weight": initialWeight,
      "age_category": ageCategory,
      "is_vaccinated": isVaccinated,
      "vaccine_date": vaccineDate?.toIso8601String().split('T').first,

      /// Feed
      "feed_medicine_id": feedMedicine?.id,
      "feed_medicine_code": feedMedicineCode,
      "feed_medicine_name": feedMedicineName,

      /// Equipment
      "equipment_id": equipmentId,
      "equipment_code": equipmentCode,
      "equipment_name": equipmentName,

      /// Common
      "quantity": quantity,
      "purch_price": purchPrice,
      "subtotal": subtotal,
      "total": total,
      "notes": notes,
    }..removeWhere((key, value) => value == null);
  }
}
