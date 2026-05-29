import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/constant/enum.dart';
import 'package:livestock/features/monitoring/data/api/monitoring_api.dart';
import 'package:livestock/core/data/model/base_response.dart';
import 'package:livestock/features/monitoring/data/monitoring_type_item_model.dart';

import '../../app/providers.dart';
import '../attendance/data/model/employee_model.dart';
import 'data/monitoring_item_model.dart';
import 'data/monitoring_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';

final selectedMonitoringEmployeeProvider = StateProvider.autoDispose<Employee?>(
  (ref) => null,
);
final selectedMonitoringDateProvider = StateProvider.autoDispose<DateTime?>(
  (ref) => null,
);

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
      '/master/animal-profile/available-count',
      queryParameters: {'farm_location_id': farmId, 'farm_area_id': areaId}
        ..removeWhere((k, v) => v == null),
    );

    final responseData = res.data;
    if (responseData is int) return responseData;
    if (responseData is String) return int.tryParse(responseData) ?? 0;

    if (responseData is Map) {
      final dataField = responseData['data'];

      if (dataField is int) return dataField;
      if (dataField is String) return int.tryParse(dataField) ?? 0;

      if (dataField is Map) {
        if (dataField['count'] != null)
          return int.tryParse(dataField['count'].toString()) ?? 0;
        if (dataField['available_count'] != null)
          return int.tryParse(dataField['available_count'].toString()) ?? 0;
        if (dataField['total'] != null)
          return int.tryParse(dataField['total'].toString()) ?? 0;
      }

      if (responseData['total'] != null)
        return int.tryParse(responseData['total'].toString()) ?? 0;
      if (responseData['count'] != null)
        return int.tryParse(responseData['count'].toString()) ?? 0;
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
