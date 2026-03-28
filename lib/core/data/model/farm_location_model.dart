class FarmLocation {
  final int id;
  final String name;

  FarmLocation({required this.id, required this.name});

  factory FarmLocation.fromJson(Map<String, dynamic> json) {
    return FarmLocation(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
