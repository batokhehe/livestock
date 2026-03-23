class Supplier {
  final int id;
  final String name;
  final String? contactEmail;
  final String contactPhone;
  final String address;
  final String city;
  final String cityId;
  final String state;
  final String stateId;
  final String status;
  final String tipePemasok;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Supplier({
    required this.id,
    required this.name,
    this.contactEmail,
    required this.contactPhone,
    required this.address,
    required this.city,
    required this.cityId,
    required this.state,
    required this.stateId,
    required this.status,
    required this.tipePemasok,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      contactEmail: json['contact_email'] ?? '-',
      contactPhone: json['contact_phone'] ?? '-',
      address: json['address'] ?? '-',
      city: json['city'] ?? '-',
      cityId: json['city_id'] ?? '-',
      state: json['state'] ?? '-',
      stateId: json['state_id'] ?? '-',
      status: json['status'] ?? '-',
      tipePemasok: json['tipe_pemasok'] ?? '-',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'address': address,
      'city': city,
      'city_id': cityId,
      'state': state,
      'state_id': stateId,
      'status': status,
      'tipe_pemasok': tipePemasok,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
