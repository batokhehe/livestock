import 'package:dio/dio.dart';
import 'package:livestock/features/auth/data/model/login_response.dart';
import 'package:livestock/features/auth/data/model/refresh_token_response.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<LoginResponse> login(String email, String pass) async {
    final response = await dio.post(
      '/auth/login',
      data: {"email": email, "password": pass, "platform": "mobile"},
    );
    return LoginResponse.fromJson(response.data);
  }

  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    final response = await dio.post(
      '/auth/refresh',
      data: {"refresh_token": refreshToken},
    );
    return RefreshTokenResponse.fromJson(response.data);
  }
}

