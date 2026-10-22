class TransferDetail {
  final int id;
  final String transferCode;
  final String transferDate;
  final int fromFarmLocationId;
  final int toFarmLocationId;
  final int fromFarmAreaId;
  final int toFarmAreaId;
  final int animalProfileId;
  final String? notes;
  final String shippingCost;
  final TransferLocationDetail fromFarmLocation;
  final TransferLocationDetail toFarmLocation;
  final TransferAreaDetail fromFarmArea;
  final TransferAreaDetail toFarmArea;
  final TransferAnimalDetail? animalProfile;
  final List<TransferDetailItem> details;
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
    this.notes,
    required this.shippingCost,
    required this.fromFarmLocation,
    required this.toFarmLocation,
    required this.fromFarmArea,
    required this.toFarmArea,
    this.animalProfile,
    this.details = const [],
    required this.createdBy,
    required this.createdAt,
  });

  factory TransferDetail.fromJson(Map<String, dynamic> json) {
    final rawDetails = json['details'] as List? ?? json['items'] as List? ?? [];
    final parsedDetails = rawDetails
        .whereType<Map<String, dynamic>>()
        .map((e) => TransferDetailItem.fromJson(e))
        .toList();

    // Fallback if details is empty but root has animal_profile
    if (parsedDetails.isEmpty && json['animal_profile'] != null) {
      parsedDetails.add(
        TransferDetailItem(
          id: json['id'] ?? 0,
          animalProfileId: json['animal_profile_id'] ?? 0,
          shippingCost: double.tryParse(json['shipping_cost']?.toString() ?? '0') ?? 0.0,
          notes: json['notes'] ?? '',
          animalProfile: TransferAnimalDetail.fromJson(json['animal_profile']),
        ),
      );
    }

    double totalCost = double.tryParse(json['total_shipping_cost']?.toString() ?? json['shipping_cost']?.toString() ?? '') ?? 0.0;
    if (totalCost == 0.0 && parsedDetails.isNotEmpty) {
      totalCost = parsedDetails.fold<double>(0.0, (sum, item) => sum + item.shippingCost);
    }

    final rootAnimal = json['animal_profile'] != null
        ? TransferAnimalDetail.fromJson(json['animal_profile'])
        : (parsedDetails.isNotEmpty ? parsedDetails.first.animalProfile : null);

    return TransferDetail(
      id: json['id'] ?? 0,
      transferCode: json['transfer_code'] ?? json['transfer_no'] ?? json['batch_no'] ?? '',
      transferDate: json['transfer_date'] ?? json['date'] ?? '',
      fromFarmLocationId: json['from_farm_location_id'] ?? 0,
      toFarmLocationId: json['to_farm_location_id'] ?? 0,
      fromFarmAreaId: json['from_farm_area_id'] ?? 0,
      toFarmAreaId: json['to_farm_area_id'] ?? 0,
      animalProfileId: json['animal_profile_id'] ?? (parsedDetails.isNotEmpty ? parsedDetails.first.animalProfileId : 0),
      notes: json['notes'],
      shippingCost: totalCost > 0 ? totalCost.toStringAsFixed(0) : (json['shipping_cost']?.toString() ?? '0'),
      fromFarmLocation: TransferLocationDetail.fromJson(json['from_farm_location'] ?? {}),
      toFarmLocation: TransferLocationDetail.fromJson(json['to_farm_location'] ?? {}),
      fromFarmArea: TransferAreaDetail.fromJson(json['from_farm_area'] ?? {}),
      toFarmArea: TransferAreaDetail.fromJson(json['to_farm_area'] ?? {}),
      animalProfile: rootAnimal,
      details: parsedDetails,
      createdBy: json['created_by'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class TransferDetailItem {
  final int id;
  final int animalProfileId;
  final double shippingCost;
  final String notes;
  final TransferAnimalDetail animalProfile;

  TransferDetailItem({
    required this.id,
    required this.animalProfileId,
    required this.shippingCost,
    required this.notes,
    required this.animalProfile,
  });

  factory TransferDetailItem.fromJson(Map<String, dynamic> json) {
    return TransferDetailItem(
      id: json['id'] ?? 0,
      animalProfileId: json['animal_profile_id'] ?? 0,
      shippingCost: double.tryParse(json['shipping_cost']?.toString() ?? '0') ?? 0.0,
      notes: json['notes']?.toString() ?? '',
      animalProfile: TransferAnimalDetail.fromJson(json['animal_profile'] ?? {}),
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
  final double weight;
  final String? available;
  final TransferAnimalGroupDetail? animalGroup;

  TransferAnimalDetail({
    required this.id,
    required this.name,
    required this.animalCode,
    this.weight = 0.0,
    this.available,
    this.animalGroup,
  });

  factory TransferAnimalDetail.fromJson(Map<String, dynamic> json) {
    return TransferAnimalDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      animalCode: json['animal_code'] ?? json['code'] ?? '',
      weight: double.tryParse(json['weight']?.toString() ?? '0') ?? 0.0,
      available: json['available'] ?? json['status'],
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
