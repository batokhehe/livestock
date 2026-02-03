import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/api/master_api.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/repository/master_repository.dart';

import '../core/constant/enum.dart';
import '../core/domain/usecase/get_master_data_list_use_case.dart';
import '../core/errors/unauthorized_exception.dart';
import '../core/network/dio_client.dart';

export '../features/auth/data/auth_repository.dart';
export '../features/auth/providers/auth_provider.dart';
export 'router.dart';

final itemFilterProvider = StateProvider<ItemFilter>((ref) {
  return ItemFilter.product;
});

final unauthorizedProvider = StateProvider<UnauthorizedException?>(
  (ref) => null,
);

final masterRepositoryProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return MasterRepository(MasterApi(dio));
});

final getMasterDataListUseCaseProvider = Provider((ref) {
  return GetMasterDataListUseCase(ref.read(masterRepositoryProvider));
});

final farmLocationListProvider = FutureProvider.autoDispose<List<FarmLocation>>(
  (ref) async {
    return ref.read(getMasterDataListUseCaseProvider).callFarmLocations();
  },
);
final selectedFarmLocationProvider = StateProvider<FarmLocation?>(
  (ref) => null,
);
final farmLocationSearchProvider = StateProvider.autoDispose<String>(
      (ref) => '',
);

final farmAreaListProvider = FutureProvider.autoDispose<List<FarmArea>>((
  ref,
) async {
  return ref.read(getMasterDataListUseCaseProvider).callFarmAreas();
});
final selectedFarmAreaProvider = StateProvider<FarmArea?>(
  (ref) => null,
);
final farmAreaSearchProvider = StateProvider.autoDispose<String>(
      (ref) => '',
);