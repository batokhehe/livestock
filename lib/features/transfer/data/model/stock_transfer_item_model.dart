import 'package:livestock/core/data/model/farm_location_model.dart';

class StockTransferItem {
  final int id;
  final String itemCode;
  final String itemName;
  final double qty;
  final int farmLocationId;
  final String farmLocationName;
  final String? farmAreaName;
  final double costPrice;
  final String? uom;
  final FarmLocation? farmLocation;

  StockTransferItem({
    required this.id,
    required this.itemCode,
    required this.itemName,
    required this.qty,
    required this.farmLocationId,
    required this.farmLocationName,
    this.farmAreaName,
    required this.costPrice,
    this.uom,
    this.farmLocation,
  });

  factory StockTransferItem.fromJson(Map<String, dynamic> json) {
    return StockTransferItem(
      id: json['id'] ?? 0,
      itemCode: json['item_code'] ?? '',
      itemName: json['item_name'] ?? json['feed_medicine_name'] ?? json['equipment_supply_name'] ?? '',
      qty: (json['qty'] ?? json['quantity'] ?? 0).toDouble(),
      farmLocationId: json['farm_location_id'] ?? 0,
      farmLocationName: json['farm_location_name'] ?? json['farm_location']?['name'] ?? '',
      farmAreaName: json['farm_area_name'] ?? json['farm_area']?['name'] ?? json['farm_area']?['area_name'],
      costPrice: (json['cost_price'] ?? json['price'] ?? 0).toDouble(),
      uom: json['uom'],
      farmLocation: json['farm_location'] != null
          ? FarmLocation.fromJson(json['farm_location'])
          : null,
    );
  }
}
