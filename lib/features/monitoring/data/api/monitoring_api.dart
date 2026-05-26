import 'package:dio/dio.dart';
import 'package:livestock/core/data/model/base_response.dart';
import 'package:livestock/features/monitoring/data/weight_monitoring_model.dart';
import 'package:livestock/features/monitoring/data/feed_monitoring_model.dart';
import 'package:livestock/features/monitoring/data/health_monitoring_model.dart';

class MonitoringApi {
  final Dio dio;

  MonitoringApi(this.dio);

  Future<BaseResponse<WeightMonitoring>> getWeightMonitoring({
    int page = 1,
    int perPage = 10,
    String? search,
    String? type,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
      if (type != null && type.isNotEmpty) 'type': type,
    };

    final res = await dio.get(
      '/monitoring/weight-monitoring',
      queryParameters: params,
    );

    return BaseResponse.fromJson(
      res.data,
      (json) => WeightMonitoring.fromJson(json),
    );
  }

  Future<BaseResponse<FeedMonitoring>> getFeedMonitoring({
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final res = await dio.get(
      '/monitoring/feed-monitoring',
      queryParameters: params,
    );

    return BaseResponse.fromJson(
      res.data,
      (json) => FeedMonitoring.fromJson(json),
    );
  }

  Future<BaseResponse<HealthMonitoring>> getHealthMonitoring({
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final res = await dio.get(
      '/monitoring/health-monitoring',
      queryParameters: params,
    );

    return BaseResponse.fromJson(
      res.data,
      (json) => HealthMonitoring.fromJson(json),
    );
  }

  Future<void> submitWeightMonitoring({
    required DateTime monitoringDate,
    required int employeeId,
    required List<Map<String, dynamic>> items,
    String status = 'draft',
    String notes = '',
  }) async {
    final payload = <String, dynamic>{
      'monitoring_date': monitoringDate.toIso8601String().split('T').first,
      'employee_id': employeeId,
      'monitoring_status': status,
      'notes': notes,
      'items': items,
    };

    await dio.post(
      '/monitoring/weight-monitoring',
      data: payload,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<void> deleteWeightMonitoringDetails({required List<int> ids}) async {
    await dio.post(
      '/monitoring/weight-monitoring/bulk-delete',
      data: {'ids': ids},
    );
  }
}
