class UserModel {
  final int? id;
  final String name;
  final String email;
  final int roleId;
  final String roleName;
  final int? farmLocationId;
  final String phone;
  final List<String> permissions;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.roleId,
    required this.roleName,
    this.farmLocationId,
    required this.phone,
    required this.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: parseInt(json['id']) ?? parseInt(json['user_id']),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      roleId: parseInt(json['role_id']) ?? 0,
      roleName: (json['role_name'] ?? '').toString(),
      farmLocationId: parseInt(json['farm_location_id']),
      phone: (json['phone'] ?? '').toString(),
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role_id": roleId,
      "role_name": roleName,
      "farm_location_id": farmLocationId,
      "phone": phone,
      "permissions": permissions,
    };
  }

  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) => parseInt(value);

  bool hasPermission(String key) {
    return permissions.contains(key);
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    int? roleId,
    String? roleName,
    int? farmLocationId,
    String? phone,
    List<String>? permissions,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
      farmLocationId: farmLocationId ?? this.farmLocationId,
      phone: phone ?? this.phone,
      permissions: permissions ?? this.permissions,
    );
  }
}
