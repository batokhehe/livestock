import 'package:livestock/features/receiving/data/model/receiving_detail_item_model.dart';

class ReceivingDetail {
  final int id;
  final String stockCode;
  final String receiveType;
  final String receiveStatus;
  final String receiveDate;
  final String formattedCreatedAt;
  final String createdBy;
  final String farmName;
  final String? farmAreaName;
  final String quantity;
  final String? remarks;
  final String? feedType;
  final List<ReceivingDetailItem> details;

  ReceivingDetail({
    required this.id,
    required this.stockCode,
    required this.receiveType,
    required this.receiveStatus,
    required this.receiveDate,
    required this.formattedCreatedAt,
    required this.createdBy,
    required this.farmName,
    this.farmAreaName,
    required this.quantity,
    this.remarks,
    this.feedType,
    required this.details,
  });

  factory ReceivingDetail.fromJson(Map<String, dynamic> json) {
    return ReceivingDetail(
      id: json['id'],
      stockCode: json['stock_code'] ?? '-',
      receiveType: json['receive_type'] ?? '-',
      receiveStatus: json['receive_status'] ?? '-',
      receiveDate: json['receive_date'] ?? '-',
      formattedCreatedAt: json['formatted_created_at'] ?? '-',
      createdBy: json['created_by'] ?? '-',
      farmName: json['farm_name'] ?? '-',
      farmAreaName: json['farm_area_name'],
      quantity: json['total_quantity']?.toString() ?? '0',
      remarks: json['remarks'],
      feedType: json['feed_type'],
      details: (json['details'] as List? ?? [])
          .map((e) => ReceivingDetailItem.fromJson(e))
          .toList(),
    );
  }
}
