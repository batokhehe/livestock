import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/errors/error_parser.dart';
import '../../user/providers/user_repository_provider.dart';
import '../data/auth_api.dart';

class AuthRepository {
  final AuthApi api;
  final FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true, // Automatically handle encryption errors
    ),
  );
  final Ref ref;

  AuthRepository(this.api, this.ref);

  static const _keyToken = "access_token";
  static const _keyRefreshToken = "refresh_token";

  Future<bool> login(String email, String pass) async {
    try {
      final res = await api.login(email, pass);

      final token = res.accessToken;
      final refreshToken = res.refreshToken;
      final userData = res.user;

      await storage.write(key: _keyToken, value: token);
      await storage.write(key: _keyRefreshToken, value: refreshToken);
      await ref.read(userRepositoryProvider).saveUser(userData);

      return true;
    } catch (e) {
      print('error repo: $e');
      throw ErrorParser.parse(e);
    }
  }

  Future<String?> getToken() async => await storage.read(key: _keyToken);

  Future<String?> getRefreshToken() async =>
      await storage.read(key: _keyRefreshToken);

  Future<bool>? _refreshFuture;

  Future<bool> refreshToken() async {
    if (_refreshFuture != null) return _refreshFuture!;

    _refreshFuture = _doRefreshToken();
    try {
      return await _refreshFuture!;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<bool> _doRefreshToken() async {
    final refresh = await getRefreshToken();
    if (refresh == null) return false;

    try {
      final res = await api.refreshToken(refresh);
      await storage.write(key: _keyToken, value: res.accessToken);
      await storage.write(key: _keyRefreshToken, value: res.refreshToken);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isLoggedIn() async => (await getToken()) != null;

  Future<void> logout() async {
    await storage.delete(key: _keyToken);
    await storage.delete(key: _keyRefreshToken);
    await ref.read(userRepositoryProvider).clearUser();
  }
}
