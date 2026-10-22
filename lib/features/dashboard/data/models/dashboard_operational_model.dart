class DashboardOperationalModel {
  final int totalDispatch;
  final int totalDispatchReady;
  final int totalDispatchInTransit;
  final int totalDispatchDelivered;
  final int totalAnimalReceived;
  final int totalFeedMedicineReceived;
  final int totalEquipmentSuppliesReceived;

  DashboardOperationalModel({
    required this.totalDispatch,
    required this.totalDispatchReady,
    required this.totalDispatchInTransit,
    required this.totalDispatchDelivered,
    required this.totalAnimalReceived,
    required this.totalFeedMedicineReceived,
    required this.totalEquipmentSuppliesReceived,
  });

  factory DashboardOperationalModel.fromJson(Map<String, dynamic> json) {
    return DashboardOperationalModel(
      totalDispatch: json['totalDispatch'] ?? 0,
      totalDispatchReady: json['totalDispatchReady'] ?? 0,
      totalDispatchInTransit: json['totalDispatchInTransit'] ?? 0,
      totalDispatchDelivered: json['totalDispatchDelivered'] ?? 0,
      totalAnimalReceived: json['totalAnimalReceived'] ?? 0,
      totalFeedMedicineReceived: json['totalFeedMedicineReceived'] ?? 0,
      totalEquipmentSuppliesReceived: json['totalEquipmentSuppliesReceived'] ?? 0,
    );
  }
}
