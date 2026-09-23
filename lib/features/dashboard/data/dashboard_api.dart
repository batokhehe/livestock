import 'package:dio/dio.dart';
import 'package:livestock/features/dashboard/data/models/dashboard_monitoring_model.dart';
import 'package:livestock/features/dashboard/data/models/dashboard_operational_model.dart';
import 'package:livestock/features/dashboard/data/models/dashboard_sales_model.dart';

class DashboardApi {
  final Dio dio;

  DashboardApi(this.dio);

  Future<DashboardSalesModel> getDashboardSales() async {
    final res = await dio.get('/dashboard/sales');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    final data = res.data;
    return DashboardSalesModel.fromJson(data['data']);
  }

  Future<DashboardOperationalModel> getDashboardOperational() async {
    final res = await dio.get('/dashboard/operational');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    final data = res.data;
    return DashboardOperationalModel.fromJson(data['data']);
  }

  Future<DashboardMonitoringModel> getDashboardMonitoring() async {
    final res = await dio.get('/dashboard/monitoring');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    final data = res.data;
    return DashboardMonitoringModel.fromJson(data['data']);
  }
}
