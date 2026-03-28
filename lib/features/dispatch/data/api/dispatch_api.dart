import 'dart:convert';

import 'package:dio/dio.dart';

import '../model/dispatch_list_model.dart';
import '../model/dispatch_request_model.dart';

class DispatchApi {
  final Dio dio;

  DispatchApi(this.dio);

  Future<List<DispatchList>> getDispatch({
    required String status,
    String? search,
  }) async {
    final query = <String, dynamic>{};
    if (status != 'all') {
      query['dispatch_status'] = status;
    }
    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }
    final res = await dio.get(
      '/inventory/dispatch',
      queryParameters: query.isNotEmpty ? query : null,
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

    return list.map((e) => DispatchList.fromJson(e)).toList();
  }

  Future<void> submitDispatch(DispatchRequest request) async {
    final body = request.toJson();
    print(jsonEncode(body));
    // body.forEach((key, value) {
    //   print("KEY: $key → ${value.runtimeType}");
    // });
    // for (var item in body['items']) {
    //   item.forEach((key, value) {
    //     print("ITEM KEY: $key → ${value.runtimeType}");
    //   });
    // }
    final res = await dio.post("/inventory/dispatch", data: request.toJson());

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
