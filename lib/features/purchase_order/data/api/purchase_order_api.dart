import 'package:dio/dio.dart';
import 'package:livestock/core/data/model/base_response_single.dart';

import '../model/purchase_order_list_model.dart';
import '../model/purchase_order_request_model.dart';

class PurchaseOrderApi {
  final Dio dio;

  PurchaseOrderApi(this.dio);

  Future<List<PurchaseOrderList>> getPurchaseOrder({
    required String type,
  }) async {
    final res = await dio.get(
      '/transaction/purch-order',
      queryParameters: {'type': type},
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

    return list.map((e) => PurchaseOrderList.fromJson(e)).toList();
  }

  Future<void> submitPurchaseOrder(PurchaseOrderRequest request) async {
    final res = await dio.post(
      "/transaction/purch-order",
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

  Future<BaseResponseSingle<PurchaseOrderList>> getPurchaseOrderDetail(
    int id,
  ) async {
    final res = await dio.get('/transaction/purch-order/$id');
    return BaseResponseSingle.fromJson(
      res.data,
      (json) => PurchaseOrderList.fromJson(json),
    );
  }
}
