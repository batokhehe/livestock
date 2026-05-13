import 'dart:async';
import 'package:dio/dio.dart';
import 'package:livestock/core/data/model/animal_class_model.dart';
import 'package:livestock/core/data/model/animal_group_model.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'package:livestock/core/data/model/district_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/feed_medicine_model.dart';
import 'package:livestock/core/data/model/province_model.dart';
import 'package:livestock/core/data/model/supplier_model.dart';
import 'package:livestock/core/data/model/village_model.dart';
import 'package:livestock/core/errors/unauthorized_exception.dart';
import 'package:livestock/features/dispatch/data/model/sales_order_dispatch_model.dart';

import 'package:livestock/core/data/model/shipping_cost_model.dart';

import '../../../../core/data/model/base_response.dart';
import '../model/base_response_single.dart';
import '../model/city_model.dart';
import '../model/customer_model.dart';

class MasterApi {
  final Dio dio;

  MasterApi(this.dio);

  Future<BaseResponse<FarmLocation>> getFarmLocations({
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final res = await dio.get(
      '/master/farm-location',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'search': search,
      }..removeWhere((k, v) => v == null),
    );

    
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

  Future<BaseResponse<FarmArea>> getFarmAreas({
    int? farmLocationId,
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final res = await dio.get(
      '/master/farm-area',
      queryParameters: {
        'farm_location_id': farmLocationId,
        'page': page,
        'per_page': perPage,
        'search': search,
      }..removeWhere((k, v) => v == null),
    );

    
    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return BaseResponse.fromJson(res.data, (json) => FarmArea.fromJson(json));
  }

  Future<BaseResponse<Customer>> getCustomers({
    int page = 1,
    int perPage = 10,
    String? search,
    String? status,
  }) async {
    final res = await dio.get(
      '/master/customer',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'search': search,
        'status': status,
      }..removeWhere((k, v) => v == null),
    );

    
    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return BaseResponse.fromJson(res.data, (json) => Customer.fromJson(json));
  }

  Future<BaseResponse<AnimalProfile>> getAnimals(
    int? animalClassPriceId, {
    String? search,
    String? status,
    String? available,
    int? farmLocationId,
    int? farmAreaId,
    required int page,
    required int perPage,
  }) async {
    final res = await dio.get(
      '/master/animal-profile',
      queryParameters: {
        'animal_class_price_id': animalClassPriceId,
        'search': (search?.isNotEmpty ?? false) ? search : null,
        'status': (status?.isNotEmpty ?? false) ? status : null,
        'available': (available?.isNotEmpty ?? false) ? available : null,
        'farm_location_id': farmLocationId,
        'farm_area_id': farmAreaId,
        'page': page,
        'per_page': perPage,
      }..removeWhere((k, v) => v == null),
    );

    
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

  Future<BaseResponse<FeedMedicine>> getFeedMedicines({
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final res = await dio.get(
      '/master/feed-medicine',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'search': search,
      }..removeWhere((k, v) => v == null),
    );

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

  Future<BaseResponse<AnimalGroup>> getAnimalGroups({
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final res = await dio.get(
      '/master/animal-group',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'search': search,
      }..removeWhere((k, v) => v == null),
    );

    
    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return BaseResponse.fromJson(
      res.data,
      (json) => AnimalGroup.fromJson(json),
    );
  }

  Future<BaseResponse<Supplier>> getSuppliers({
    String? type,
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final res = await dio.get(
      '/master/supplier',
      queryParameters: {
        'type': type,
        'page': page,
        'per_page': perPage,
        'search': search,
      }..removeWhere((k, v) => v == null || v == ''),
    );

    
    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return BaseResponse.fromJson(res.data, (json) => Supplier.fromJson(json));
  }

  Future<BaseResponseSingle<AnimalProfile>> getAnimalDetail(String id) async {
    final res = await dio.get('/master/animal-profile/$id');

    
    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    return BaseResponseSingle.fromJson(
      res.data,
      (json) => AnimalProfile.fromJson(json),
    );
  }

  Future<BaseResponse<AnimalClass>> getAnimalClasses({
    String? search,
    String? status,
    required int page,
    required int perPage,
  }) async {
    final res = await dio.get(
      '/master/animal-class-price',
      queryParameters: {
        'search': (search?.isNotEmpty ?? false) ? search : null,
        'status': (status?.isNotEmpty ?? false) ? status : null,
        'page': page,
        'per_page': perPage,
      }..removeWhere((k, v) => v == null),
    );

    
    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return BaseResponse.fromJson(
      res.data,
      (json) => AnimalClass.fromJson(json),
    );
  }

  Future<BaseResponse<SalesOrderDispatch>> getSoDispatch(
    String paymentStatus,
    String search,
  ) async {
    final query = <String, dynamic>{};
    if (paymentStatus != 'all') {
      query['payment_status'] = paymentStatus;
    }
    query['search'] = search;

    final res = await dio.get(
      '/inventory/dispatch/sales-orders',
      queryParameters: query.isNotEmpty ? query : null,
    );

    
    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    return BaseResponse.fromJson(
      res.data,
      (json) => SalesOrderDispatch.fromJson(json),
    );
  }

  Future<BaseResponse<ShippingCost>> getShippingCost({
    String? cityId,
    int? farmLocationId,
  }) async {
    final res = await dio.get(
      '/master/shipping-cost',
      queryParameters: {'city_id': cityId, 'farm_location_id': farmLocationId},
    );

    
    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return BaseResponse.fromJson(
      res.data,
      (json) => ShippingCost.fromJson(json),
    );
  }
}
