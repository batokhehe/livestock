import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/network/dio_client.dart';
import 'package:livestock/features/dashboard/data/dashboard_api.dart';
import 'package:livestock/features/dashboard/data/models/dashboard_monitoring_model.dart';
import 'package:livestock/features/dashboard/data/models/dashboard_operational_model.dart';
import 'package:livestock/features/dashboard/data/models/dashboard_sales_model.dart';
import 'package:livestock/features/sales_order/data/model/sales_invoice_model.dart';
import 'package:livestock/features/sales_order/sales_order_provider.dart';

final dashboardApiProvider = Provider((ref) {
  return DashboardApi(ref.read(dioProvider));
});

final dashboardSalesProvider = FutureProvider.autoDispose<DashboardSalesModel>((ref) async {
  return ref.read(dashboardApiProvider).getDashboardSales();
});

final dashboardOperationalProvider = FutureProvider.autoDispose<DashboardOperationalModel>((ref) async {
  return ref.read(dashboardApiProvider).getDashboardOperational();
});

final dashboardMonitoringProvider = FutureProvider.autoDispose<DashboardMonitoringModel>((ref) async {
  return ref.read(dashboardApiProvider).getDashboardMonitoring();
});

final latestSalesOrderProvider = FutureProvider.autoDispose<List<SalesInvoice>>((ref) async {
  final api = ref.read(salesOrderApiProvider);
  final allInvoices = await api.getSalesInvoicesList();
  return allInvoices.take(5).toList();
});
