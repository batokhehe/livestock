import '../../../core/data/model/feed_medicine_model.dart';
import '../../../core/helpers/utils.dart';
import '../../attendance/data/model/employee_model.dart';

class AnimalHealthCheckDetail {
  final int id;
  final int animalHealthCheckId;
  final int feedMedicineId;
  final String feedMedicineCode;
  final double quantity;
  final String uom;
  final double unitPrice;
  final double total;
  final double qtyRatioPerAnimal;
  final FeedMedicine? feedMedicine;

  AnimalHealthCheckDetail({
    required this.id,
    required this.animalHealthCheckId,
    required this.feedMedicineId,
    required this.feedMedicineCode,
    required this.quantity,
    required this.uom,
    required this.unitPrice,
    required this.total,
    required this.qtyRatioPerAnimal,
    this.feedMedicine,
  });

  factory AnimalHealthCheckDetail.fromJson(Map<String, dynamic> json) {
    final quantityParsed = double.tryParse(json['quantity']?.toString() ?? '') ?? 0.0;
    
    final unitPriceParsed = double.tryParse(
      json['unit_price']?.toString() ?? 
      json['price']?.toString() ?? 
      json['unit_cost']?.toString() ?? 
      json['feed_medicine']?['price']?.toString() ??
      json['feed_medicine']?['unit_price']?.toString() ??
      json['feed_medicine']?['standard_rate']?.toString() ??
      ''
    ) ?? 0.0;

    final totalParsed = double.tryParse(
      json['total']?.toString() ?? 
      json['total_price']?.toString() ?? 
      json['total_cost']?.toString() ?? 
      ''
    ) ?? (unitPriceParsed * quantityParsed);

    return AnimalHealthCheckDetail(
      id: json['id'] ?? 0,
      animalHealthCheckId: json['animal_health_check_id'] ?? json['health_monitoring_id'] ?? 0,
      feedMedicineId: json['feed_medicine_id'] ?? 0,
      feedMedicineCode: json['feed_medicine_code'] ?? '',
      quantity: quantityParsed,
      uom: json['uom'] ?? '',
      unitPrice: unitPriceParsed,
      total: totalParsed,
      qtyRatioPerAnimal: double.tryParse(json['qty_ratio_per_animal']?.toString() ?? '') ?? 0.0,
      feedMedicine: json['feed_medicine'] != null
          ? FeedMedicine.fromJson(json['feed_medicine'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AnimalHealthCheck {
  final int id;
  final String checkCode;
  final DateTime checkDate;
  final String checkStatus;
  final int farmLocationId;
  final int farmAreaId;
  final int? animalId;
  final String? animalCode;
  final String? animalName;
  final String? notes;
  final int employeeId;
  final int detailsCount;
  final String farmLocationName;
  final String farmAreaName;
  final String employeeName;
  final double totalCost;
  final String? formattedCreatedAt;
  final Employee? employee;
  final List<AnimalHealthCheckDetail> details;

  AnimalHealthCheck({
    required this.id,
    required this.checkCode,
    required this.checkDate,
    required this.checkStatus,
    required this.farmLocationId,
    required this.farmAreaId,
    this.animalId,
    this.animalCode,
    this.animalName,
    this.notes,
    required this.employeeId,
    required this.detailsCount,
    required this.farmLocationName,
    required this.farmAreaName,
    required this.employeeName,
    required this.totalCost,
    this.formattedCreatedAt,
    this.employee,
    required this.details,
  });

  String get dateLabel {
    return '${checkDate.day} ${monthName(checkDate.month)} ${checkDate.year}';
  }

  factory AnimalHealthCheck.fromJson(Map<String, dynamic> json) {
    final rawDetails = json['details'] as List? ?? [];
    
    // Parse animal details
    final animalJson = json['animal'] as Map<String, dynamic>?;
    final animalCodeParsed = json['animal_code'] ?? animalJson?['animal_code'];
    final animalNameParsed = json['animal_name'] ?? animalJson?['name'];

    // Parse employee details
    final employeeJson = json['employee'] as Map<String, dynamic>?;
    final employeeNameParsed = employeeJson != null ? (employeeJson['name'] ?? '') : '';

    final detailsList = rawDetails
        .map((e) => AnimalHealthCheckDetail.fromJson(e as Map<String, dynamic>))
        .toList();

    final totalCostParsed = double.tryParse(json['total_cost']?.toString() ?? json['total_price']?.toString() ?? '') ?? 
        detailsList.fold<double>(0.0, (sum, item) => sum + item.total);

    return AnimalHealthCheck(
      id: json['id'] ?? 0,
      checkCode: json['check_code'] ?? '',
      checkDate: DateTime.tryParse(json['check_date'] ?? '') ?? DateTime.now(),
      checkStatus: json['check_status'] ?? '',
      farmLocationId: json['farm_location_id'] ?? 0,
      farmAreaId: json['farm_area_id'] ?? 0,
      animalId: json['animal_id'],
      animalCode: animalCodeParsed,
      animalName: animalNameParsed,
      notes: json['notes'],
      employeeId: json['employee_id'] ?? 0,
      detailsCount: json['details_count'] ?? detailsList.length,
      farmLocationName: json['farm_location_name'] ?? json['farm_location']?['name'] ?? '',
      farmAreaName: json['farm_area_name'] ?? json['farm_area']?['area_name'] ?? '',
      employeeName: employeeNameParsed.isNotEmpty ? employeeNameParsed : (json['employee_name'] ?? ''),
      totalCost: totalCostParsed,
      formattedCreatedAt: json['formatted_created_at'] ?? json['created_at'],
      employee: employeeJson != null
          ? Employee.fromJson(employeeJson)
          : null,
      details: detailsList,
    );
  }
}
