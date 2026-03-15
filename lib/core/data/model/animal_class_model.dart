import 'animal_group_model.dart';

class AnimalClass {
  final int id;
  final int animalGroupId;
  final AnimalGroup animalGroup;
  final String className;
  final int price;
  final int weightMin;
  final int weightMax;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int total;
  final int available;
  final int sold;

  AnimalClass({
    required this.id,
    required this.animalGroupId,
    required this.animalGroup,
    required this.className,
    required this.price,
    required this.weightMin,
    required this.weightMax,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.total,
    required this.available,
    required this.sold,
  });

  factory AnimalClass.fromJson(Map<String, dynamic> json) {
    return AnimalClass(
      id: json['id'] ?? 0,
      animalGroupId: json['animal_group_id'] ?? 0,
      animalGroup: AnimalGroup.fromJson(json['animal_group']),
      className: json['class_name'] ?? '',
      price: json['price'] ?? 0,
      weightMin: json['weight_min'] ?? 0,
      weightMax: json['weight_max'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      total: json['total'] ?? 0,
      available: json['available'] ?? 0,
      sold: json['sold'] ?? 0,
    );
  }
}
