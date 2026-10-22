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
  final String? feedType;

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
    this.feedType,
  });

  factory TransferList.fromJson(Map<String, dynamic> json, {bool? isStock}) {
    final transferCodeValue = json['transfer_code'] ??
        json['transfer_no'] ??
        json['batch_no'] ??
        json['stock_code'] ??
        '-';

    final animalProfile = json['animal_profile'] as Map<String, dynamic>?;
    final feedMedicine = json['feed_medicine'] as Map<String, dynamic>?;
    final feed = json['feed'] as Map<String, dynamic>?;
    final stock = json['stock'] as Map<String, dynamic>?;

    final detailsList =
        json['details'] as List? ?? json['items'] as List? ?? [];

    final bool parsedIsStock = isStock ??
        (json['item_type'] != null ||
            feedMedicine != null ||
            feed != null ||
            stock != null ||
            (json['animal_profile'] == null && detailsList.isEmpty));

    Map<String, dynamic>? firstAnimalProfile = animalProfile;
    if (firstAnimalProfile == null &&
        detailsList.isNotEmpty &&
        detailsList.first is Map) {
      final firstDetail = detailsList.first as Map<String, dynamic>;
      if (firstDetail['animal_profile'] is Map) {
        firstAnimalProfile =
            firstDetail['animal_profile'] as Map<String, dynamic>;
      }
    }

    final int animalCount = json['total_animals'] ??
        (json['quantity'] is int ? json['quantity'] : null) ??
        (detailsList.isNotEmpty ? detailsList.length : 1);

    final String parsedAnimalName;
    final String parsedAnimalCode;

    if (parsedIsStock) {
      parsedAnimalName = feedMedicine?['name'] ??
          feed?['name'] ??
          stock?['name'] ??
          json['item_name'] ??
          json['animal_name'] ??
          '-';
      parsedAnimalCode = feedMedicine?['code'] ??
          feedMedicine?['feed_code'] ??
          feed?['code'] ??
          feed?['feed_code'] ??
          stock?['code'] ??
          json['animal_code'] ??
          '-';
    } else {
      if (detailsList.length > 1) {
        final firstAnimalName =
            firstAnimalProfile?['name'] ?? json['animal_name'];
        if (firstAnimalName != null && firstAnimalName.toString().isNotEmpty) {
          parsedAnimalName =
              "$firstAnimalName (+${detailsList.length - 1} lainnya)";
        } else {
          parsedAnimalName = "$animalCount Ekor Hewan";
        }
        parsedAnimalCode = "$animalCount Ekor";
      } else {
        parsedAnimalName = firstAnimalProfile?['name'] ??
            json['animal_name'] ??
            (animalCount > 1 ? "$animalCount Ekor Hewan" : '-');
        parsedAnimalCode = firstAnimalProfile?['animal_code'] ??
            firstAnimalProfile?['code'] ??
            json['animal_code'] ??
            (animalCount > 1 ? "$animalCount Ekor" : '-');
      }
    }

    final parsedFeedType = feedMedicine?['feed_type'] ??
        feed?['feed_type'] ??
        stock?['feed_type'] ??
        json['feed_type'] ??
        json['item_type']?.toString();

    final fromLocName = json['from_farm_location']?['name'] ??
        json['from_farm_location_name'] ??
        '-';
    final fromAreaName = json['from_farm_area']?['area_name'] ??
        json['from_farm_area']?['name'] ??
        json['from_farm_area_name'];

    final toLocName = json['to_farm_location']?['name'] ??
        json['to_farm_location_name'] ??
        '-';
    final toAreaName = json['to_farm_area']?['area_name'] ??
        json['to_farm_area']?['name'] ??
        json['to_farm_area_name'];

    return TransferList(
      id: json['id'] ?? 0,
      transferNo: transferCodeValue,
      transferCode: transferCodeValue,
      transferDate: json['transfer_date'] ?? json['date'] ?? '-',
      status: json['status'] ?? json['transfer_status'] ?? '-',
      fromFarmLocationId: json['from_farm_location_id'],
      fromFarmLocationName: fromLocName,
      fromFarmAreaName: fromAreaName,
      toFarmLocationId: json['to_farm_location_id'],
      toFarmLocationName: toLocName,
      toFarmAreaName: toAreaName,
      totalQuantity: json['total_quantity']?.toString() ??
          json['total_animals']?.toString() ??
          json['quantity']?.toString() ??
          json['qty']?.toString() ??
          (detailsList.isNotEmpty ? detailsList.length.toString() : '1'),
      createdBy: json['created_by'] ?? '-',
      details: detailsList,
      animalName: parsedAnimalName,
      animalCode: parsedAnimalCode,
      isStock: parsedIsStock,
      feedType: parsedFeedType,
    );
  }

  String get dateLabel => transferDate;

  String get itemTypeLabel {
    final type = feedType?.toLowerCase() ?? '';
    if (type == 'feed' || type == 'pakan') return 'Pakan';
    if (type == 'medicine' || type == 'obat') return 'Obat';
    if (type == 'equipment' || type == 'tool' || type == 'alat') return 'Alat';
    return type.isNotEmpty ? type : '-';
  }
}
