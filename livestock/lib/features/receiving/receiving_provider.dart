import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/constant/enum.dart';
import 'package:livestock/features/receiving/data/receiving_model.dart';

import '../../app/providers.dart';
import 'data/receiving_item_model.dart';

final receivingSearchProvider = StateProvider<String>((ref) => '');

final dummyItem = Receiving(
  code: 'POH-2511-0009',
  count: 2,
  subtitle: 'Lunas',
  total: 2,
  status: ItemStatus.confirmed,
  date: DateTime.now(),
  title: 'Ahmad Umar',
  location: 'Nama Pemasok',
  description: "Tanggal Pembelian",
  items: [],
);

final items = [
  ReceivingItem(
    id: '1',
    code: 'BLK-0891',
    subtitle: 'Limosin • Jantan • Sapi Besar',
    age: '14 Bulan',
    weight: '315 kg',
    cutWeight: '31.5 kg',
    price: 23000000,
    vaccine: 'Vaksin 12/7',
    note: 'Ini adalah baris catatan',
    status: ReceivingItemStatus.checked,
  ),
  ReceivingItem(
    id: '2',
    code: 'KBG-0892',
    subtitle: 'Limosin • Jantan • Sapi Besar',
    age: '14 Bulan',
    weight: '10 kg',
    cutWeight: '10 kg',
    price: 8000000,
    note: 'Ini adalah baris catatan',
    status: ReceivingItemStatus.checked,
  ),
];

final receivingListProvider = FutureProvider<List<Receiving>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));

  return [
    // ================= 14 NOV 2025 =================
    Receiving(
      code: "RECV-2511-0018",
      subtitle: "2 hewan • Sapi Jawara",
      status: ItemStatus.received,
      total: 2,
      date: DateTime(2025, 11, 14),
      items: items,
    ),
    Receiving(
      code: "RECV-2511-0017",
      subtitle: "1 hewan • Sapi Jawara",
      status: ItemStatus.received,
      total: 1,
      date: DateTime(2025, 11, 14),
      items: items,
    ),

    // ================= 13 NOV 2025 =================
    Receiving(
      code: "RECV-2511-0016",
      subtitle: "1 hewan • Sapi Jawara",
      status: ItemStatus.waiting,
      total: 1,
      date: DateTime(2025, 11, 13),
      items: items,
    ),
    Receiving(
      code: "RECV-2511-0015",
      subtitle: "1 hewan • Sapi Jawara",
      status: ItemStatus.received,
      total: 1,
      date: DateTime(2025, 11, 13),
      items: items,
    ),

    // ================= 12 NOV 2025 =================
    Receiving(
      code: "RECV-2511-0014",
      subtitle: "1 hewan • Sapi Jawara",
      status: ItemStatus.received,
      total: 1,
      date: DateTime(2025, 11, 12),
      items: items,
    ),
  ];
});

final filteredReceivingProvider = Provider<AsyncValue<List<Receiving>>>((ref) {
  final filter = ref.watch(itemFilterProvider);
  final keyword = ref.watch(receivingSearchProvider);
  final listAsync = ref.watch(receivingListProvider);

  return listAsync.whenData((list) {
    return list.where((item) {
      final matchSearch = item.code.toLowerCase().contains(
        keyword.toLowerCase(),
      );

      final matchFilter = filter == ItemFilter.product;

      return matchSearch && matchFilter;
    }).toList();
  });
});
