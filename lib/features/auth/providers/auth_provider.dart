import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../data/auth_api.dart';
import '../data/auth_repository.dart';
import '../domain/login_usecase.dart';
import 'login_viewmodel.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.read(baseDioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(authApiProvider), ref);
});

final authStateProvider = StateProvider<bool?>((ref) => null);

final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final loginViewModelProvider =
StateNotifierProvider<LoginViewModel, AsyncValue<void>>((ref) {
  final useCase = ref.watch(loginUseCaseProvider);
  return LoginViewModel(useCase, ref);
});

final logoutProvider = Provider((ref) {
  return () async {
    await ref.read(authRepositoryProvider).logout();
    ref.read(authStateProvider.notifier).state = false;
    return true;
  };
});
