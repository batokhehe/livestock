import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/constant/enum.dart';
import 'package:livestock/features/monitoring/data/api/monitoring_api.dart';

import '../../app/providers.dart';
import '../attendance/data/model/employee_model.dart';
import 'data/monitoring_item_model.dart';
import 'data/monitoring_model.dart';

final monitoringApiProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return MonitoringApi(dio);
});

// Weight monitoring list filters
final weightMonitoringSearchProvider = StateProvider.autoDispose<String>((ref) => '');
final weightMonitoringTypeProvider = StateProvider.autoDispose<String>((ref) => '');
final feedMonitoringSearchProvider = StateProvider.autoDispose<String>((ref) => '');
final healthMonitoringSearchProvider = StateProvider.autoDispose<String>((ref) => '');


final selectedMonitoringEmployeeProvider = StateProvider.autoDispose<Employee?>((ref) => null);
final selectedMonitoringDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final addedMonitoringWeightItemsProvider = StateProvider.autoDispose<List<MonitoringItem>>((ref) => []);

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
