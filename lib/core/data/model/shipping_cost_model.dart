class ShippingCost {
  final int id;
  final String shippingCostId;
  final String state;
  final String stateId;
  final String city;
  final String cityId;
  final int farmLocationId;
  final String farmLocationName;
  final double price;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  ShippingCost({
    required this.id,
    required this.shippingCostId,
    required this.state,
    required this.stateId,
    required this.city,
    required this.cityId,
    required this.farmLocationId,
    required this.farmLocationName,
    required this.price,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ShippingCost.fromJson(Map<String, dynamic> json) {
    return ShippingCost(
      id: json['id'],
      shippingCostId: json['shipping_cost_id'],
      state: json['state'],
      stateId: json['state_id'],
      city: json['city'],
      cityId: json['city_id'],
      farmLocationId: json['farm_location_id'],
      farmLocationName: json['farm_location_name'],
      price: json['price']?.toDouble() ?? 0.0,
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "shipping_cost_id": shippingCostId,
      "state": state,
      "state_id": stateId,
      "city": city,
      "city_id": cityId,
      "farm_location_id": farmLocationId,
      "farm_location_name": farmLocationName,
      "price": price,
      "description": description,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "deleted_at": deletedAt?.toIso8601String(),
    };
  }
}
