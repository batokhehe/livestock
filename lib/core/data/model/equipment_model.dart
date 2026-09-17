class Equipment {
  final int id;
  final String name;
  final String code;
  final String? description;
  final String? uom;
  final double? price;

  Equipment({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.uom,
    this.price,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ??
              json['equipment_name'] ??
              json['equipment_supply_name'] ??
              json['item_name'] ??
              '')
          .toString(),
      code: (json['code'] ??
              json['equipment_code'] ??
              json['equipment_supply_code'] ??
              json['item_code'] ??
              '')
          .toString(),
      description: json['description']?.toString(),
      uom: json['uom']?.toString(),
      price: double.tryParse((json['price'] ?? json['cost_price'] ?? json['purch_price'] ?? '').toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      if (description != null) 'description': description,
      if (uom != null) 'uom': uom,
      if (price != null) 'price': price,
    };
  }
}
