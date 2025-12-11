import 'package:dio/dio.dart';

class UserApi {
  final Dio dio;

  UserApi(this.dio);

  Future<Map<String, dynamic>?> current() async {
    final response = await dio.get('/auth/current');

    return response.data;
  }
}
