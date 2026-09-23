class DashboardMonitoringModel {
  final FeedMonitoring feedMonitoring;
  final WeightMonitoring weightMonitoring;
  final HealthMonitoring healthMonitoring;

  DashboardMonitoringModel({
    required this.feedMonitoring,
    required this.weightMonitoring,
    required this.healthMonitoring,
  });

  factory DashboardMonitoringModel.fromJson(Map<String, dynamic> json) {
    return DashboardMonitoringModel(
      feedMonitoring: FeedMonitoring.fromJson(json['feedMonitoring'] ?? {}),
      weightMonitoring: WeightMonitoring.fromJson(json['weightMonitoring'] ?? {}),
      healthMonitoring: HealthMonitoring.fromJson(json['healthMonitoring'] ?? {}),
    );
  }
}

class FeedMonitoring {
  final int totalData;
  final num totalCost;
  final String? lastMonitoringDate;
  final String? lastFarmLocation;

  FeedMonitoring({
    required this.totalData,
    required this.totalCost,
    this.lastMonitoringDate,
    this.lastFarmLocation,
  });

  factory FeedMonitoring.fromJson(Map<String, dynamic> json) {
    return FeedMonitoring(
      totalData: json['totalData'] ?? 0,
      totalCost: json['totalCost'] ?? 0,
      lastMonitoringDate: json['lastMonitoringDate'],
      lastFarmLocation: json['lastFarmLocation'],
    );
  }
}

class WeightMonitoring {
  final int totalData;
  final int totalAnimal;
  final String? lastMonitoringDate;
  final num averageADG;

  WeightMonitoring({
    required this.totalData,
    required this.totalAnimal,
    this.lastMonitoringDate,
    required this.averageADG,
  });

  factory WeightMonitoring.fromJson(Map<String, dynamic> json) {
    return WeightMonitoring(
      totalData: json['totalData'] ?? 0,
      totalAnimal: json['totalAnimal'] ?? 0,
      lastMonitoringDate: json['lastMonitoringDate'],
      averageADG: json['averageADG'] ?? 0,
    );
  }
}

class HealthMonitoring {
  final int totalData;
  final num totalCost;
  final String? lastMonitoringDate;
  final String? lastFarmLocation;

  HealthMonitoring({
    required this.totalData,
    required this.totalCost,
    this.lastMonitoringDate,
    this.lastFarmLocation,
  });

  factory HealthMonitoring.fromJson(Map<String, dynamic> json) {
    return HealthMonitoring(
      totalData: json['totalData'] ?? 0,
      totalCost: json['totalCost'] ?? 0,
      lastMonitoringDate: json['lastMonitoringDate'],
      lastFarmLocation: json['lastFarmLocation'],
    );
  }
}
