import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_parser.dart';
import '../../user/domain/user_model.dart';
import '../../user/providers/user_repository_provider.dart';
import '../data/auth_api.dart';

class AuthRepository {
  final AuthApi api;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Ref ref;

  AuthRepository(this.api, this.ref);

  static const _keyToken = "token";

  Future<bool> login(String email, String pass) async {
    try {
      final res = await api.login(email, pass);

      final token = res?["token"];
      final userJson = res?["data"];

      if (token == null || userJson == null) {
        throw AppException(message: "Data login tidak lengkap dari server.");
      }

      await storage.write(key: _keyToken, value: token);

      final user = UserModel.fromJson(userJson);
      await ref.read(userRepositoryProvider).saveUser(user);

      return true;
    } catch (e) {
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
