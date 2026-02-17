class FeedMedicine {
  final int id;
  final String name;
  final String code;
  final String? description;
  final String feedType;
  final String uom;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  FeedMedicine({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.feedType,
    required this.uom,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory FeedMedicine.fromJson(Map<String, dynamic> json) {
    return FeedMedicine(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      feedType: json['feed_type'],
      uom: json['uom'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }
}
