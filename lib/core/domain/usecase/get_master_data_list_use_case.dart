import 'package:livestock/core/data/model/animal_class_model.dart';
import 'package:livestock/core/data/model/animal_group_model.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'package:livestock/core/data/model/customer_model.dart';
import 'package:livestock/core/data/model/district_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/feed_medicine_model.dart';
import 'package:livestock/core/data/model/province_model.dart';
import 'package:livestock/core/data/model/village_model.dart';
import 'package:livestock/core/data/repository/master_repository.dart';

import '../../../features/dispatch/data/model/sales_order_dispatch_model.dart';
import '../../data/model/city_model.dart';
import '../../data/model/supplier_model.dart';

class GetMasterDataListUseCase {
  final MasterRepository repository;

  GetMasterDataListUseCase(this.repository);

  Future<List<FarmLocation>> callFarmLocations() {
    return repository.getFarmLocations();
  }

  Future<List<FarmArea>> callFarmAreas() {
    return repository.getFarmAreas();
  }

  Future<List<Customer>> callCustomer() {
    return repository.getCustomers();
  }

  Future<List<AnimalProfile>> callAnimals(
    int? animalClassPriceId, {
    String? search,
    String? status,
    int? farmLocationId,
    int? farmAreaId,
  }) {
    return repository.getAnimals(
      animalClassPriceId,
      search: search,
      status: status,
      farmLocationId: farmLocationId,
      farmAreaId: farmAreaId,
    );
  }

  Future<List<Province>> callProvinces() {
    return repository.getProvinces();
  }

  Future<List<City>> callCity(String param) {
    return repository.getCities(param);
  }

  Future<List<District>> callDistrict(String param) {
    return repository.getDistricts(param);
  }

  Future<List<Village>> callVillages(String param) {
    return repository.getVillages(param);
  }

  Future<List<FeedMedicine>> callFeedMedicines() {
    return repository.getFeedMedicines();
  }

  Future<List<AnimalGroup>> callAnimalGroups() {
    return repository.getAnimalGroups();
  }

  Future<List<Supplier>> callSuppliers() {
    return repository.getSuppliers();
  }

  Future<AnimalProfile> callAnimalDetail(String id) {
    return repository.getAnimalDetail(id);
  }

  Future<List<AnimalClass>> callAnimalClass({String? search, String? status}) {
    return repository.getAnimalClass(search: search, status: status);
  }

  Future<List<SalesOrderDispatch>> callSoDispatch() {
    return repository.getSoDispatch();
  }
}
