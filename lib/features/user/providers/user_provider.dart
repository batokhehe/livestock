import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/user_model.dart';
import 'user_repository_provider.dart';

final userProvider = FutureProvider<UserModel?>((ref) async {
  return ref.read(userRepositoryProvider).getUser();
});

// final userIdProvider = Provider<int>((ref) {
//   final user = ref.watch(userProvider).value;
//   return user?.id ?? "..";
// });

final userNameProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider).value;
  return user?.name ?? "..";
});

final userRoleProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider).value;
  final role = user?.roleName ?? "..";
  if (role.isEmpty || role == "..") return role;
  return role[0].toUpperCase() + role.substring(1).toLowerCase();
});

final userEmailProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider).value;
  return user?.email ?? "";
});

final userFarmProvider = Provider<int>((ref) {
  final user = ref.watch(userProvider).value;
  return user?.farmLocationId ?? 0;
});

final userPhoneProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider).value;
  return user?.phone ?? "";
});

final profilePageInitProvider = FutureProvider.autoDispose<void>((ref) async {
  await ref.read(userRepositoryProvider).fetchUserFromApi();
  ref.invalidate(userProvider);
});
