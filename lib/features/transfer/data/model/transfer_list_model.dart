class TransferList {
  final int id;
  final String transferNo;
  final String transferCode;
  final String transferDate;
  final String status;
  final int? fromFarmLocationId;
  final String fromFarmLocationName;
  final String? fromFarmAreaName;
  final int? toFarmLocationId;
  final String toFarmLocationName;
  final String? toFarmAreaName;
  final String totalQuantity;
  final String? createdBy;
  final List<dynamic> details;
  final String? animalName;
  final String? animalCode;
  final bool isStock;

  TransferList({
    required this.id,
    required this.transferNo,
    required this.transferCode,
    required this.transferDate,
    required this.status,
    this.fromFarmLocationId,
    required this.fromFarmLocationName,
    this.fromFarmAreaName,
    this.toFarmLocationId,
    required this.toFarmLocationName,
    this.toFarmAreaName,
    required this.totalQuantity,
    this.createdBy,
    required this.details,
    this.animalName,
    this.animalCode,
    required this.isStock,
  });

  factory TransferList.fromJson(Map<String, dynamic> json) {
    final transferCodeValue = json['transfer_code'] ?? json['transfer_no'] ?? json['stock_code'] ?? '-';
    
    final animalProfile = json['animal_profile'] as Map<String, dynamic>?;
    final feedMedicine = json['feed_medicine'] as Map<String, dynamic>?;
    final feed = json['feed'] as Map<String, dynamic>?;
    final stock = json['stock'] as Map<String, dynamic>?;

    final parsedAnimalName = animalProfile?['name'] ?? 
                             feedMedicine?['name'] ?? 
                             feed?['name'] ?? 
                             stock?['name'] ?? 
                             json['animal_name'] ?? 
                             '-';

    final parsedAnimalCode = animalProfile?['animal_code'] ?? 
                             animalProfile?['code'] ?? 
                             feedMedicine?['code'] ?? 
                             feedMedicine?['feed_code'] ?? 
                             feed?['code'] ?? 
                             feed?['feed_code'] ?? 
                             stock?['code'] ?? 
                             json['animal_code'] ?? 
                             '-';

    // Check if it's a Stock transfer (lack of animal_profile is the direct indicator)
    final bool parsedIsStock = json['animal_profile'] == null;

    return TransferList(
      id: json['id'] ?? 0,
      transferNo: transferCodeValue,
      transferCode: transferCodeValue,
      transferDate: json['transfer_date'] ?? json['date'] ?? '-',
      status: json['status'] ?? json['transfer_status'] ?? '-',
      fromFarmLocationId: json['from_farm_location_id'],
      fromFarmLocationName: json['from_farm_location']?['name'] ?? json['from_farm_location_name'] ?? '-',
      fromFarmAreaName: json['from_farm_area']?['area_name'] ?? json['from_farm_area_name'],
      toFarmLocationId: json['to_farm_location_id'],
      toFarmLocationName: json['to_farm_location']?['name'] ?? json['to_farm_location_name'] ?? '-',
      toFarmAreaName: json['to_farm_area']?['area_name'] ?? json['to_farm_area_name'],
      totalQuantity: json['total_quantity']?.toString() ?? json['quantity']?.toString() ?? '1',
      createdBy: json['created_by'] ?? '-',
      details: json['details'] as List? ?? json['items'] as List? ?? [],
      animalName: parsedAnimalName,
      animalCode: parsedAnimalCode,
      isStock: parsedIsStock,
    );
  }

  String get dateLabel => transferDate;
}
