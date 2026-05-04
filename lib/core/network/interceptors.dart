import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../errors/error_parser.dart';
import '../errors/unauthorized_exception.dart';

class ApiInterceptor extends Interceptor {
  final Ref ref;

  ApiInterceptor(this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final repo = ref.read(authRepositoryProvider);
    final token = await repo.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("ERROR TYPE: ${err.type}");
    print("ERROR MESSAGE: ${err.message}");
    print("STATUS CODE: ${err.response?.statusCode}");
    print("RESPONSE DATA: ${err.response?.data}");
    final appError = ErrorParser.parse(err);
    handler.reject(
      err.copyWith(error: appError.message),
    );
  }
}

class AuthInterceptor extends QueuedInterceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final path = err.requestOptions.path;

    if (err.response?.statusCode == 401) {
      print("AUTH_INTERCEPTOR: 401 Unauthorized caught at $path");
      
      if (path.contains('/login') || path.contains('/refresh')) {
        print("AUTH_INTERCEPTOR: 401 on login/refresh, logging out...");
        await ref.read(authRepositoryProvider).logout();
        ref.read(unauthorizedProvider.notifier).state = UnauthorizedException();
        return handler.next(err);
      }

      print("AUTH_INTERCEPTOR: Attempting token refresh...");
      final repo = ref.read(authRepositoryProvider);
      final isRefreshed = await repo.refreshToken();

      if (isRefreshed) {
        print("AUTH_INTERCEPTOR: Refresh success, retrying request...");
        final token = await repo.getToken();
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $token';

        final dio = ref.read(baseDioProvider);
        try {
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } on DioException catch (e) {
          print("AUTH_INTERCEPTOR: Retry failed: ${e.message}");
          return handler.next(e);
        }
      } else {
        print("AUTH_INTERCEPTOR: Refresh failed, logging out...");
        await repo.logout();
        ref.read(unauthorizedProvider.notifier).state = UnauthorizedException();
      }
    }

    super.onError(err, handler);
  }
}
