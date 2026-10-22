class StockInventoryItem {
  final int itemId;
  final String itemCode;
  final String itemName;
  final String itemType;
  final num openingQty;
  final num incomingQty;
  final num outgoingQty;
  final num endingQty;
  final String uom;
  final int? farmLocationId;
  final String? farmLocationName;
  final String? stockStatusLabel;

  StockInventoryItem({
    required this.itemId,
    required this.itemCode,
    required this.itemName,
    required this.itemType,
    required this.openingQty,
    required this.incomingQty,
    required this.outgoingQty,
    required this.endingQty,
    required this.uom,
    this.farmLocationId,
    this.farmLocationName,
    this.stockStatusLabel,
  });

  factory StockInventoryItem.fromJson(Map<String, dynamic> json) {
    return StockInventoryItem(
      itemId: json['item_id'] ?? 0,
      itemCode: json['item_code']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      itemType: json['item_type']?.toString() ?? '',
      openingQty: num.tryParse(json['opening_qty']?.toString() ?? '0') ?? 0,
      incomingQty: num.tryParse(json['incoming_qty']?.toString() ?? '0') ?? 0,
      outgoingQty: num.tryParse(json['outgoing_qty']?.toString() ?? '0') ?? 0,
      endingQty: num.tryParse(json['ending_qty']?.toString() ?? '0') ?? 0,
      uom: json['uom']?.toString() ?? '',
      farmLocationId: json['farm_location_id'],
      farmLocationName: json['farm_location_name']?.toString(),
      stockStatusLabel: json['stock_status_label']?.toString(),
    );
  }
}

class StockInventorySummary {
  final int totalItems;
  final num totalOpening;
  final num totalIncoming;
  final num totalOutgoing;

  StockInventorySummary({
    this.totalItems = 0,
    this.totalOpening = 0,
    this.totalIncoming = 0,
    this.totalOutgoing = 0,
  });

  factory StockInventorySummary.fromJson(Map<String, dynamic> json) {
    return StockInventorySummary(
      totalItems: json['total_items'] ?? 0,
      totalOpening: num.tryParse(json['total_opening']?.toString() ?? '0') ?? 0,
      totalIncoming:
          num.tryParse(json['total_incoming']?.toString() ?? '0') ?? 0,
      totalOutgoing:
          num.tryParse(json['total_outgoing']?.toString() ?? '0') ?? 0,
    );
  }
}

class StockInventoryResponse {
  final bool success;
  final List<StockInventoryItem> data;
  final StockInventorySummary? summary;

  StockInventoryResponse({
    required this.success,
    required this.data,
    this.summary,
  });

  factory StockInventoryResponse.fromJson(Map<String, dynamic> json) {
    return StockInventoryResponse(
      success: json['success'] ?? true,
      data: (json['data'] as List? ?? [])
          .map((e) => StockInventoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] != null
          ? StockInventorySummary.fromJson(
              json['summary'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
