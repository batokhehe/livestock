class TransferDetail {
  final int id;
  final String transferCode;
  final String transferDate;
  final int fromFarmLocationId;
  final int toFarmLocationId;
  final int fromFarmAreaId;
  final int toFarmAreaId;
  final int animalProfileId;
  final String shippingCost;
  final TransferLocationDetail fromFarmLocation;
  final TransferLocationDetail toFarmLocation;
  final TransferAreaDetail fromFarmArea;
  final TransferAreaDetail toFarmArea;
  final TransferAnimalDetail animalProfile;
  final String createdBy;
  final String createdAt;

  TransferDetail({
    required this.id,
    required this.transferCode,
    required this.transferDate,
    required this.fromFarmLocationId,
    required this.toFarmLocationId,
    required this.fromFarmAreaId,
    required this.toFarmAreaId,
    required this.animalProfileId,
    required this.shippingCost,
    required this.fromFarmLocation,
    required this.toFarmLocation,
    required this.fromFarmArea,
    required this.toFarmArea,
    required this.animalProfile,
    required this.createdBy,
    required this.createdAt,
  });

  factory TransferDetail.fromJson(Map<String, dynamic> json) {
    return TransferDetail(
      id: json['id'] ?? 0,
      transferCode: json['transfer_code'] ?? '',
      transferDate: json['transfer_date'] ?? '',
      fromFarmLocationId: json['from_farm_location_id'] ?? 0,
      toFarmLocationId: json['to_farm_location_id'] ?? 0,
      fromFarmAreaId: json['from_farm_area_id'] ?? 0,
      toFarmAreaId: json['to_farm_area_id'] ?? 0,
      animalProfileId: json['animal_profile_id'] ?? 0,
      shippingCost: json['shipping_cost']?.toString() ?? '0.00',
      fromFarmLocation: TransferLocationDetail.fromJson(json['from_farm_location'] ?? {}),
      toFarmLocation: TransferLocationDetail.fromJson(json['to_farm_location'] ?? {}),
      fromFarmArea: TransferAreaDetail.fromJson(json['from_farm_area'] ?? {}),
      toFarmArea: TransferAreaDetail.fromJson(json['to_farm_area'] ?? {}),
      animalProfile: TransferAnimalDetail.fromJson(json['animal_profile'] ?? {}),
      createdBy: json['created_by'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class TransferLocationDetail {
  final int id;
  final String name;

  TransferLocationDetail({required this.id, required this.name});

  factory TransferLocationDetail.fromJson(Map<String, dynamic> json) {
    return TransferLocationDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class TransferAreaDetail {
  final int id;
  final String areaName;

  TransferAreaDetail({required this.id, required this.areaName});

  factory TransferAreaDetail.fromJson(Map<String, dynamic> json) {
    return TransferAreaDetail(
      id: json['id'] ?? 0,
      areaName: json['area_name'] ?? json['name'] ?? '',
    );
  }
}

class TransferAnimalDetail {
  final int id;
  final String name;
  final String animalCode;
  final TransferAnimalGroupDetail? animalGroup;

  TransferAnimalDetail({
    required this.id,
    required this.name,
    required this.animalCode,
    this.animalGroup,
  });

  factory TransferAnimalDetail.fromJson(Map<String, dynamic> json) {
    return TransferAnimalDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      animalCode: json['animal_code'] ?? '',
      animalGroup: json['animal_group'] != null
          ? TransferAnimalGroupDetail.fromJson(json['animal_group'])
          : null,
    );
  }
}

class TransferAnimalGroupDetail {
  final int id;
  final String name;

  TransferAnimalGroupDetail({required this.id, required this.name});

  factory TransferAnimalGroupDetail.fromJson(Map<String, dynamic> json) {
    return TransferAnimalGroupDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
