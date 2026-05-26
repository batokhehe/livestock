import '../../../core/data/model/feed_medicine_model.dart';
import '../../../core/helpers/utils.dart';

class HealthMonitoringDetail {
  final int id;
  final int healthMonitoringId;
  final int feedMedicineId;
  final String feedMedicineCode;
  final double quantity;
  final String uom;
  final double unitPrice;
  final double total;
  final double qtyRatioPerAnimal;
  final FeedMedicine? feedMedicine;

  HealthMonitoringDetail({
    required this.id,
    required this.healthMonitoringId,
    required this.feedMedicineId,
    required this.feedMedicineCode,
    required this.quantity,
    required this.uom,
    required this.unitPrice,
    required this.total,
    required this.qtyRatioPerAnimal,
    this.feedMedicine,
  });

  factory HealthMonitoringDetail.fromJson(Map<String, dynamic> json) {
    return HealthMonitoringDetail(
      id: json['id'] ?? 0,
      healthMonitoringId: json['health_monitoring_id'] ?? 0,
      feedMedicineId: json['feed_medicine_id'] ?? 0,
      feedMedicineCode: json['feed_medicine_code'] ?? '',
      quantity: double.tryParse(json['quantity']?.toString() ?? '') ?? 0.0,
      uom: json['uom'] ?? '',
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '') ?? 0.0,
      qtyRatioPerAnimal: double.tryParse(json['qty_ratio_per_animal']?.toString() ?? '') ?? 0.0,
      feedMedicine: json['feed_medicine'] != null
          ? FeedMedicine.fromJson(json['feed_medicine'] as Map<String, dynamic>)
          : null,
    );
  }
}

class HealthMonitoring {
  final int id;
  final String monitoringCode;
  final DateTime monitoringDate;
  final String monitoringStatus;
  final int farmLocationId;
  final int farmAreaId;
  final double unitPerAnimal;
  final double totalCost;
  final double costPerAnimal;
  final String? notes;
  final double totalMedicine;
  final double totalAnimal;
  final int employeeId;
  final int detailsCount;
  final String farmLocationName;
  final String farmAreaName;
  final String employeeName;
  final List<HealthMonitoringDetail> details;

  HealthMonitoring({
    required this.id,
    required this.monitoringCode,
    required this.monitoringDate,
    required this.monitoringStatus,
    required this.farmLocationId,
    required this.farmAreaId,
    required this.unitPerAnimal,
    required this.totalCost,
    required this.costPerAnimal,
    this.notes,
    required this.totalMedicine,
    required this.totalAnimal,
    required this.employeeId,
    required this.detailsCount,
    required this.farmLocationName,
    required this.farmAreaName,
    required this.employeeName,
    required this.details,
  });

  String get dateLabel {
    return '${monitoringDate.day} ${monthName(monitoringDate.month)} ${monitoringDate.year}';
  }

  factory HealthMonitoring.fromJson(Map<String, dynamic> json) {
    final rawDetails = json['details'] as List? ?? [];
    return HealthMonitoring(
      id: json['id'] ?? 0,
      monitoringCode: json['monitoring_code'] ?? '',
      monitoringDate: DateTime.tryParse(json['monitoring_date'] ?? '') ?? DateTime.now(),
      monitoringStatus: json['monitoring_status'] ?? '',
      farmLocationId: json['farm_location_id'] ?? 0,
      farmAreaId: json['farm_area_id'] ?? 0,
      unitPerAnimal: double.tryParse(json['unit_per_animal']?.toString() ?? '') ?? 0.0,
      totalCost: double.tryParse(json['total_cost']?.toString() ?? '') ?? 0.0,
      costPerAnimal: double.tryParse(json['cost_per_animal']?.toString() ?? '') ?? 0.0,
      notes: json['notes'],
      totalMedicine: double.tryParse(json['total_medicine']?.toString() ?? '') ?? 0.0,
      totalAnimal: double.tryParse(json['total_animal']?.toString() ?? '') ?? 0.0,
      employeeId: json['employee_id'] ?? 0,
      detailsCount: json['details_count'] ?? 0,
      farmLocationName: json['farm_location_name'] ?? '',
      farmAreaName: json['farm_area_name'] ?? '',
      employeeName: json['employee_name'] ?? '',
      details: rawDetails
          .map((e) => HealthMonitoringDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
