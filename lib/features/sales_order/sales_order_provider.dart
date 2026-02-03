import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_client.dart';
import 'data/api/sales_order_api.dart';
import 'data/model/sales_order_list_model.dart';

enum SalesOrderTab { all, sell, confirmed, closed }

extension SalesOrderTabX on SalesOrderTab {
  String get apiValue {
    switch (this) {
      case SalesOrderTab.all:
        return 'all';
      case SalesOrderTab.sell:
        return 'sell';
      case SalesOrderTab.confirmed:
        return 'confirmed';
      case SalesOrderTab.closed:
        return 'closed';
    }
  }

  String get label {
    switch (this) {
      case SalesOrderTab.all:
        return 'Semua';
      case SalesOrderTab.sell:
        return 'Terjual';
      case SalesOrderTab.confirmed:
        return 'Dikonfirmasi';
      case SalesOrderTab.closed:
        return 'Tutup';
    }
  }

  // String get ext {
  //   switch (this) {
  //     case SalesOrderTab.animal:
  //       return 'hewan';
  //     case SalesOrderTab.feed:
  //       return 'item';
  //     case SalesOrderTab.equipment:
  //       return 'item';
  //   }
  // }
}

final salesOrderSearchProvider = StateProvider<String>((ref) => '');

final salesOrderTabProvider = StateProvider<SalesOrderTab>((ref) {
  return SalesOrderTab.all;
});

final salesOrderApiProvider = Provider((ref) {
  return SalesOrderApi(ref.read(dioProvider));
});

final salesOrderListProvider = FutureProvider.autoDispose<List<SalesOrderList>>(
  (ref) async {
    final api = ref.read(salesOrderApiProvider);
    final tab = ref.watch(salesOrderTabProvider);

    return api.getSalesOrder(status: tab.apiValue);
  },
);

final salesOrderDateProvider = StateProvider<DateTime?>(
  (ref) => DateTime.now(),
);

final paymentDateProvider = StateProvider<DateTime?>(
      (ref) => DateTime.now(),
);
