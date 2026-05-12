class AttendanceDetail {
  final int employeeId;
  final String status;
  final int? attendanceLogId;

  AttendanceDetail({
    required this.employeeId,
    required this.status,
    this.attendanceLogId,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceDetail(
      employeeId: json['employee_id'],
      status: json['status'],
      attendanceLogId: json['attendance_log_id'],
    );
  }

  bool get isPresent => status == 'present';
}
