import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/constant/enum.dart';
import 'package:livestock/features/monitoring/data/api/monitoring_api.dart';
import 'package:livestock/core/data/model/base_response.dart';
import 'package:livestock/features/monitoring/data/monitoring_type_item_model.dart';

import '../../app/providers.dart';
import '../attendance/data/model/employee_model.dart';
import 'data/health_monitoring_model.dart';
import 'data/medicine_monitoring_model.dart';
import 'data/feed_monitoring_model.dart';
import 'data/monitoring_item_model.dart';
import 'data/monitoring_model.dart';
import 'data/total_animal_model.dart';
import 'data/animal_health_check_model.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';

final selectedMonitoringEmployeeProvider = StateProvider.autoDispose<Employee?>(
  (ref) => null,
);
final selectedMonitoringDateProvider = StateProvider.autoDispose<DateTime?>(
  (ref) => null,
);
final selectedHealthMonitoringDateProvider =
    StateProvider.autoDispose<DateTime?>((ref) => null);
final selectedMedicineMonitoringDateProvider =
    StateProvider.autoDispose<DateTime?>((ref) => null);

final selectedMonitoringMedicineProvider =
    StateProvider.autoDispose<MonitoringTypeItemModel?>((ref) => null);

final selectedMonitoringFarmProvider = StateProvider.autoDispose<FarmLocation?>(
  (ref) => null,
);
final selectedMonitoringAreaProvider = StateProvider.autoDispose<FarmArea?>(
  (ref) => null,
);

final monitoringFeedSatuanProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final monitoringAnimalAvailableCountProvider = FutureProvider.autoDispose<int>((
  ref,
) async {
  final farmId = ref.watch(selectedMonitoringFarmProvider)?.id;
  final areaId = ref.watch(selectedMonitoringAreaProvider)?.id;

  if (farmId == null || areaId == null) return 0;

  final dio = ref.watch(dioProvider);
  try {
    final res = await dio.get(
      '/monitoring/health-monitoring/total-animal',
      queryParameters: {'farm_location_id': farmId, 'farm_area_id': areaId}
        ..removeWhere((k, v) => v == null),
    );

    final responseData = res.data;
    if (responseData is Map) {
      final dataField = responseData['data'];
      if (dataField is Map) {
        return TotalAnimal.fromJson(
          dataField as Map<String, dynamic>,
        ).totalAnimal;
      }
      return TotalAnimal.fromJson(
        responseData as Map<String, dynamic>,
      ).totalAnimal;
    }

    return 0;
  } catch (e) {
    return 0;
  }
});
final monitoringApiProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return MonitoringApi(dio);
});


final medicineMonitoringDetailProvider = FutureProvider.autoDispose
    .family<MedicineMonitoring, int>((ref, id) async {
      final api = ref.read(monitoringApiProvider);
      return api.getMedicineMonitoringDetail(id);
    });

final feedMonitoringDetailProvider = FutureProvider.autoDispose
    .family<FeedMonitoring, int>((ref, id) async {
      final api = ref.read(monitoringApiProvider);
      return api.getFeedMonitoringDetail(id);
    });

// Weight monitoring list filters
final weightMonitoringSearchProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final weightMonitoringTypeProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final feedMonitoringSearchProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final healthMonitoringSearchProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final addedMonitoringWeightItemsProvider =
    StateProvider.autoDispose<List<MonitoringItem>>((ref) => []);
final addedMonitoringFeedItemsProvider =
    StateProvider.autoDispose<List<MonitoringItem>>((ref) => []);
final addedMonitoringMedicineItemsProvider =
    StateProvider.autoDispose<List<MonitoringItem>>((ref) => []);
final addedMonitoringHealthItemsProvider =
    StateProvider.autoDispose<List<MonitoringItem>>((ref) => []);

final selectedHealthCheckAnimalProvider =
    StateProvider.autoDispose<AnimalProfile?>((ref) => null);
final healthCheckAnimalSearchProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

class HealthCheckAnimalNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<
          BaseResponse<AnimalProfile>,
          ({int? farmLocationId, int? farmAreaId})
        > {
  int _page = 1;
  bool _loadingMore = false;
  bool _hasMore = true;

  @override
  Future<BaseResponse<AnimalProfile>> build(
    ({int? farmLocationId, int? farmAreaId}) arg,
  ) async {
    _page = 1;
    _hasMore = true;
    final search = ref.watch(healthCheckAnimalSearchProvider);
    final api = ref.read(monitoringApiProvider);

    if (arg.farmLocationId == null || arg.farmAreaId == null) {
      return BaseResponse(status: 200, message: '', total: 0, data: []);
    }

    return api.getHealthCheckAnimals(
      farmLocationId: arg.farmLocationId!,
      farmAreaId: arg.farmAreaId!,
      page: _page,
      perPage: 10,
      search: search.isEmpty ? null : search,
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || _loadingMore) return;
    final current = state.value;
    if (current == null) return;

    final total = current.total ?? 0;
    if (current.data.length >= total) return;

    _loadingMore = true;
    _page++;

    final search = ref.read(healthCheckAnimalSearchProvider);
    final api = ref.read(monitoringApiProvider);

    try {
      final result = await api.getHealthCheckAnimals(
        farmLocationId: arg.farmLocationId!,
        farmAreaId: arg.farmAreaId!,
        page: _page,
        perPage: 10,
        search: search.isEmpty ? null : search,
      );

      _hasMore = result.data.isNotEmpty;
      state = AsyncData(
        BaseResponse(
          status: result.status,
          message: result.message,
          total: result.total,
          data: [...current.data, ...result.data],
        ),
      );
    } catch (e, st) {
      _page--;
      state = AsyncError(e, st);
    } finally {
      _loadingMore = false;
    }
  }
}

final paginatedHealthCheckAnimalProvider = AsyncNotifierProvider.autoDispose
    .family<
      HealthCheckAnimalNotifier,
      BaseResponse<AnimalProfile>,
      ({int? farmLocationId, int? farmAreaId})
    >(HealthCheckAnimalNotifier.new);

class AnimalHealthCheckListNotifier
    extends AutoDisposeAsyncNotifier<BaseResponse<AnimalHealthCheck>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<AnimalHealthCheck>> build() async {
    _page = 1;
    final api = ref.read(monitoringApiProvider);
    final search = ref.watch(healthMonitoringSearchProvider);

    return api.getAnimalHealthCheck(
      page: _page,
      perPage: 10,
      search: search.isEmpty ? null : search,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _loadingMore) return;

    final total = current.total ?? 0;
    if (current.data.length >= total) return;

    _loadingMore = true;
    _page++;

    final api = ref.read(monitoringApiProvider);
    final search = ref.read(healthMonitoringSearchProvider);

    try {
      final result = await api.getAnimalHealthCheck(
        page: _page,
        perPage: 10,
        search: search.isEmpty ? null : search,
      );

      state = AsyncData(
        BaseResponse(
          status: result.status,
          message: result.message,
          total: result.total,
          data: [...current.data, ...result.data],
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _loadingMore = false;
    }
  }
}

final animalHealthCheckListProvider =
    AsyncNotifierProvider.autoDispose<
      AnimalHealthCheckListNotifier,
      BaseResponse<AnimalHealthCheck>
    >(AnimalHealthCheckListNotifier.new);

final animalHealthCheckDetailProvider = FutureProvider.autoDispose
    .family<AnimalHealthCheck, int>((ref, id) async {
      final api = ref.read(monitoringApiProvider);
      return api.getAnimalHealthCheckDetail(id);
    });

class MonitoringFeedStockNotifier
    extends AutoDisposeAsyncNotifier<BaseResponse<MonitoringTypeItemModel>> {
  int _page = 1;
  final int _perPage = 15;
  bool _hasMore = true;

  @override
  Future<BaseResponse<MonitoringTypeItemModel>> build() async {
    return _fetchPage(1);
  }

  Future<BaseResponse<MonitoringTypeItemModel>> _fetchPage(int page) async {
    final dio = ref.read(dioProvider);
    final farmId = ref.read(selectedMonitoringFarmProvider)?.id;
    final areaId = ref.read(selectedMonitoringAreaProvider)?.id;

    final res = await dio.get(
      '/monitoring/feed-monitoring/stock-feed',
      queryParameters: {
        'farm_location_id': farmId,
        'farm_area_id': areaId,
        'page': page,
        'per_page': _perPage,
      }..removeWhere((k, v) => v == null),
    );

    return BaseResponse<MonitoringTypeItemModel>.fromJson(
      res.data,
      (json) => MonitoringTypeItemModel.fromJson(json),
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading || state.hasError) return;

    final currentData = state.value;
    if (currentData == null) return;

    _page++;
    // state = const AsyncValue.loading();
    try {
      final newData = await _fetchPage(_page);
      _hasMore = newData.data.isNotEmpty;
      state = AsyncValue.data(
        BaseResponse(
          status: newData.status,
          message: newData.message,
          total: newData.total,
          totalRows: newData.totalRows,
          data: [...currentData.data, ...newData.data],
        ),
      );
    } catch (e, stack) {
      _page--;
      state = AsyncValue.error(e, stack);
    }
  }
}

final paginatedMonitoringFeedStockProvider =
    AsyncNotifierProvider.autoDispose<
      MonitoringFeedStockNotifier,
      BaseResponse<MonitoringTypeItemModel>
    >(MonitoringFeedStockNotifier.new);

class MonitoringMedicineStockNotifier
    extends AutoDisposeAsyncNotifier<BaseResponse<MonitoringTypeItemModel>> {
  int _page = 1;
  final int _perPage = 15;
  bool _hasMore = true;

  @override
  Future<BaseResponse<MonitoringTypeItemModel>> build() async {
    return _fetchPage(1);
  }

  Future<BaseResponse<MonitoringTypeItemModel>> _fetchPage(int page) async {
    final dio = ref.read(dioProvider);
    final farmId = ref.read(selectedMonitoringFarmProvider)?.id;

    final res = await dio.get(
      '/monitoring/health-monitoring/stock-medicine',
      queryParameters: {
        'farm_location_id': farmId,
        'page': page,
        'per_page': _perPage,
      }..removeWhere((k, v) => v == null),
    );

    return BaseResponse<MonitoringTypeItemModel>.fromJson(
      res.data,
      (json) => MonitoringTypeItemModel.fromJson(json),
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading || state.hasError) return;

    final currentData = state.value;
    if (currentData == null) return;

    _page++;
    try {
      final newData = await _fetchPage(_page);
      _hasMore = newData.data.isNotEmpty;
      state = AsyncValue.data(
        BaseResponse(
          status: newData.status,
          message: newData.message,
          total: newData.total,
          totalRows: newData.totalRows,
          data: [...currentData.data, ...newData.data],
        ),
      );
    } catch (e, stack) {
      _page--;
      state = AsyncValue.error(e, stack);
    }
  }
}

final paginatedMonitoringMedicineStockProvider =
    AsyncNotifierProvider.autoDispose<
      MonitoringMedicineStockNotifier,
      BaseResponse<MonitoringTypeItemModel>
    >(MonitoringMedicineStockNotifier.new);

class AnimalHealthCheckMedicinesNotifier
    extends AutoDisposeAsyncNotifier<BaseResponse<MonitoringTypeItemModel>> {
  int _page = 1;
  final int _perPage = 15;
  bool _hasMore = true;

  @override
  Future<BaseResponse<MonitoringTypeItemModel>> build() async {
    return _fetchPage(1);
  }

  Future<BaseResponse<MonitoringTypeItemModel>> _fetchPage(int page) async {
    final dio = ref.read(dioProvider);

    final res = await dio.get(
      '/monitoring/animal-health-check/medicines',
      queryParameters: {'page': page, 'per_page': _perPage},
    );

    return BaseResponse<MonitoringTypeItemModel>.fromJson(
      res.data,
      (json) => MonitoringTypeItemModel.fromJson(json),
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading || state.hasError) return;

    final currentData = state.value;
    if (currentData == null) return;

    _page++;
    try {
      final newData = await _fetchPage(_page);
      _hasMore = newData.data.isNotEmpty;
      state = AsyncValue.data(
        BaseResponse(
          status: newData.status,
          message: newData.message,
          total: newData.total,
          totalRows: newData.totalRows,
          data: [...currentData.data, ...newData.data],
        ),
      );
    } catch (e, stack) {
      _page--;
      state = AsyncValue.error(e, stack);
    }
  }
}

final paginatedAnimalHealthCheckMedicinesProvider =
    AsyncNotifierProvider.autoDispose<
      AnimalHealthCheckMedicinesNotifier,
      BaseResponse<MonitoringTypeItemModel>
    >(AnimalHealthCheckMedicinesNotifier.new);

final monitoringSearchProvider = StateProvider<String>((ref) => '');

final dummyItem = Monitoring(
  code: '29 Dec 2025',
  count: 100,
  subtitle: 'Pakan',
  total: 0,
  status: ItemStatus.feed,
  date: DateTime.now(),
  title: 'Nina Sari • 0861-2345-6789',
  location: 'Satuan Ember',
  description: "Satuan Ember",
  items: [],
);

final items = [
  MonitoringItem(
    id: '1',
    code: 'Andre',
    subtitle: '100 Pakan',
    age: '14 Bulan',
    weight: '315 kg',
    cutWeight: '31.5 kg',
    price: 23000000,
    vaccine: 'Vaksin 12/',
    note: 'Ini adalah baris catatan',
    status: MonitoringItemStatus.checked,
  ),
  MonitoringItem(
    id: '2',
    code: 'Andre',
    subtitle: '100 Pakan',
    age: '14 Bulan',
    weight: '10 kg',
    cutWeight: '10 kg',
    price: 8000000,
    note: 'Ini adalah baris catatan',
    status: MonitoringItemStatus.checked,
  ),
];

final monitoringListProvider = FutureProvider<List<Monitoring>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));

  return [
    Monitoring(
      code: "FMON-2511-00007",
      subtitle: "Sapi Jawara",
      status: ItemStatus.confirmed,
      count: 2,
      total: 2,
      date: DateTime(2025, 11, 14),
      items: items,
    ),
    Monitoring(
      code: "FMON-2511-00006",
      subtitle: "Sapi Jawara",
      status: ItemStatus.confirmed,
      count: 1,
      total: 1,
      date: DateTime(2025, 11, 14),
      items: items,
    ),

    // ================= 13 NOV 2025 =================
    Monitoring(
      code: "FMON-2511-00004",
      subtitle: "Sapi Jawara",
      status: ItemStatus.waiting,
      count: 1,
      total: 1,
      date: DateTime(2025, 11, 13),
      items: items,
    ),
    Monitoring(
      code: "FMON-2511-00005",
      subtitle: "Sapi Jawara",
      status: ItemStatus.received,
      count: 1,
      total: 1,
      date: DateTime(2025, 11, 13),
      items: items,
    ),

    Monitoring(
      code: "FMON-2511-00003",
      subtitle: "Sapi Jawara",
      status: ItemStatus.received,
      count: 1,
      total: 1,
      date: DateTime(2025, 11, 12),
      items: items,
    ),
  ];
});

final filteredMonitoringProvider = Provider<AsyncValue<List<Monitoring>>>((
  ref,
) {
  final filter = ref.watch(itemFilterProvider);
  final keyword = ref.watch(monitoringSearchProvider);
  final listAsync = ref.watch(monitoringListProvider);

  return listAsync.whenData((list) {
    return list.where((item) {
      final matchSearch = item.code.toLowerCase().contains(
        keyword.toLowerCase(),
      );

      final matchFilter = filter == ItemFilter.feed;

      return matchSearch && matchFilter;
    }).toList();
  });
});
