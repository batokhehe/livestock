import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_parser.dart';
import '../../user/providers/user_provider.dart';
import '../domain/login_usecase.dart';
import 'auth_provider.dart';

class LoginViewModel extends StateNotifier<AsyncValue<void>> {
  final LoginUseCase loginUseCase;
  final Ref ref;

  LoginViewModel(this.loginUseCase, this.ref)
      : super(const AsyncValue.data(null));

  Future<void> login(String email, String pass) async {
    state = const AsyncValue.loading();

    try {
      final success = await loginUseCase(email, pass);

      if (!success) {
        state = AsyncValue.error(
          AppException(message: "Email atau password salah"),
          StackTrace.current,
        );
        return;
      }
      ref.read(authStateProvider.notifier).state = true;
      ref.invalidate(userProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      final err = ErrorParser.parse(e);
      state = AsyncValue.error(err, st);
    }
  }
}
