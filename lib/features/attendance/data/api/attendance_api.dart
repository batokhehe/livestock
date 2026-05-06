import 'package:dio/dio.dart';

import '../../../../core/data/model/base_response.dart';
import '../model/attendance_detail.dart';
import '../model/employee_model.dart';

class AttendanceApi {
  final Dio dio;

  AttendanceApi(this.dio);

  Future<BaseResponse<Employee>> getEmployees() async {
    final res = await dio.get('/attendance/employee-list');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    return BaseResponse.fromJson(res.data, (json) => Employee.fromJson(json));
  }

  Future<void> submitAttendance(Map<String, dynamic> body) async {
    await dio.post('/attendance', data: body);
  }

  Future<Map<String, dynamic>> getAttendance({
    required String type,
    required String month,
    String? date,
    String? employeeName,
    int page = 1,
    int perPage = 10,
    String? search,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  }) async {
    final response = await dio.get(
      '/attendance',
      queryParameters: {
        'type': type,
        'month': month,
        if (date != null) 'date': date,
        if (employeeName != null && employeeName.isNotEmpty)
          'employee_name': employeeName,
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        'sort_by': sortBy,
        'sort_dir': sortDir,
      },
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getAttendanceDetail({
    required String type,
    required String transDate,
    required String attendanceLogId,
  }) async {
    final response = await dio.get(
      '/attendance/detail',
      queryParameters: {
        'type': type,
        'trans_date': transDate,
        'attendance_log_id': attendanceLogId,
      },
    );

    return response.data;
  }

  Future<List<AttendanceDetail>> getAttendanceEmployeeDetail({
    required String transDate,
  }) async {
    final res = await dio.get(
      '/attendance/detail',
      queryParameters: {'trans_date': transDate},
    );

    final List list = res.data['data'];

    return list.map((e) => AttendanceDetail.fromJson(e)).toList();
  }
}
