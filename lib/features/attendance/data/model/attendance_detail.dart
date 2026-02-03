class AttendanceDetail {
  final int employeeId;
  final String status;

  AttendanceDetail({required this.employeeId, required this.status});

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceDetail(
      employeeId: json['employee_id'],
      status: json['status'],
    );
  }

  bool get isPresent => status == 'present';
}
