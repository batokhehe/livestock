class VehicleModel {
  final int id;
  final String name;
  final String? description;
  final String vehicleIdentificationNumber;
  final double capacityInKg;
  final double capacityInVolume;
  final int driverId;
  final String creatorName;
  final DateTime createdAt;

  VehicleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.vehicleIdentificationNumber,
    required this.capacityInKg,
    required this.capacityInVolume,
    required this.driverId,
    required this.creatorName,
    required this.createdAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      vehicleIdentificationNumber: json['vehicleIdentificationNumber'],
      capacityInKg: (json['capacityInKg'] as num).toDouble(),
      capacityInVolume: (json['capacityInVolume'] as num).toDouble(),
      driverId: json['driverId'],
      creatorName: json['creatorName'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "vehicleIdentificationNumber": vehicleIdentificationNumber,
      "capacityInKg": capacityInKg,
      "capacityInVolume": capacityInVolume,
      "driverId": driverId,
      "creatorName": creatorName,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
