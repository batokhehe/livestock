import 'package:dio/dio.dart';
import 'app_exception.dart';

class ErrorParser {
  static AppException parse(dynamic error) {
    if (error is AppException) return error;

    if (error is DioException) {
      if (error.error is AppException) return error.error as AppException;

      final data = error.response?.data;

      if (data is Map) {
        final msg = data["message"] ?? data["Message"] ?? data["error"];
        if (msg != null) {
          return AppException(
            message: msg.toString(),
            code: error.response?.statusCode,
          );
        }
      }

      return AppException(
        message: _mapDioError(error),
        code: error.response?.statusCode,
      );
    }

    return AppException(
      message:
          "Terjadi kesalahan pada sistem. Silakan coba kembali nanti atau hubungi administrator",
    );
  }

  static String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return "Koneksi timeout. Periksa jaringan Anda.";

      case DioExceptionType.badResponse:
        return "Server mengirim response yang tidak valid.";

      case DioExceptionType.unknown:
        return "Tidak dapat menjangkau server. Periksa koneksi internet Anda.";

      default:
        return "Terjadi kesalahan tak terduga. Coba lagi nanti.";
    }
  }
}
