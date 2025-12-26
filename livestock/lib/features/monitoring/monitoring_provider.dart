import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/monitoring_item_model.dart';
import 'data/monitoring_model.dart';


final monitoringFilterProvider = StateProvider<MonitoringFilter>((ref) {
  return MonitoringFilter.product;
});

final monitoringSearchProvider = StateProvider<String>((ref) => '');

final dummyItem = Monitoring(
  code: 'POH-2511-0009',
  count: 2,
  subtitle: 'Lunas',
  total: 2,
  status: MonitoringStatus.confirmed,
  date: DateTime.now(),
  title: 'Ahmad Umar',
  location: 'Nama Pemasok',
  description: "Tanggal Pembelian",
  items: [],
);

final items = [
  MonitoringItem(
    id: '1',
    code: 'BLK-0891',
    subtitle: 'Limosin • Jantan • Sapi Besar',
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
    code: 'KBG-0892',
    subtitle: 'Limosin • Jantan • Sapi Besar',
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
      code: "RECV-2511-0018",
      subtitle: "2 hewan • Sapi Jawara",
      status: MonitoringStatus.received,
      total: 2,
      date: DateTime(2025, 11, 14),
      items: items,
    ),
    Monitoring(
      code: "RECV-2511-0017",
      subtitle: "1 hewan • Sapi Jawara",
      status: MonitoringStatus.received,
      total: 1,
      date: DateTime(2025, 11, 14),
      items: items,
    ),

    // ================= 13 NOV 2025 =================
    Monitoring(
      code: "RECV-2511-0016",
      subtitle: "1 hewan • Sapi Jawara",
      status: MonitoringStatus.waiting,
      total: 1,
      date: DateTime(2025, 11, 13),
      items: items,
    ),
    Monitoring(
      code: "RECV-2511-0015",
      subtitle: "1 hewan • Sapi Jawara",
      status: MonitoringStatus.received,
      total: 1,
      date: DateTime(2025, 11, 13),
      items: items,
    ),

    Monitoring(
      code: "RECV-2511-0014",
      subtitle: "1 hewan • Sapi Jawara",
      status: MonitoringStatus.received,
      total: 1,
      date: DateTime(2025, 11, 12),
      items: items,
    ),
  ];
});

final filteredMonitoringProvider = Provider<AsyncValue<List<Monitoring>>>((ref) {
  final filter = ref.watch(monitoringFilterProvider);
  final keyword = ref.watch(monitoringSearchProvider);
  final listAsync = ref.watch(monitoringListProvider);

  return listAsync.whenData((list) {
    return list.where((item) {
      final matchSearch = item.code.toLowerCase().contains(
        keyword.toLowerCase(),
      );

      final matchFilter = filter == MonitoringFilter.product;

      return matchSearch && matchFilter;
    }).toList();
  });
});
