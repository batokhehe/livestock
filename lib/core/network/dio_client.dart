import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'interceptors.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      // baseUrl: "http://72.61.214.163:6621/api",
      // baseUrl: "http://72.61.214.163:6622/api",
      baseUrl: "https://dev.livestock.seavihive.com/api",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      responseType: ResponseType.json,
      validateStatus: (status) =>
          status != null && (status >= 200 && status < 300 || status == 401),
    ),
  );
  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
    ),
  );
  dio.interceptors.add(ChuckerDioInterceptor());
  dio.interceptors.add(ApiInterceptor(ref));
  dio.interceptors.add(AuthInterceptor(ref));

  return dio;
});
