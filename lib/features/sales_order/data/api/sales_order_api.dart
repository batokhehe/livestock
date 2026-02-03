import 'package:dio/dio.dart';

import '../model/sales_order_list_model.dart';

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
}
