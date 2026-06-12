class StockTransferDetail {
  final int id;
  final String transferCode;
  final String transferDate;
  final int fromFarmLocationId;
  final int toFarmLocationId;
  final dynamic itemId;
  final String itemCode;
  final String itemName;
  final String itemType;
  final String qty;
  final String? notes;
  final String? shippingCost;
  final StockTransferLocationDetail fromFarmLocation;
  final StockTransferLocationDetail toFarmLocation;
  final StockTransferLocationDetail? item;
  final String createdBy;
  final String createdAt;

  StockTransferDetail({
    required this.id,
    required this.transferCode,
    required this.transferDate,
    required this.fromFarmLocationId,
    required this.toFarmLocationId,
    required this.itemId,
    required this.itemCode,
    required this.itemName,
    required this.itemType,
    required this.qty,
    this.notes,
    this.shippingCost,
    required this.fromFarmLocation,
    required this.toFarmLocation,
    this.item,
    required this.createdBy,
    required this.createdAt,
  });

  factory StockTransferDetail.fromJson(Map<String, dynamic> json) {
    return StockTransferDetail(
      id: json['id'] ?? 0,
      transferCode: json['transfer_code'] ?? '',
      transferDate: json['transfer_date'] ?? '',
      fromFarmLocationId: json['from_farm_location_id'] ?? 0,
      toFarmLocationId: json['to_farm_location_id'] ?? 0,
      itemId: json['item_id'],
      itemCode: json['item_code'] ?? '',
      itemName: json['item_name'] ?? '',
      itemType: json['item_type'] ?? '',
      qty: json['qty']?.toString() ?? '0',
      notes: json['notes'],
      shippingCost: json['shipping_cost']?.toString(),
      fromFarmLocation: StockTransferLocationDetail.fromJson(json['from_farm_location'] ?? {}),
      toFarmLocation: StockTransferLocationDetail.fromJson(json['to_farm_location'] ?? {}),
      item: json['item'] != null ? StockTransferLocationDetail.fromJson(json['item']) : null,
      createdBy: json['created_by'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class StockTransferLocationDetail {
  final int id;
  final String name;

  StockTransferLocationDetail({required this.id, required this.name});

  factory StockTransferLocationDetail.fromJson(Map<String, dynamic> json) {
    return StockTransferLocationDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
