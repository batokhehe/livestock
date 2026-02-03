class ReceivingList {
  final int id;
  final String stockCode;
  final String receiveType;
  final String receiveStatus;
  final String receiveDate;
  final String formattedReceiveDate;
  final String createdBy;
  final String locationName;
  final String? areaName;
  final String quantity;

  ReceivingList({
    required this.id,
    required this.stockCode,
    required this.receiveType,
    required this.receiveStatus,
    required this.receiveDate,
    required this.formattedReceiveDate,
    required this.createdBy,
    required this.locationName,
    this.areaName,
    required this.quantity,
  });

  factory ReceivingList.fromJson(Map<String, dynamic> json) {
    return ReceivingList(
      id: json['id'],
      stockCode: json['stock_code'] ?? '-',
      receiveType: json['receive_type'] ?? '-',
      receiveStatus: json['receive_status'] ?? '-',
      receiveDate: json['receive_date'] ?? '-',
      formattedReceiveDate: json['formatted_receive_date'] ?? '-',
      createdBy: json['created_by'] ?? '-',
      locationName: json['farm_location']?['name'] ?? '-',
      areaName: json['farm_area']?['area_name'],
      quantity: json['total_quantity']?.toString() ?? '0',
    );
  }

  String get dateLabel => formattedReceiveDate;
}
