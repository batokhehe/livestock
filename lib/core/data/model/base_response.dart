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
    return BaseResponse<T>(
      status: json['status'],
      message: json['message'],
      totalRows: json['total_rows'],
      total: json['total'],
      data: (json['data'] as List).map((e) => fromJsonT(e)).toList(),
    );
  }
}
