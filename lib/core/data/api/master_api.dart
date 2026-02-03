import 'package:dio/dio.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';

import '../../../../core/data/model/base_response.dart';

class MasterApi {
  final Dio dio;

  MasterApi(this.dio);

  Future<BaseResponse<FarmLocation>> getFarmLocations() async {
    final res = await dio.get('/master/farm-location');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return BaseResponse.fromJson(
      res.data,
      (json) => FarmLocation.fromJson(json),
    );
  }

  Future<BaseResponse<FarmArea>> getFarmAreas() async {
    final res = await dio.get('/master/farm-area');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return BaseResponse.fromJson(res.data, (json) => FarmArea.fromJson(json));
  }
}
