import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_list_model.dart';
import 'package:livestock/features/sales_order/sales_order_provider.dart';

final latestSalesOrderProvider = FutureProvider.autoDispose<List<SalesOrderList>>(
  (ref) async {
    final api = ref.read(salesOrderApiProvider);
    final list = await api.getSalesOrder(status: 'all');

    // Sort by createdAt desc to get newest first
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return list.take(5).toList();
  },
);
