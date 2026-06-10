import 'package:dio/dio.dart';
import 'package:livestock/core/data/model/base_response.dart';
import '../model/transfer_list_model.dart';

class TransferApi {
  final Dio dio;

  TransferApi(this.dio);

  Future<BaseResponse<TransferList>> getTransfer({
    bool isStock = false,
    int? page,
    int? perPage,
    String? search,
    String? itemType,
    int? fromFarmLocationId,
    int? toFarmLocationId,
    String? sortBy,
    String? sortDir,
    bool? all,
  }) async {
    final endpoint = isStock ? '/inventory/stock-transfer' : '/inventory/animal-transfer';
    final res = await dio.get(
      endpoint,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'search': search,
        'item_type': itemType,
        'from_farm_location_id': fromFarmLocationId,
        'to_farm_location_id': toFarmLocationId,
        'sort_by': sortBy,
        'sort_dir': sortDir,
        'all': all,
      }..removeWhere((k, v) => v == null || v == ''),
    );

    return BaseResponse.fromJson(
      res.data,
      (json) => TransferList.fromJson(json),
    );
  }
}
