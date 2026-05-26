class TotalAnimal {
  final int farmLocationId;
  final int farmAreaId;
  final int totalAnimal;

  TotalAnimal({
    required this.farmLocationId,
    required this.farmAreaId,
    required this.totalAnimal,
  });

  factory TotalAnimal.fromJson(Map<String, dynamic> json) {
    return TotalAnimal(
      farmLocationId: int.tryParse(json['farm_location_id']?.toString() ?? '') ?? 0,
      farmAreaId: int.tryParse(json['farm_area_id']?.toString() ?? '') ?? 0,
      totalAnimal: int.tryParse(json['total_animal']?.toString() ?? '') ?? 0,
    );
  }
}
