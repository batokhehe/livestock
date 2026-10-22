import 'package:livestock/core/data/model/animal_profile_model.dart';

class BatchAnimalTransferItem {
  final AnimalProfile animal;
  double? shippingCost;
  String notes;

  BatchAnimalTransferItem({
    required this.animal,
    this.shippingCost,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'animal_profile_id': animal.id,
      'shipping_cost': shippingCost ?? 0,
      'notes': notes,
    };
  }

  BatchAnimalTransferItem copyWith({
    AnimalProfile? animal,
    double? shippingCost,
    String? notes,
  }) {
    return BatchAnimalTransferItem(
      animal: animal ?? this.animal,
      shippingCost: shippingCost ?? this.shippingCost,
      notes: notes ?? this.notes,
    );
  }
}
