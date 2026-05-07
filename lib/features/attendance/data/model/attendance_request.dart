class AttendanceRequest {
  final String type;
  final String month;
  final String? date;
  final String? employeeName;
  final int page;
  final int perPage;
  final String? search;
  final String sortBy;
  final String sortDir;

  final int? farmLocationId;
  final String? startDate;
  final String? endDate;

  AttendanceRequest({
    required this.type,
    required this.month,
    this.date,
    this.employeeName,
    this.page = 1,
    this.perPage = 10,
    this.search,
    this.sortBy = 'created_at',
    this.sortDir = 'desc',
    this.farmLocationId,
    this.startDate,
    this.endDate,
  });
}
