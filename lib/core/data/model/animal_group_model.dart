class AnimalGroup {
  final int id;
  final String name;
  final String? code;

  AnimalGroup({required this.id, required this.name, this.code});

  factory AnimalGroup.fromJson(Map<String, dynamic> json) {
    return AnimalGroup(id: json['id'], name: json['name'], code: json['code']);
  }
}
