import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_model.dart';
import '../domain/vehicle_model.dart';
import 'user_repository_provider.dart';

final userProvider = FutureProvider<UserModel?>((ref) async {
  return ref.read(userRepositoryProvider).getUser();
});

final userNameProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider).value;
  return user?.name ?? "..";
});

final userEmailProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider).value;
  return user?.email ?? "..";
});
