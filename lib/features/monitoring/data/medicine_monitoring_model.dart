import '../../../core/data/model/feed_medicine_model.dart';
import '../../../core/helpers/utils.dart';
import '../../attendance/data/model/employee_model.dart';

class MedicineMonitoringDetail {
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

  MedicineMonitoringDetail({
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

  factory MedicineMonitoringDetail.fromJson(Map<String, dynamic> json) {
    final quantityParsed = double.tryParse(json['quantity']?.toString() ?? '') ?? 0.0;

    final unitPriceParsed = double.tryParse(
      json['unit_price']?.toString() ?? 
      json['price']?.toString() ?? 
      json['unit_cost']?.toString() ?? 
      json['cost']?.toString() ??
      json['feed_medicine_price']?.toString() ??
      json['feed_medicine_cost']?.toString() ??
      json['medicine_price']?.toString() ??
      json['medicine_cost']?.toString() ??
      json['feed_medicine']?['price']?.toString() ??
      json['feed_medicine']?['unit_price']?.toString() ??
      json['feed_medicine']?['standard_rate']?.toString() ??
      json['feed_medicine']?['unit_cost']?.toString() ??
      json['medicine']?['price']?.toString() ??
      json['medicine']?['unit_price']?.toString() ??
      json['medicine']?['standard_rate']?.toString() ??
      json['medicine']?['unit_cost']?.toString() ??
      ''
    ) ?? 0.0;

    final totalParsed = double.tryParse(
      json['total']?.toString() ?? 
      json['total_price']?.toString() ?? 
      json['total_cost']?.toString() ?? 
      json['subtotal']?.toString() ??
      ''
    ) ?? (unitPriceParsed * quantityParsed);

    return MedicineMonitoringDetail(
      id: json['id'] ?? 0,
      healthMonitoringId: json['health_monitoring_id'] ?? 0,
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

class MedicineMonitoring {
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
  final Employee? employee;
  final List<MedicineMonitoringDetail> details;

  MedicineMonitoring({
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
    this.employee,
    required this.details,
  });

  String get dateLabel {
    return '${monitoringDate.day} ${monthName(monitoringDate.month)} ${monitoringDate.year}';
  }

  factory MedicineMonitoring.fromJson(Map<String, dynamic> json) {
    final rawDetails = json['details'] as List? ?? [];
    final detailsList = rawDetails
        .map((e) => MedicineMonitoringDetail.fromJson(e as Map<String, dynamic>))
        .toList();

    final totalCostParsed = double.tryParse(
      json['total_cost']?.toString() ?? 
      json['total_price']?.toString() ?? 
      json['total_amount']?.toString() ??
      ''
    ) ?? detailsList.fold<double>(0.0, (sum, item) => sum + item.total);

    return MedicineMonitoring(
      id: json['id'] ?? 0,
      monitoringCode: json['monitoring_code'] ?? '',
      monitoringDate: DateTime.tryParse(json['monitoring_date'] ?? '') ?? DateTime.now(),
      monitoringStatus: json['monitoring_status'] ?? '',
      farmLocationId: json['farm_location_id'] ?? 0,
      farmAreaId: json['farm_area_id'] ?? 0,
      unitPerAnimal: double.tryParse(json['unit_per_animal']?.toString() ?? '') ?? 0.0,
      totalCost: totalCostParsed,
      costPerAnimal: double.tryParse(json['cost_per_animal']?.toString() ?? '') ?? 0.0,
      notes: json['notes'],
      totalMedicine: double.tryParse(json['total_medicine']?.toString() ?? '') ?? 0.0,
      totalAnimal: double.tryParse(json['total_animal']?.toString() ?? '') ?? 0.0,
      employeeId: json['employee_id'] ?? 0,
      detailsCount: json['details_count'] ?? detailsList.length,
      farmLocationName: json['farm_location_name'] ?? '',
      farmAreaName: json['farm_area_name'] ?? '',
      employeeName: json['employee_name'] ?? '',
      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
      details: detailsList,
    );
  }
}
