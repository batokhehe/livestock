import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/repository/master_repository.dart';

class GetMasterDataListUseCase {
  final MasterRepository repository;

  GetMasterDataListUseCase(this.repository);

  Future<List<FarmLocation>> callFarmLocations() {
    return repository.getFarmLocations();
  }

  Future<List<FarmArea>> callFarmAreas() {
    return repository.getFarmAreas();
  }
}
