import 'package:dio/dio.dart';
import 'package:livestock/core/data/model/base_response.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import '../model/transfer_list_model.dart';
import '../model/transfer_detail_model.dart';
import '../model/stock_transfer_item_model.dart';
import '../model/stock_transfer_detail_model.dart';

class TransferApi {
  final Dio dio;

  TransferApi(this.dio);

  Future<BaseResponse<StockTransferItem>> getEquipmentAndSupplies({
    String? search,
    required int page,
    int perPage = 10,
  }) async {
    final res = await dio.get(
      '/inventory/stock-transfer/equipment-and-supplies',
      queryParameters: {
        'search': search,
        'page': page,
        'per_page': perPage,
      }..removeWhere((k, v) => v == null || v == ''),
    );

    return BaseResponse.fromJson(
      res.data,
      (json) => StockTransferItem.fromJson(json),
    );
  }

  Future<BaseResponse<StockTransferItem>> getFeedMedicines({
    String? search,
    String? type,
    required int page,
    int perPage = 10,
  }) async {
    final res = await dio.get(
      '/inventory/stock-transfer/feed-medicines',
      queryParameters: {
        'search': search,
        'item_type': type,
        'feed_type': type,
        'page': page,
        'per_page': perPage,
      }..removeWhere((k, v) => v == null || v == ''),
    );

    return BaseResponse.fromJson(
      res.data,
      (json) => StockTransferItem.fromJson(json),
    );
  }

  Future<BaseResponse<FarmLocation>> getStockTransferFarmLocations({
    String? search,
    required int page,
    int perPage = 10,
  }) async {
    final res = await dio.get(
      '/inventory/stock-transfer/farm-locations',
      queryParameters: {
        'search': search,
        'page': page,
        'per_page': perPage,
      }..removeWhere((k, v) => v == null || v == ''),
    );

    return BaseResponse.fromJson(
      res.data,
      (json) => FarmLocation.fromJson(json),
    );
  }

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

  Future<BaseResponse<AnimalProfile>> getAnimalProfilesForTransfer({
    String? search,
    required int page,
    int perPage = 10,
  }) async {
    final res = await dio.get(
      '/inventory/animal-transfer/animal-profiles',
      queryParameters: {
        'search': search,
        'page': page,
        'per_page': perPage,
      }..removeWhere((k, v) => v == null || v == ''),
    );

    return BaseResponse.fromJson(
      res.data,
      (json) => AnimalProfile.fromJson(json),
    );
  }

  Future<TransferDetail> getTransferDetail(int id) async {
    final res = await dio.get('/inventory/animal-transfer/$id');
    final responseData = res.data;
    if (responseData is Map && responseData['data'] != null) {
      return TransferDetail.fromJson(responseData['data']);
    }
    return TransferDetail.fromJson(responseData);
  }

  Future<StockTransferDetail> getStockTransferDetail(int id) async {
    final res = await dio.get('/inventory/stock-transfer/$id');
    final responseData = res.data;
    if (responseData is Map && responseData['data'] != null) {
      return StockTransferDetail.fromJson(responseData['data']);
    }
    return StockTransferDetail.fromJson(responseData);
  }

  Future<Response> createAnimalTransfer({
    required String transferDate,
    required int fromFarmLocationId,
    required int toFarmLocationId,
    required int fromFarmAreaId,
    required int toFarmAreaId,
    required int animalProfileId,
    double? shippingCost,
  }) async {
    return await dio.post(
      '/inventory/animal-transfer',
      data: {
        'transfer_date': transferDate,
        'from_farm_location_id': fromFarmLocationId,
        'to_farm_location_id': toFarmLocationId,
        'from_farm_area_id': fromFarmAreaId,
        'to_farm_area_id': toFarmAreaId,
        'animal_profile_id': animalProfileId,
        'shipping_cost': shippingCost,
      }..removeWhere((k, v) => v == null),
    );
  }

  Future<Response> createStockTransfer({
    required String transferDate,
    required int fromFarmLocationId,
    required int toFarmLocationId,
    required String itemType,
    required int itemId,
    required String itemCode,
    required String itemName,
    required double qty,
    String? notes,
    double? shippingCost,
  }) async {
    return await dio.post(
      '/inventory/stock-transfer',
      data: {
        'transfer_date': transferDate,
        'from_farm_location_id': fromFarmLocationId,
        'to_farm_location_id': toFarmLocationId,
        'item_type': itemType,
        'item_id': itemId,
        'item_code': itemCode,
        'item_name': itemName,
        'qty': qty,
        'notes': notes,
        'shipping_cost': shippingCost,
      }..removeWhere((k, v) => v == null),
    );
  }
}
