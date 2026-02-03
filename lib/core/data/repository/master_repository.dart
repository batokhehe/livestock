import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';

import '../api/master_api.dart';

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
}
