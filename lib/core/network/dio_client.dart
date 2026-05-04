import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'interceptors.dart';

final baseDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: "https://dev.livestock.seavihive.com/api",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      responseType: ResponseType.json,
    ),
  )..interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
});

final dioProvider = Provider<Dio>((ref) {
  final dio = ref.read(baseDioProvider);

  final authenticatedDio = Dio(dio.options);
  authenticatedDio.interceptors.addAll(dio.interceptors);
  authenticatedDio.interceptors.add(ChuckerDioInterceptor());
  authenticatedDio.interceptors.add(AuthInterceptor(ref));
  authenticatedDio.interceptors.add(ApiInterceptor(ref));

  return authenticatedDio;
});
