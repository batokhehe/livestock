import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/api/master_api.dart';
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
import 'package:livestock/core/data/model/village_model.dart';
import 'package:livestock/core/data/repository/master_repository.dart';

import '../core/constant/enum.dart';
import '../core/data/model/animal_class_model.dart';
import '../core/data/model/base_response.dart';
import '../core/domain/usecase/get_master_data_list_use_case.dart';
import '../core/errors/unauthorized_exception.dart';
import '../core/notifier/farm_location_notifier.dart';
import '../core/notifier/farm_area_notifier.dart';
import '../core/notifier/customer_notifier.dart';
import '../core/network/dio_client.dart';
import '../core/notifier/product_notifier.dart';
import '../core/notifier/animal_notifier.dart';
import '../core/notifier/feed_medicine_notifier.dart';
import '../features/dispatch/data/model/sales_order_dispatch_model.dart';
import '../features/dispatch/dispatch_provider.dart';

export '../features/auth/data/auth_repository.dart';
export '../features/auth/providers/auth_provider.dart';
export '../core/network/dio_client.dart';
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

// FARM LOCATION
final farmLocationListProvider = FutureProvider.autoDispose<List<FarmLocation>>(
  (ref) async {
    return ref.read(getMasterDataListUseCaseProvider).callFarmLocations();
  },
);

final paginatedFarmLocationProvider = AsyncNotifierProvider.autoDispose<
    FarmLocationNotifier, BaseResponse<FarmLocation>>(
  FarmLocationNotifier.new,
);
final selectedFarmLocationProvider = StateProvider<FarmLocation?>(
  (ref) => null,
);
final farmLocationSearchProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

// FARM AREA
final farmAreaListProvider = FutureProvider.autoDispose<List<FarmArea>>(
  (ref) async {
    final farmLocationId = ref.watch(animalFarmLocationIdProvider);
    return ref
        .read(getMasterDataListUseCaseProvider)
        .callFarmAreas(farmLocationId: farmLocationId);
  },
);

final paginatedFarmAreaProvider = AsyncNotifierProvider.autoDispose<
    FarmAreaNotifier, BaseResponse<FarmArea>>(
  FarmAreaNotifier.new,
);
final selectedFarmAreaProvider = StateProvider<FarmArea?>((ref) => null);
final farmAreaSearchProvider = StateProvider.autoDispose<String>((ref) => '');

// CUSTOMER
final customerListProvider = FutureProvider.autoDispose<List<Customer>>((
  ref,
) async {
  return ref.read(getMasterDataListUseCaseProvider).callCustomer();
});

final paginatedCustomerProvider = AsyncNotifierProvider.autoDispose<
    CustomerNotifier, BaseResponse<Customer>>(
  CustomerNotifier.new,
);

final selectedCustomerProvider = StateProvider<Customer?>((ref) => null);
final customerSearchProvider = StateProvider.autoDispose<String>((ref) => '');
final customerStatusProvider = StateProvider.autoDispose<String>((ref) => '');

// ANIMAL
final animalListProvider = FutureProvider.autoDispose.family<
  BaseResponse<AnimalProfile>,
  ({String? available, String? search, int? farmLocationId})
>((ref, arg) async {
  return ref.read(getMasterDataListUseCaseProvider).callAnimals(
    available: (arg.available?.isEmpty ?? true) ? null : arg.available,
    search: (arg.search?.length ?? 0) >= 2 ? arg.search : null,
    farmLocationId: arg.farmLocationId,
    page: 1,
    perPage: 1000,
  );
});
final paginatedAnimalProvider = AsyncNotifierProvider.autoDispose.family<
    AnimalNotifier,
    BaseResponse<AnimalProfile>,
    ({String? available, int? farmLocationId})>(
  AnimalNotifier.new,
);

final selectedAnimalProvider = StateProvider<AnimalProfile?>((ref) => null);
final animalSearchProvider = StateProvider.autoDispose<String>((ref) => '');
final animalStatusProvider = StateProvider.autoDispose<String>((ref) => '');
final animalAvailableProvider = StateProvider.autoDispose<String>((ref) => '');
final animalFarmLocationIdProvider = StateProvider.autoDispose<int?>(
  (ref) => null,
);
final animalFarmAreaIdProvider = StateProvider.autoDispose<int?>((ref) => null);
final animalDetailProvider = FutureProvider.autoDispose
    .family<AnimalProfile, String>((ref, id) async {
      return ref.read(getMasterDataListUseCaseProvider).callAnimalDetail(id);
    });

// PROVINCE
final provinceListProvider = FutureProvider.autoDispose<List<Province>>((
  ref,
) async {
  return ref.read(getMasterDataListUseCaseProvider).callProvinces();
});
final selectedProvinceProvider = StateProvider<Province?>((ref) => null);
final provinceSearchProvider = StateProvider.autoDispose<String>((ref) => '');

// CITY
final cityListProvider = FutureProvider.autoDispose<List<City>>((ref) async {
  final selectedProvince = ref.watch(selectedProvinceProvider);

  if (selectedProvince == null) return [];

  return ref
      .read(getMasterDataListUseCaseProvider)
      .callCity(selectedProvince.code);
});

final selectedCityProvider = StateProvider.autoDispose<City?>((ref) => null);
final citySearchProvider = StateProvider.autoDispose<String>((ref) => '');

// District
final districtListProvider = FutureProvider.autoDispose<List<District>>((
  ref,
) async {
  final selectedCity = ref.watch(selectedCityProvider);
  if (selectedCity == null) return [];
  return ref
      .read(getMasterDataListUseCaseProvider)
      .callDistrict(selectedCity.code);
});
final selectedDistrictProvider = StateProvider.autoDispose<District?>(
  (ref) => null,
);
final districtSearchProvider = StateProvider.autoDispose<String>((ref) => '');

// Village
final villageListProvider = FutureProvider.autoDispose<List<Village>>((
  ref,
) async {
  final selectedDistrict = ref.watch(selectedDistrictProvider);
  if (selectedDistrict == null) return [];
  return ref
      .read(getMasterDataListUseCaseProvider)
      .callVillages(selectedDistrict.code);
});
final selectedVillageProvider = StateProvider.autoDispose<Village?>(
  (ref) => null,
);
final villageSearchProvider = StateProvider.autoDispose<String>((ref) => '');

// FEED & MEDICINE
final feedMedicineListProvider = FutureProvider.autoDispose<List<FeedMedicine>>(
  (ref) async {
    return ref.read(getMasterDataListUseCaseProvider).callFeedMedicines();
  },
);
final paginatedFeedMedicineProvider = AsyncNotifierProvider.autoDispose<
    FeedMedicineNotifier, BaseResponse<FeedMedicine>>(
  FeedMedicineNotifier.new,
);
final selectedFeedMedicineProvider = StateProvider<FeedMedicine?>(
  (ref) => null,
);
final feedMedicineSearchProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

// ANIMAL GROUP
final animalGroupListProvider = FutureProvider.autoDispose<List<AnimalGroup>>((
  ref,
) async {
  return ref.read(getMasterDataListUseCaseProvider).callAnimalGroups();
});
final selectedAnimalGroupProvider = StateProvider<AnimalGroup?>((ref) => null);
final animalGroupSearchProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

// SUPPLIER
final supplierListProvider = FutureProvider.autoDispose
    .family<List<Supplier>, String?>((ref, type) async {
      return ref
          .read(getMasterDataListUseCaseProvider)
          .callSuppliers(type: type);
    });
final selectedSupplierProvider = StateProvider<Supplier?>((ref) => null);
final supplierSearchProvider = StateProvider.autoDispose<String>((ref) => '');

// ANIMAL CLASS
final animalClassListProvider =
    FutureProvider.autoDispose<BaseResponse<AnimalClass>>((ref) async {
      return ref
          .read(getMasterDataListUseCaseProvider)
          .callAnimalClass(page: 1, perPage: 1000);
    });
final selectedAnimalClassProvider = StateProvider<AnimalClass?>((ref) => null);
final animalClassSearchProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final animalClassStatusProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final productDataProvider =
    AsyncNotifierProvider.autoDispose<ProductNotifier, BaseResponse<dynamic>>(
      ProductNotifier.new,
    );

final selectedAnimalClassPriceIdProvider = StateProvider<int?>((ref) => null);
final animalListByClassProvider =
    FutureProvider.autoDispose<BaseResponse<AnimalProfile>>((ref) async {
      final animalClassPriceId = ref.watch(selectedAnimalClassPriceIdProvider);

      return ref
          .read(getMasterDataListUseCaseProvider)
          .callAnimals(
            animalClassPriceId: animalClassPriceId,
            page: 1,
            perPage: 1000,
          );
    });

//SO Dispatch
final soListProvider = FutureProvider.autoDispose<List<SalesOrderDispatch>>((
  ref,
) async {
  final tab = ref.watch(dispatchSoTabProvider);
  final search = ref.watch(soSearchProvider);

  return ref
      .read(getMasterDataListUseCaseProvider)
      .callSoDispatch(tab.apiValue, search);
});
