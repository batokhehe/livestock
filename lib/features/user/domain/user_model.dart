class UserModel {
  final String name;
  final String email;
  final int roleId;
  final String roleName;
  final int? farmLocationId;

  UserModel({
    required this.name,
    required this.email,
    required this.roleId,
    required this.roleName,
    this.farmLocationId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      roleId: _parseInt(json['role_id']) ?? 0,
      roleName: (json['role_name'] ?? '').toString(),
      farmLocationId: _parseInt(json['farm_location_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "role_id": roleId,
      "role_name": roleName,
      "farm_location_id": farmLocationId,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
