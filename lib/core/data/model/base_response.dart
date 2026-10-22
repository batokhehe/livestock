class BaseResponse<T> {
  final int status;
  final String message;
  final int? totalRows;
  final int? total;
  final List<T> data;

  BaseResponse({
    required this.status,
    required this.message,
    required this.data,
    this.totalRows,
    this.total,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    List rawList = [];
    int? total = json['total'] ?? json['total_rows'] ?? json['totalRows'] ?? json['meta']?['total'];
    int? totalRows = json['total_rows'] ?? json['total'] ?? json['totalRows'] ?? json['meta']?['total'];

    if (json['data'] is List) {
      rawList = json['data'] as List;
    } else if (json['data'] is Map && json['data']['data'] is List) {
      rawList = json['data']['data'] as List;
      total ??= json['data']['total'] ?? json['data']['total_rows'];
      totalRows ??= json['data']['total_rows'] ?? json['data']['total'];
    }

    return BaseResponse<T>(
      status: json['status'] is int
          ? json['status']
          : (json['success'] == true ? 200 : (int.tryParse(json['status']?.toString() ?? '200') ?? 200)),
      message: json['message']?.toString() ?? '',
      totalRows: totalRows,
      total: total,
      data: rawList.whereType<Map<String, dynamic>>().map((e) => fromJsonT(e)).toList(),
    );
  }
}
