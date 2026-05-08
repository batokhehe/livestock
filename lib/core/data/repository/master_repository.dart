import 'package:livestock/core/data/model/animal_class_model.dart';
import 'package:livestock/core/data/model/animal_group_model.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'package:livestock/core/data/model/city_model.dart';
import 'package:livestock/core/data/model/customer_model.dart';
import 'package:livestock/core/data/model/district_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/feed_medicine_model.dart';
import 'package:livestock/core/data/model/province_model.dart';
import 'package:livestock/core/data/model/shipping_cost_model.dart';
import 'package:livestock/core/data/model/supplier_model.dart';

import '../../../features/dispatch/data/model/sales_order_dispatch_model.dart';
import '../api/master_api.dart';
import '../model/base_response.dart';
import '../model/village_model.dart';

class MasterRepository {
  final MasterApi api;

  MasterRepository(this.api);

  Future<List<FarmLocation>> getFarmLocations() async {
    final res = await api.getFarmLocations();
    return res.data;
  }

  Future<BaseResponse<FarmLocation>> getFarmLocationsPaginated({
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    return await api.getFarmLocations(
      page: page,
      perPage: perPage,
      search: search,
    );
  }

  Future<List<FarmArea>> getFarmAreas({int? farmLocationId}) async {
    final res = await api.getFarmAreas(farmLocationId: farmLocationId);
    return res.data;
  }

  Future<BaseResponse<FarmArea>> getFarmAreasPaginated({
    int? farmLocationId,
    int page = 1,
    int perPage = 10,
  }) async {
    return await api.getFarmAreas(
      farmLocationId: farmLocationId,
      page: page,
      perPage: perPage,
    );
  }

  Future<List<Customer>> getCustomers() async {
    final res = await api.getCustomers();
    return res.data;
  }

  Future<BaseResponse<Customer>> getCustomersPaginated({
    int page = 1,
    int perPage = 10,
    String? search,
    String? status,
  }) async {
    return await api.getCustomers(
      page: page,
      perPage: perPage,
      search: search,
      status: status,
    );
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
    return await api.getAnimals(
      animalClassPriceId,
      search: search,
      status: status,
      available: available,
      farmLocationId: farmLocationId,
      farmAreaId: farmAreaId,
      page: page,
      perPage: perPage,
    );
  }

  Future<List<Province>> getProvinces() async {
    return await api.getProvinces();
  }

  Future<List<City>> getCities(String param) async {
    return await api.getCities(param);
  }

  Future<List<District>> getDistricts(String param) async {
    return await api.getDistricts(param);
  }

  Future<List<Village>> getVillages(String param) async {
    return await api.getVillages(param);
  }

  Future<List<FeedMedicine>> getFeedMedicines() async {
    final res = await api.getFeedMedicines(page: 1, perPage: 1000);
    return res.data;
  }

  Future<BaseResponse<FeedMedicine>> getFeedMedicinesPaginated({
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    return await api.getFeedMedicines(
      page: page,
      perPage: perPage,
      search: search,
    );
  }

  Future<List<AnimalGroup>> getAnimalGroups() async {
    final res = await api.getAnimalGroups();
    return res.data;
  }

  Future<List<Supplier>> getSuppliers({String? type}) async {
    final res = await api.getSuppliers(type: type);
    return res.data;
  }

  Future<AnimalProfile> getAnimalDetail(String id) async {
    final res = await api.getAnimalDetail(id);
    return res.data;
  }

  Future<BaseResponse<AnimalClass>> getAnimalClass({
    String? search,
    String? status,
    required int page,
    required int perPage,
  }) async {
    return await api.getAnimalClasses(
      search: search,
      status: status,
      page: page,
      perPage: perPage,
    );
  }

  Future<List<SalesOrderDispatch>> getSoDispatch(
    String paymentStatus,
    String search,
  ) async {
    final res = await api.getSoDispatch(paymentStatus, search);
    return res.data;
  }

  Future<List<ShippingCost>> getShippingCosts({
    String? cityId,
    int? farmLocationId,
  }) async {
    final res = await api.getShippingCost(
      cityId: cityId,
      farmLocationId: farmLocationId,
    );
    return res.data;
  }
}
