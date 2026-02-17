import 'package:livestock/core/data/model/animal_group_model.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'package:livestock/core/data/model/city_model.dart';
import 'package:livestock/core/data/model/customer_model.dart';
import 'package:livestock/core/data/model/district_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/feed_medicine_model.dart';
import 'package:livestock/core/data/model/province_model.dart';
import 'package:livestock/core/data/model/supplier_model.dart';

import '../api/master_api.dart';
import '../model/village_model.dart';

class MasterRepository {
  final MasterApi api;

  MasterRepository(this.api);

  Future<List<FarmLocation>> getFarmLocations() async {
    final res = await api.getFarmLocations();
    return res.data;
  }

  Future<List<FarmArea>> getFarmAreas() async {
    final res = await api.getFarmAreas();
    return res.data;
  }

  Future<List<Customer>> getCustomers() async {
    final res = await api.getCustomers();
    return res.data;
  }

  Future<List<AnimalProfile>> getAnimals() async {
    final res = await api.getAnimals();
    return res.data;
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
    final res = await api.getFeedMedicines();
    return res.data;
  }

  Future<List<AnimalGroup>> getAnimalGroups() async {
    final res = await api.getAnimalGroups();
    return res.data;
  }

  Future<List<Supplier>> getSuppliers() async {
    final res = await api.getSuppliers();
    return res.data;
  }
}
