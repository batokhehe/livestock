import 'package:dio/dio.dart';
import 'package:livestock/features/receiving/data/model/receiving_detail_model.dart';
import 'package:livestock/features/receiving/data/model/receiving_po_model.dart';

import '../model/receiving_list_model.dart';

class ReceivingApi {
  final Dio dio;

  ReceivingApi(this.dio);

  Future<List<ReceivingList>> getReceiving({
    required String receiveType,
  }) async {
    final res = await dio.get(
      '/inventory/receiving',
      queryParameters: {'receive_type': receiveType},
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

    return list.map((e) => ReceivingList.fromJson(e)).toList();
  }

  Future<List<ReceivingPo>> getReceivingPo({required String type}) async {
    final res = await dio.get('/inventory/receiving/purchase-orders/$type');

    final List list = res.data['data'];
    return list.map((e) => ReceivingPo.fromJson(e)).toList();
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

    await dio.post(
      "/inventory/receiving/$type",
      data: payload,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<ReceivingDetail> getReceivingDetail(int id) async {
    final res = await dio.get('/inventory/receiving/$id');
    return ReceivingDetail.fromJson(res.data['data']);
  }
}
