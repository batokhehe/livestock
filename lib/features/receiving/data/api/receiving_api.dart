import 'package:dio/dio.dart';
import 'package:livestock/core/data/model/base_response.dart';
import 'package:livestock/features/receiving/data/model/receiving_detail_model.dart';
import 'package:livestock/features/receiving/data/model/receiving_po_model.dart';

import '../model/receiving_list_model.dart';

class ReceivingApi {
  final Dio dio;

  ReceivingApi(this.dio);

  Future<BaseResponse<ReceivingList>> getReceiving({
    required String receiveType,
    int? farmLocationId,
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final res = await dio.get(
      '/inventory/receiving',
      queryParameters: {
        'receive_type': receiveType,
        'farm_location_id': farmLocationId,
        'page': page,
        'per_page': perPage,
        'search': search,
      }..removeWhere((k, v) => v == null || v == ''),
    );

    return BaseResponse.fromJson(
      res.data,
      (json) => ReceivingList.fromJson(json),
    );
  }

  Future<BaseResponse<ReceivingPo>> getReceivingPo({
    required String type,
    int? farmLocationId,
    int? farmAreaId,
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'search': search,
    };

    if (type != 'feed' &&
        type != 'medicine' &&
        type != 'equipment' &&
        type != 'supplies') {
      queryParams['farm_location_id'] = farmLocationId;
      queryParams['farm_area_id'] = farmAreaId;
    }

    queryParams.removeWhere((k, v) => v == null || v == '');

    String endpoint = '/inventory/receiving/purchase-orders/$type';
    if (type == 'feed' || type == 'medicine') {
      endpoint = '/inventory/receiving/purchase-orders/feed-medicine';
    } else if (type == 'equipment' || type == 'supplies') {
      endpoint = '/inventory/receiving/purchase-orders/equipment-supplies';
    }

    final res = await dio.get(endpoint, queryParameters: queryParams);

    return BaseResponse.fromJson(
      res.data,
      (json) => ReceivingPo.fromJson(json),
    );
  }

  Future<void> submitReceiving({
    required DateTime receiveDate,
    required int farmLocationId,
    required int farmAreaId,
    required String remarks,
    required List<Map<String, dynamic>> items,
    required String type,
  }) async {
    final payload = <String, dynamic>{
      "receive_date": receiveDate.toIso8601String().split('T').first,
      "receive_status": "received",
      "farm_location_id": farmLocationId,
      "remarks": remarks,
      "items": items,
    };

    if (farmAreaId != 0) {
      payload["farm_area_id"] = farmAreaId;
    }

    if (farmAreaId == 0 && items.isNotEmpty) {
      final ft = items.first['feed_type'];
      if (ft != null) {
        payload["feed_type"] = ft == 'obat' ? 'medicine' : 'feed';
      }

      final ft2 = items.first['type'];
      if (ft2 != null) {
        payload["equipment_type"] = ft2;
      }
    }

    String endpoint = '/inventory/receiving/$type';
    if (type == 'feed' || type == 'medicine') {
      endpoint = '/inventory/receiving/feed-medicine';
    } else if (type == 'equipment' || type == 'supplies') {
      endpoint = '/inventory/receiving/equipment-supplies';
    }

    await dio.post(
      endpoint,
      data: payload,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<ReceivingDetail> getReceivingDetail(int id) async {
    final res = await dio.get('/inventory/receiving/$id');
    return ReceivingDetail.fromJson(res.data['data']);
  }
}
