import 'package:dio/dio.dart';
import 'package:livestock/core/data/model/base_response_single.dart';
import 'package:livestock/features/sales_order/data/model/calculate_forecast_model.dart';

import '../model/sales_invoice_model.dart';
import '../model/sales_order_detail_model.dart';
import '../model/sales_order_list_model.dart';
import '../model/sales_order_request_model.dart';
import 'package:livestock/core/data/model/payment_type_model.dart';
import 'package:livestock/core/data/model/chart_of_account_model.dart';

class SalesOrderApi {
  final Dio dio;

  SalesOrderApi(this.dio);

  Future<List<SalesOrderList>> getSalesOrder({
    required String status,
    String? search,
  }) async {
    final Map<String, dynamic> queryParameters = {};
    if (status != 'all') {
      queryParameters['sales_status'] = status;
    }
    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    final res = await dio.get(
      '/transaction/sales-order',
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    final data = res.data;
    final List list = data['data'];

    return list.map((e) => SalesOrderList.fromJson(e)).toList();
  }

  Future<void> submitSalesOrder(SalesOrderRequest request) async {
    final body = request.toJson();

    body.forEach((key, value) {
      print("KEY: $key → ${value.runtimeType}");
    });
    for (var item in body['items']) {
      item.forEach((key, value) {
        print("ITEM KEY: $key → ${value.runtimeType}");
      });
    }
    final res = await dio.post(
      "/transaction/sales-order",
      data: request.toJson(),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
  }

  Future<BaseResponseSingle<CalculateForecast>> calculateForecast({
    required int animalGroupId,
    required String forecastDate,
  }) async {
    final res = await dio.post(
      '/transaction/sales-order/calculate-forecast',
      data: {"animal_group_id": animalGroupId, "forecast_date": forecastDate},
    );

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    return BaseResponseSingle.fromJson(
      res.data,
      (json) => CalculateForecast.fromJson(json),
    );
  }

  Future<SalesOrderDetail> getSalesOrderDetail(int id) async {
    final response = await dio.get('/transaction/sales-order/$id');

    final result = BaseResponseSingle.fromJson(
      response.data,
      (json) => SalesOrderDetail.fromJson(json),
    );

    return result.data;
  }

  Future<void> updateSalesOrder(int id, SalesOrderRequest request) async {
    final res = await dio.put(
      "/transaction/sales-order/$id",
      data: request.toJson(),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
  }

  Future<List<PaymentType>> getPaymentTypes() async {
    final res = await dio.get('/transaction/sales-invoice/payment-types');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    final data = res.data;
    final List list = data is Map ? data['data'] : data;
    return list.map((e) => PaymentType.fromJson(e)).toList();
  }

  Future<List<SalesInvoice>> getSalesInvoices(int soId) async {
    final res = await dio.get(
      '/transaction/sales-invoice',
      queryParameters: {'so_id': soId},
    );

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    final data = res.data;
    final List list = data is Map ? data['data'] : data;
    return list.map((e) => SalesInvoice.fromJson(e)).toList();
  }

  Future<Response> downloadSalesInvoice(
    int invoiceId, {
    void Function(int, int)? onProgress,
  }) async {
    return await dio.get(
      '/transaction/sales-invoice/$invoiceId/print',
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
      onReceiveProgress: onProgress,
    );
  }

  Future<List<ChartOfAccount>> getChartOfAccounts() async {
    final res = await dio.get('/transaction/sales-invoice/chart-of-accounts');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    final data = res.data;
    final List list = data is Map ? data['data'] : data;
    return list.map((e) => ChartOfAccount.fromJson(e)).toList();
  }

  Future<void> submitSalesInvoice(Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    // If there's a file, it should be handled in the notifier before calling this,
    // or passed as a MultipartFile within the map.

    final res = await dio.post("/transaction/sales-invoice", data: formData);

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
  }

  Future<void> cancelSalesInvoice(
    int invoiceId,
    Map<String, dynamic> data,
  ) async {
    final res = await dio.put(
      "/transaction/sales-invoice/$invoiceId",
      data: data,
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
