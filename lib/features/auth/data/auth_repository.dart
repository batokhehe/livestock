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

  static const _keyToken = "token";

  Future<bool> login(String email, String pass) async {
    try {
      final res = await api.login(email, pass);

      final token = res.accessToken;
      final userData = res.user;

      await storage.write(key: _keyToken, value: token);
      await ref.read(userRepositoryProvider).saveUser(userData);

      return true;
    } catch (e) {
      print('error repo: $e');
      throw ErrorParser.parse(e);
    }
  }

  Future<String?> getToken() async => await storage.read(key: _keyToken);

  Future<bool> isLoggedIn() async => (await getToken()) != null;

  Future<void> logout() async {
    await storage.delete(key: _keyToken);
    await ref.read(userRepositoryProvider).clearUser();
  }
}
