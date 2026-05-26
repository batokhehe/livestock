import '../../../core/helpers/utils.dart';
import '../../../core/data/model/animal_profile_model.dart';

class WeightMonitoringEmployee {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String position;
  final String status;
  final String? farmLocationName;

  WeightMonitoringEmployee({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.position,
    required this.status,
    this.farmLocationName,
  });

  factory WeightMonitoringEmployee.fromJson(Map<String, dynamic> json) {
    return WeightMonitoringEmployee(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone_number'] ?? '',
      position: json['position'] ?? '',
      status: json['employee_status'] ?? '',
      farmLocationName: json['farm_location_name'],
    );
  }
}

class WeightMonitoringDetail {
  final int id;
  final int animalProfileId;
  final double initialWeight;
  final double finalWeight;
  final double diffWeight;
  final double adg;
  final String? notes;
  final int differentDays;
  final bool isAdgMet;
  final String animalName;
  final String animalCode;
  final String inventoryDate;
  final AnimalProfile? animalProfile;

  WeightMonitoringDetail({
    required this.id,
    required this.animalProfileId,
    required this.initialWeight,
    required this.finalWeight,
    required this.diffWeight,
    required this.adg,
    this.notes,
    required this.differentDays,
    required this.isAdgMet,
    required this.animalName,
    required this.animalCode,
    required this.inventoryDate,
    this.animalProfile,
  });

  factory WeightMonitoringDetail.fromJson(Map<String, dynamic> json) {
    final profile = json['animal_profile'] as Map<String, dynamic>?;
    return WeightMonitoringDetail(
      id: json['id'] ?? 0,
      animalProfileId: json['animal_profile_id'] ?? 0,
      initialWeight: double.tryParse(json['initial_weight']?.toString() ?? '') ?? 0,
      finalWeight: double.tryParse(json['final_weight']?.toString() ?? '') ?? 0,
      diffWeight: double.tryParse(json['diff_weight']?.toString() ?? '') ?? 0,
      adg: double.tryParse(json['adg']?.toString() ?? '') ?? 0,
      notes: json['notes'],
      differentDays: json['different_days'] ?? 0,
      isAdgMet: json['is_adg_met'] == true,
      animalName: profile?['name'] ?? '',
      animalCode: profile?['animal_code'] ?? '',
      inventoryDate: profile?['inventory_date'] ?? profile?['received_date'] ?? '-',
      animalProfile: profile != null ? AnimalProfile.fromJson(profile) : null,
    );
  }
}

class WeightMonitoring {
  final int id;
  final String monitoringCode;
  final String monitoringDate;
  final String monitoringStatus;
  final String? notes;
  final String employeeName;
  final WeightMonitoringEmployee? employee;
  final int detailsCount;
  final List<WeightMonitoringDetail> details;
  final String? formattedMonitoringDate;

  WeightMonitoring({
    required this.id,
    required this.monitoringCode,
    required this.monitoringDate,
    required this.monitoringStatus,
    this.notes,
    required this.employeeName,
    this.employee,
    required this.detailsCount,
    required this.details,
    this.formattedMonitoringDate,
  });

  int get animalCount => detailsCount;

  String get dateLabel {
    final parsed = DateTime.tryParse(monitoringDate);
    if (parsed == null) return monitoringDate;
    return '${parsed.day} ${monthName(parsed.month)} ${parsed.year}';
  }

  factory WeightMonitoring.fromJson(Map<String, dynamic> json) {
    final rawDetails = json['details'] as List? ?? [];
    final rawEmployee = json['employee'] as Map<String, dynamic>?;

    return WeightMonitoring(
      id: json['id'] ?? 0,
      monitoringCode: json['monitoring_code'] ?? '',
      monitoringDate: json['monitoring_date'] ?? '',
      monitoringStatus: json['monitoring_status'] ?? '',
      notes: json['notes'],
      employeeName: json['employee_name'] ?? '',
      employee: rawEmployee != null
          ? WeightMonitoringEmployee.fromJson(rawEmployee)
          : null,
      detailsCount: json['details_count'] ?? 0,
      details: rawDetails
          .map((e) => WeightMonitoringDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      formattedMonitoringDate: json['formatted_monitoring_date'],
    );
  }
}
