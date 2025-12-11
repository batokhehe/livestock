import 'package:livestock/features/user/domain/role_model.dart';
import 'package:livestock/features/user/domain/vehicle_model.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final RoleModel? role;
  final VehicleModel? vehicle;
  final bool? isWeb;
  final bool? isMobile;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.vehicle,
    this.isWeb,
    this.isMobile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] != null ? RoleModel.fromJson(json["role"]) : null,
      vehicle: json["vehicle"] != null
          ? VehicleModel.fromJson(json["vehicle"])
          : null,
      isWeb: json["isWeb"],
      isMobile: json["isMobile"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role": role?.toJson(),
      "vehicle": vehicle?.toJson(),
      "isWeb": isWeb,
      "isMobile": isMobile,
    };
  }
}
