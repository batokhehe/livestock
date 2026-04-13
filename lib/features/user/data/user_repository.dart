import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:livestock/features/user/data/user_api.dart';

import '../../../core/errors/error_parser.dart';
import '../domain/user_model.dart';

class UserRepository {
  final UserApi api;
  final storage = const FlutterSecureStorage();

  UserRepository(this.api);

  static const _keyUser = "user_profile";

  Future<void> saveUser(UserModel user) async {
    print(user.permissions);
    await storage.write(key: _keyUser, value: jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final jsonStr = await storage.read(key: _keyUser);
    if (jsonStr == null) return null;

    final data = jsonDecode(jsonStr);
    return UserModel.fromJson(data);
  }

  // Hapus user dari storage (logout)
  Future<void> clearUser() async {
    await storage.delete(key: _keyUser);
  }

  Future<void> fetchUserFromApi() async {
    try {
      final response = await api.current();
      final json = response?["data"];
      final user = UserModel.fromJson(json);

      await saveUser(user);
    } catch (e) {
      throw ErrorParser.parse(e);
    }
  }
}
