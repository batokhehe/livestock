class FarmArea {
  final int id;
  final String name;

  FarmArea({required this.id, required this.name});

  factory FarmArea.fromJson(Map<String, dynamic> json) {
    return FarmArea(id: json['id'], name: json['area_name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
