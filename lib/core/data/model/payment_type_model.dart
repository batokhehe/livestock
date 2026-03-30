class PaymentType {
  final int id;
  final String name;
  final String? description;
  final String? creatorId;
  final String? createdBy;
  final String? updaterId;
  final String? updatedBy;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final bool? isDefault;
  final String? formattedCreatedAt;
  final String? formattedDeletedAt;

  PaymentType({
    required this.id,
    required this.name,
    this.description,
    this.creatorId,
    this.createdBy,
    this.updaterId,
    this.updatedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.isDefault,
    this.formattedCreatedAt,
    this.formattedDeletedAt,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      creatorId: json['creator_id'],
      createdBy: json['created_by'],
      updaterId: json['updater_id'],
      updatedBy: json['updated_by'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isDefault: json['is_default'],
      formattedCreatedAt: json['formatted_created_at'],
      formattedDeletedAt: json['formatted_deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creator_id': creatorId,
      'created_by': createdBy,
      'updater_id': updaterId,
      'updated_by': updatedBy,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_default': isDefault,
      'formatted_created_at': formattedCreatedAt,
      'formatted_deleted_at': formattedDeletedAt,
    };
  }
}
