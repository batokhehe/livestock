class Customer {
  final int id;
  final String name;
  final String? contactEmail;
  final String? contactPhone;
  final String? address;
  final String? city;
  final String? cityId;
  final String? state;
  final String? stateId;
  final String? district;
  final String? districtId;
  final String? village;
  final String? villageId;
  final String? status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Customer({
    required this.id,
    required this.name,
    this.contactEmail,
    this.contactPhone,
    this.address,
    this.city,
    this.cityId,
    this.state,
    this.stateId,
    this.district,
    this.districtId,
    this.village,
    this.villageId,
    this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  /// 🔥 FROM JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'] ?? '',
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      address: json['address'],
      city: json['city'],
      cityId: json['city_id'],
      state: json['state'],
      stateId: json['state_id'],
      district: json['district'],
      districtId: json['district_id'],
      village: json['village'],
      villageId: json['village_id'],
      status: json['status'],
      notes: json['notes'],
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

  /// 🔥 TO JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "contact_email": contactEmail,
      "contact_phone": contactPhone,
      "address": address,
      "city": city,
      "city_id": cityId,
      "state": state,
      "state_id": stateId,
      "district": district,
      "district_id": districtId,
      "village": village,
      "village_id": villageId,
      "status": status,
      "notes": notes,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "deleted_at": deletedAt?.toIso8601String(),
    };
  }

  /// 🔥 COPY WITH (WAJIB BUAT RIVERPOD)
  Customer copyWith({
    int? id,
    String? name,
    String? contactEmail,
    String? contactPhone,
    String? address,
    String? city,
    String? cityId,
    String? state,
    String? stateId,
    String? district,
    String? districtId,
    String? village,
    String? villageId,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      address: address ?? this.address,
      city: city ?? this.city,
      cityId: cityId ?? this.cityId,
      state: state ?? this.state,
      stateId: stateId ?? this.stateId,
      district: district ?? this.district,
      districtId: districtId ?? this.districtId,
      village: village ?? this.village,
      villageId: villageId ?? this.villageId,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// 🔥 Helper
  bool get isActive => status == "active";

  String get fullAddress => "${address ?? ''}, ${city ?? ''}, ${state ?? ''}";
}
