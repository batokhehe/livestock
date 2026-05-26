class MonitoringTypeItemModel {
  final String name;
  final String code;
  final int quantity;
  final String uom;
  final int price;

  MonitoringTypeItemModel({
    required this.name,
    required this.code,
    required this.quantity,
    this.uom = '',
    this.price = 0,
  });

  factory MonitoringTypeItemModel.fromJson(Map<String, dynamic> json) {
    return MonitoringTypeItemModel(
      name: json['item_name']?.toString() ?? json['feed_name']?.toString() ?? json['name']?.toString() ?? '',
      code: json['item_code']?.toString() ?? json['code']?.toString() ?? json['feed_code']?.toString() ?? '',
      quantity: num.tryParse(json['qty']?.toString() ?? json['quantity']?.toString() ?? json['stock']?.toString() ?? '0')?.toInt() ?? 0,
      uom: json['uom']?.toString() ?? '',
      price: num.tryParse(json['unit_price']?.toString() ?? json['price']?.toString() ?? json['standard_rate']?.toString() ?? '0')?.toInt() ?? 0,
    );
  }
}
