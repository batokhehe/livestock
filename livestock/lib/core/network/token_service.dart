import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final Dio dio;
  final FlutterSecureStorage storage;

  TokenService(this.dio, this.storage);

  Future<String?> accessToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<bool> tryRefresh() async {
    final refresh = await storage.read(key: 'refresh_token');
    if (refresh == null) return false;
    try {
      final resp = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refresh},
      );
      final newAccess = resp.data['access_token'] as String?;
      final newRefresh = resp.data['refresh_token'] as String?;
      if (newAccess != null)
        await storage.write(key: 'access_token', value: newAccess);
      if (newRefresh != null)
        await storage.write(key: 'refresh_token', value: newRefresh);
      return newAccess != null;
    } catch (e) {
      return false;
    }
  }
}
