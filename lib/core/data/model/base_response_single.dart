class BaseResponseSingle<T> {
  final int status;
  final String message;
  final int? totalRows;
  final T data;

  BaseResponseSingle({
    required this.status,
    required this.message,
    required this.data,
    this.totalRows,
  });

  factory BaseResponseSingle.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return BaseResponseSingle<T>(
      status: json['status'],
      message: json['message'],
      data: fromJsonT(json['data']),
    );
  }
}
