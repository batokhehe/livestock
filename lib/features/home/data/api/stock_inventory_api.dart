import 'package:dio/dio.dart';
import '../models/stock_inventory_model.dart';

class StockInventoryApi {
  final Dio dio;

  StockInventoryApi(this.dio);

  Future<StockInventoryResponse> getStockInventories({
    String? itemType,
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'per_page': perPage,
    };

    if (itemType != null &&
        itemType.isNotEmpty &&
        itemType.toLowerCase() != 'all') {
      queryParams['item_type'] = itemType;
    }

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final res = await dio.get(
      '/inventory/stock-inventories',
      queryParameters: queryParams,
    );

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    return StockInventoryResponse.fromJson(res.data);
  }
}
