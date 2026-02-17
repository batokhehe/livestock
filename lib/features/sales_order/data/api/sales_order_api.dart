import 'package:dio/dio.dart';

import '../model/sales_order_list_model.dart';
import '../model/sales_order_request_model.dart';

class SalesOrderApi {
  final Dio dio;

  SalesOrderApi(this.dio);

  Future<List<SalesOrderList>> getSalesOrder({required String status}) async {
    final res = await dio.get(
      '/transaction/sales-order',
      queryParameters: status != 'all' ? {'sales_status': status} : null,
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
}
