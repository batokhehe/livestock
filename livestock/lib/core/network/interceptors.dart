import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../errors/error_parser.dart';

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
    print("🔥 DIO ERROR → ${err.message}");
    print("🔥 STATUS → ${err.response?.statusCode}");
    print("🔥 DATA → ${err.response?.data}");
    final appError = ErrorParser.parse(err);
    handler.reject(
      DioException(requestOptions: err.requestOptions, error: appError),
    );
  }
}
