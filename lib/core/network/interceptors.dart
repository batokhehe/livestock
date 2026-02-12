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
      DioException(requestOptions: err.requestOptions, error: appError.message),
    );
  }
}

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final path = err.requestOptions.path;
    if (path.contains('/login')) {
      handler.next(err);
      return;
    }
    if (err.response?.statusCode == 401) {
      ref.read(unauthorizedProvider.notifier).state = UnauthorizedException();
    }
    super.onError(err, handler);
  }
}
