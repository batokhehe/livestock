class MonitoringTypeItemModel {
  final String name;
  final String code;
  final int quantity;
  final String uom;

  MonitoringTypeItemModel({
    required this.name,
    required this.code,
    required this.quantity,
    this.uom = '',
  });

  factory MonitoringTypeItemModel.fromJson(Map<String, dynamic> json) {
    return MonitoringTypeItemModel(
      name: json['item_name'] ?? json['feed_name'] ?? json['name'] ?? '',
      code: json['item_code'] ?? json['code'] ?? json['feed_code'] ?? '',
      quantity: json['qty'] ?? json['quantity'] ?? json['stock'] ?? 0,
      uom: json['uom'] ?? '',
    );
  }
}
