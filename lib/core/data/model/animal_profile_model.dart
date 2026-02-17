class AnimalProfile {
  final int id;
  final String animalCode;
  final String? animalGroupName;
  final String name;
  final String status;
  final String available;
  final double weight;

  // final AnimalGroup? animalGroup; // 👈 BARU

  AnimalProfile({
    required this.id,
    required this.animalCode,
    this.animalGroupName,
    required this.name,
    required this.status,
    required this.available,
    required this.weight,
    // this.animalGroup,
  });

  factory AnimalProfile.fromJson(Map<String, dynamic> json) {
    return AnimalProfile(
      id: json['id'],
      animalCode: json['animal_code'],
      animalGroupName: json['animal_group_name'],
      name: json['name'],
      status: json['status'],
      available: json['available'],
      weight: double.parse(json['weight'].toString()),
      // animalGroup: json['animal_group'] != null
      //     ? AnimalGroup.fromJson(json['animal_group'])
      //     : null,
    );
  }
}
