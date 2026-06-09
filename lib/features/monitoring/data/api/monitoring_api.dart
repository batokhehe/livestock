import 'package:dio/dio.dart';
import 'package:livestock/core/data/model/base_response.dart';
import 'package:livestock/features/monitoring/data/weight_monitoring_model.dart';
import 'package:livestock/features/monitoring/data/feed_monitoring_model.dart';
import 'package:livestock/features/monitoring/data/health_monitoring_model.dart';
import 'package:livestock/features/monitoring/data/animal_health_check_model.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';

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
    String status = 'confirmed',
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

  Future<void> submitHealthMonitoring({
    required DateTime monitoringDate,
    required int employeeId,
    required int farmLocationId,
    required int farmAreaId,
    required List<Map<String, dynamic>> items,
    String status = 'confirmed',
    String notes = '',
  }) async {
    final payload = <String, dynamic>{
      'monitoring_date': monitoringDate.toIso8601String().split('T').first,
      'employee_id': employeeId,
      'farm_location_id': farmLocationId,
      'farm_area_id': farmAreaId,
      'monitoring_status': status,
      'notes': notes,
      'items': items,
    };

    await dio.post(
      '/monitoring/health-monitoring',
      data: payload,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<void> submitFeedMonitoring({
    required DateTime monitoringDate,
    required int employeeId,
    required int farmLocationId,
    required int farmAreaId,
    required String uom,
    required int totalAnimal,
    required int totalFeed,
    required int totalCost,
    required List<Map<String, dynamic>> items,
    String status = 'confirmed',
    String notes = '',
  }) async {
    final payload = <String, dynamic>{
      'monitoring_date': monitoringDate.toIso8601String().split('T').first,
      'employee_id': employeeId,
      'farm_location_id': farmLocationId,
      'farm_area_id': farmAreaId,
      'monitoring_status': status,
      'uom': uom,
      'total_animal': totalAnimal,
      'total_feed': totalFeed,
      'total_cost': totalCost,
      'notes': notes,
      'items': items,
    };

    await dio.post(
      '/monitoring/feed-monitoring',
      data: payload,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<void> updateWeightMonitoring({
    required int id,
    required DateTime monitoringDate,
    required int employeeId,
    required List<Map<String, dynamic>> items,
    String status = 'confirmed',
    String notes = '',
  }) async {
    final payload = <String, dynamic>{
      'monitoring_date': monitoringDate.toIso8601String().split('T').first,
      'employee_id': employeeId,
      'monitoring_status': status,
      'notes': notes,
      'items': items,
    };

    await dio.put(
      '/monitoring/weight-monitoring/$id',
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

  Future<HealthMonitoring> getHealthMonitoringDetail(int id) async {
    final res = await dio.get('/monitoring/health-monitoring/$id');
    return HealthMonitoring.fromJson(res.data['data']);
  }

  Future<FeedMonitoring> getFeedMonitoringDetail(int id) async {
    final res = await dio.get('/monitoring/feed-monitoring/$id');
    return FeedMonitoring.fromJson(res.data['data']);
  }

  Future<BaseResponse<AnimalHealthCheck>> getAnimalHealthCheck({
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
      '/monitoring/animal-health-check',
      queryParameters: params,
    );

    return BaseResponse.fromJson(
      res.data,
      (json) => AnimalHealthCheck.fromJson(json),
    );
  }

  Future<AnimalHealthCheck> getAnimalHealthCheckDetail(int id) async {
    final res = await dio.get('/monitoring/animal-health-check/$id');
    return AnimalHealthCheck.fromJson(res.data['data']);
  }

  Future<BaseResponse<AnimalProfile>> getHealthCheckAnimals({
    required int farmLocationId,
    required int farmAreaId,
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'farm_location_id': farmLocationId,
      'farm_area_id': farmAreaId,
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final res = await dio.get(
      '/monitoring/animal-health-check/animals',
      queryParameters: params,
    );

    return BaseResponse.fromJson(
      res.data,
      (json) => AnimalProfile.fromJson(json),
    );
  }

  Future<void> submitAnimalHealthCheck({
    required DateTime monitoringDate,
    required int employeeId,
    required int farmLocationId,
    required int farmAreaId,
    required int animalId,
    required List<Map<String, dynamic>> items,
    String status = 'confirmed',
    String notes = '',
  }) async {
    final payload = <String, dynamic>{
      'check_date': monitoringDate.toIso8601String().split('T').first,
      'employee_id': employeeId,
      'farm_location_id': farmLocationId,
      'farm_area_id': farmAreaId,
      'animal_id': animalId,
      'check_status': status,
      'notes': notes,
      'items': items,
    };

    await dio.post(
      '/monitoring/animal-health-check',
      data: payload,
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}
