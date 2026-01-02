import 'package:dio/dio.dart';

import '../../../../core/data/model/base_response.dart';
import '../model/employee_model.dart';

class EmployeeApi {
  final Dio dio;

  EmployeeApi(this.dio);

  Future<BaseResponse<Employee>> getEmployees() async {
    final res = await dio.get('/attendance/employee-list');

    return BaseResponse.fromJson(res.data, (json) => Employee.fromJson(json));
  }

  Future<void> submitAttendance(Map<String, dynamic> body) async {
    await dio.post('/attendance', data: body);
  }
}
