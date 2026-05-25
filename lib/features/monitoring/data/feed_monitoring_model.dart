import '../../../core/data/model/feed_medicine_model.dart';
import '../../../core/helpers/utils.dart';

class FeedMonitoringDetail {
  final int id;
  final int feedMedicineId;
  final String feedMedicineCode;
  final String feedMedicineName;
  final double quantity;
  final String uom;
  final double unitPrice;
  final double total;
  final double qtyRatioPerAnimal;
  final FeedMedicine? feedMedicine;

  FeedMonitoringDetail({
    required this.id,
    required this.feedMedicineId,
    required this.feedMedicineCode,
    required this.feedMedicineName,
    required this.quantity,
    required this.uom,
    required this.unitPrice,
    required this.total,
    required this.qtyRatioPerAnimal,
    this.feedMedicine,
  });

  factory FeedMonitoringDetail.fromJson(Map<String, dynamic> json) {
    return FeedMonitoringDetail(
      id: json['id'] ?? 0,
      feedMedicineId: json['feed_medicine_id'] ?? 0,
      feedMedicineCode: json['feed_medicine_code'] ?? '',
      feedMedicineName: json['feed_medicine_name'] ?? '',
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

class FeedMonitoring {
  final int id;
  final String monitoringCode;
  final DateTime monitoringDate;
  final int employeeId;
  final String employeeName;
  final int farmLocationId;
  final String farmLocationName;
  final int farmAreaId;
  final String farmAreaName;
  final int totalAnimal;
  final double totalFeed;
  final String uom;
  final double unitPerAnimal;
  final double totalCost;
  final double costPerAnimal;
  final String monitoringStatus;
  final String notes;
  final int detailsCount;
  final List<FeedMonitoringDetail> details;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeedMonitoring({
    required this.id,
    required this.monitoringCode,
    required this.monitoringDate,
    required this.employeeId,
    required this.employeeName,
    required this.farmLocationId,
    required this.farmLocationName,
    required this.farmAreaId,
    required this.farmAreaName,
    required this.totalAnimal,
    required this.totalFeed,
    required this.uom,
    required this.unitPerAnimal,
    required this.totalCost,
    required this.costPerAnimal,
    required this.monitoringStatus,
    required this.notes,
    required this.detailsCount,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
  });

  String get dateLabel {
    return '${monitoringDate.day} ${monthName(monitoringDate.month)} ${monitoringDate.year}';
  }

  factory FeedMonitoring.fromJson(Map<String, dynamic> json) {
    final rawDetails = json['details'] as List? ?? [];
    return FeedMonitoring(
      id: json['id'] ?? 0,
      monitoringCode: json['monitoring_code'] ?? '',
      monitoringDate: DateTime.tryParse(json['monitoring_date'] ?? '') ?? DateTime.now(),
      employeeId: json['employee_id'] ?? 0,
      employeeName: json['employee_name'] ?? '',
      farmLocationId: json['farm_location_id'] ?? 0,
      farmLocationName: json['farm_location_name'] ?? '',
      farmAreaId: json['farm_area_id'] ?? 0,
      farmAreaName: json['farm_area_name'] ?? '',
      totalAnimal: int.tryParse(json['total_animal']?.toString() ?? '') ?? 0,
      totalFeed: double.tryParse(json['total_feed']?.toString() ?? '') ?? 0.0,
      uom: json['uom'] ?? '',
      unitPerAnimal: double.tryParse(json['unit_per_animal']?.toString() ?? '') ?? 0.0,
      totalCost: double.tryParse(json['total_cost']?.toString() ?? '') ?? 0.0,
      costPerAnimal: double.tryParse(json['cost_per_animal']?.toString() ?? '') ?? 0.0,
      monitoringStatus: json['monitoring_status'] ?? '',
      notes: json['notes'] ?? '',
      detailsCount: json['details_count'] ?? 0,
      details: rawDetails
          .map((e) => FeedMonitoringDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
