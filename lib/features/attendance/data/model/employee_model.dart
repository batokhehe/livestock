import '../../../../core/data/model/farm_location_model.dart';

class Employee {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String position;
  final String status;
  final String formattedHireDate;
  final FarmLocation? farmLocation;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.status,
    required this.formattedHireDate,
    this.farmLocation,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone_number'] ?? '',
      position: json['position'] ?? '',
      status: json['employee_status'] ?? '',
      formattedHireDate: json['formatted_hire_date'] ?? '',
      farmLocation: json['farm_location'] != null
          ? FarmLocation.fromJson(json['farm_location'])
          : null,
    );
  }
}
