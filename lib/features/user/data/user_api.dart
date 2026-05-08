import 'package:dio/dio.dart';

class UserApi {
  final Dio dio;

  UserApi(this.dio);

  Future<Map<String, dynamic>?> current() async {
    final response = await dio.get('/auth/current');

    return response.data;
  }

  Future<Map<String, dynamic>?> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await dio.post(
      '/auth/change-password',
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );

    return response.data;
  }

  Future<Map<String, dynamic>?> changeProfile({
    required String columnType,
    required String newValue,
  }) async {
    final response = await dio.post(
      '/auth/change-profile',
      data: {
        'column_type': columnType,
        'new_value': newValue,
      },
    );

    return response.data;
  }
}
