import 'package:dio/dio.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'package:livestock/core/data/model/district_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/feed_medicine_model.dart';
import 'package:livestock/core/data/model/province_model.dart';
import 'package:livestock/core/data/model/village_model.dart';

import '../../../../core/data/model/base_response.dart';
import '../model/city_model.dart';
import '../model/customer_model.dart';

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

  Future<BaseResponse<Customer>> getCustomers() async {
    final res = await dio.get('/master/customer');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return BaseResponse.fromJson(res.data, (json) => Customer.fromJson(json));
  }

  Future<BaseResponse<AnimalProfile>> getAnimals() async {
    final res = await dio.get('/master/animal-profile');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return BaseResponse.fromJson(
      res.data,
      (json) => AnimalProfile.fromJson(json),
    );
  }

  Future<BaseResponse<FeedMedicine>> getFeedMedicines() async {
    final res = await dio.get('/master/feed-medicine');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return BaseResponse.fromJson(
      res.data,
          (json) => FeedMedicine.fromJson(json),
    );
  }

  Future<List<Province>> getProvinces() async {
    final res = await dio.get('/transaction/list-provinces');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    final List data = res.data ?? [];

    return data.map((e) => Province.fromJson(e)).toList();
  }

  Future<List<City>> getCities(String param) async {
    final res = await dio.get('/transaction/list-cities/$param');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    final List data = res.data ?? [];

    return data.map((e) => City.fromJson(e)).toList();
  }

  Future<List<District>> getDistricts(String param) async {
    final res = await dio.get('/transaction/list-districts/$param');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    final List data = res.data ?? [];

    return data.map((e) => District.fromJson(e)).toList();
  }

  Future<List<Village>> getVillages(String param) async {
    final res = await dio.get('/transaction/list-villages/$param');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    final List data = res.data ?? [];

    return data.map((e) => Village.fromJson(e)).toList();
  }
}
