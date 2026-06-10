import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/profile/presentation/views/change_password_page.dart';
import 'package:livestock/features/attendance/presentation/views/employee_attendance_page.dart';
import 'package:livestock/features/attendance/presentation/views/employee_overnight_page.dart';
import 'package:livestock/features/dashboard/presentation/views/dashboard_page.dart';
import 'package:livestock/features/dispatch/presentation/views/add_dispatch_page.dart';
import 'package:livestock/features/dispatch/presentation/views/dispatch_edit_page.dart';
import 'package:livestock/features/dispatch/presentation/views/dispatch_page.dart';
import 'package:livestock/features/home/presentation/views/home_page.dart';
import 'package:livestock/features/monitoring/presentation/views/feed/add_monitoring_feed_page.dart';
import 'package:livestock/features/monitoring/presentation/views/feed/add_monitoring_feed_step_2_page.dart';
import 'package:livestock/features/monitoring/presentation/views/feed/add_monitoring_feed_confirmation_page.dart';
import 'package:livestock/features/monitoring/presentation/views/weight/add_monitoring_weight_page.dart';
import 'package:livestock/features/monitoring/presentation/views/weight/add_monitoring_weight_step_2_page.dart';
import 'package:livestock/features/monitoring/presentation/views/weight/add_monitoring_weight_confirmation_page.dart';
import 'package:livestock/features/monitoring/presentation/views/weight/edit/edit_monitoring_weight_page.dart';
import 'package:livestock/features/monitoring/presentation/views/weight/edit/edit_monitoring_weight_step_2_page.dart';
import 'package:livestock/features/monitoring/presentation/views/weight/edit/edit_monitoring_weight_confirmation_page.dart';
import 'package:livestock/features/monitoring/presentation/views/weight/detail/weight_monitoring_detail_page.dart';
import 'package:livestock/features/monitoring/presentation/views/medicine/detail/medicine_monitoring_detail_page.dart';
import 'package:livestock/features/monitoring/presentation/views/feed/detail/feed_monitoring_detail_page.dart';
import 'package:livestock/features/monitoring/data/weight_monitoring_model.dart';
import 'package:livestock/features/monitoring/presentation/views/medicine/add_monitoring_medicine_page.dart';
import 'package:livestock/features/monitoring/presentation/views/medicine/add_monitoring_medicine_step_2_page.dart';
import 'package:livestock/features/monitoring/presentation/views/medicine/add_monitoring_medicine_confirmation_page.dart';
import 'package:livestock/features/monitoring/presentation/views/health/add_monitoring_health_page.dart';
import 'package:livestock/features/monitoring/presentation/views/health/add_monitoring_health_step_2_page.dart';
import 'package:livestock/features/monitoring/presentation/views/health/add_monitoring_health_confirmation_page.dart';
import 'package:livestock/features/monitoring/presentation/views/health/detail/animal_health_check_detail_page.dart';
import 'package:livestock/features/product/presentation/views/product_detail_page.dart';
import 'package:livestock/features/product/presentation/views/product_page.dart';
import 'package:livestock/features/product/presentation/views/update_product_page.dart';
import 'package:livestock/features/purchase_order/presentation/views/add_purchase_order_confirmation_page.dart';
import 'package:livestock/features/purchase_order/presentation/views/add_purchase_order_page.dart';
import 'package:livestock/features/purchase_order/presentation/views/add_purchase_order_step_2_page.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_list_model.dart';
import 'package:livestock/features/purchase_order/presentation/views/edit_purchase_order/edit_purchase_order_confirmation_page.dart';
import 'package:livestock/features/purchase_order/presentation/views/edit_purchase_order/edit_purchase_order_page.dart';
import 'package:livestock/features/purchase_order/presentation/views/edit_purchase_order/edit_purchase_order_step_2_page.dart';
import 'package:livestock/features/purchase_order/presentation/views/purchase_order_page.dart';
import 'package:livestock/features/purchase_order/presentation/views/create_invoice/create_purchase_order_invoice_page.dart';
import 'package:livestock/features/receiving/presentation/views/add_receiving_confirmation_page.dart';
import 'package:livestock/features/receiving/presentation/views/receiving_detail_page.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_detail_model.dart';
import 'package:livestock/features/sales_order/presentation/views/add_sales_order_confirmation_page.dart';
import 'package:livestock/features/sales_order/presentation/views/add_sales_order_page.dart';
import 'package:livestock/features/sales_order/presentation/views/add_sales_order_step_2_page.dart';
import 'package:livestock/features/sales_order/presentation/views/create_invoice/create_invoice_page.dart';
import 'package:livestock/features/sales_order/presentation/views/edit_sales_order/edit_sales_order_confirmation_page.dart';
import 'package:livestock/features/sales_order/presentation/views/edit_sales_order/edit_sales_order_page.dart';
import 'package:livestock/features/sales_order/presentation/views/edit_sales_order/edit_sales_order_step_2_page.dart';
import 'package:livestock/features/sales_order/presentation/views/sales_order_page.dart';
import 'package:livestock/features/welcome_page.dart';
import 'package:livestock/features/transfer/presentation/views/transfer_page.dart';


import '../features/attendance/presentation/views/history_attendance_page.dart';
import '../features/attendance/presentation/views/history_detail_attendance_page.dart';
import '../features/auth/presentation/views/login_page.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/dispatch/presentation/views/add_dispatch_confirmation_page.dart';
import '../features/dispatch/presentation/views/add_dispatch_step_2_page.dart';
import '../features/dispatch/presentation/views/dispatch_detail_page.dart';
import '../features/home/presentation/views/main_page.dart';
import '../features/monitoring/presentation/views/monitoring_page.dart';
import '../features/purchase_order/presentation/views/purchase_order_detail_page.dart';
import '../features/receiving/data/model/receiving_po_model.dart';
import '../features/receiving/presentation/views/add_receiving_page.dart';
import '../features/receiving/presentation/views/add_receiving_step_2_page.dart';
import '../features/receiving/presentation/views/receiving_page.dart';
import '../features/sales_order/presentation/views/sales_order_detail_page.dart';
import '../features/splash_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final rootNavigatorKey = GlobalKey<NavigatorState>();

final hasShownSplashProvider = StateProvider<bool>((ref) => false);
final mainPageKey = GlobalKey<MainPageState>();

final routerProvider = Provider<GoRouter>((ref) {
  final hasShownSplash = ref.watch(hasShownSplashProvider);
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: "/splash",
    observers: [ChuckerFlutter.navigatorObserver],
    navigatorKey: rootNavigatorKey,
    redirect: (context, state) {
      final atSplash = state.matchedLocation == "/splash";
      final atWelcome = state.matchedLocation == "/welcome";
      final atLogin = state.matchedLocation == "/login";

      if (!hasShownSplash) {
        return atSplash ? null : "/splash";
      }

      if (hasShownSplash && authState == false && !atWelcome && !atLogin) {
        return "/welcome";
      }

      if (authState == false && !atLogin && !atWelcome) {
        return "/login";
      }

      if (authState == true && (atSplash || atWelcome || atLogin)) {
        return "/";
      }

      return null;
    },
    routes: [
      GoRoute(path: "/splash", builder: (_, __) => const SplashPage()),
      GoRoute(path: "/welcome", builder: (_, __) => const WelcomePage()),
      GoRoute(path: "/login", builder: (_, __) => const LoginPage()),
      GoRoute(
        path: "/",
        builder: (_, __) => MainPage(key: mainPageKey),
        routes: [
          GoRoute(path: 'dashboard', builder: (_, __) => const DashboardPage()),
          GoRoute(
            path: 'product',
            builder: (context, state) => const ProductPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ProductDetailPage(productId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: "product-update",
            builder: (_, __) => const UpdateProductPage(),
          ),
          GoRoute(
            path: 'receiving',
            builder: (context, state) => const ReceivingPage(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddReceivingPage(),
              ),
              GoRoute(
                path: 'add/step-2',
                builder: (context, state) {
                  final ReceivingPo item = state.extra as ReceivingPo;
                  return AddReceivingStep2Page(item: item);
                },
              ),
              GoRoute(
                path: 'add/confirmation',
                builder: (context, state) =>
                    const AddReceivingConfirmationPage(),
              ),
              GoRoute(
                path: 'detail/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return ReceivingDetailPage(receivingId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'monitoring',
            builder: (context, state) => const MonitoringPage(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) {
                  final type = state.uri.queryParameters['type'] ?? 'feed';
                  switch (type) {
                    case 'weight': return const AddMonitoringWeightPage();
                    case 'medicine': return const AddMonitoringMedicinePage();
                    case 'health': return const AddMonitoringHealthPage();
                    default: return const AddMonitoringFeedPage();
                  }
                },
              ),
              GoRoute(
                path: 'add/step-2',
                builder: (context, state) {
                  final type = state.uri.queryParameters['type'] ?? 'feed';
                  switch (type) {
                    case 'weight': return const AddMonitoringWeightStep2Page();
                    case 'medicine': return const AddMonitoringMedicineStep2Page();
                    case 'health': return const AddMonitoringHealthStep2Page();
                    default: return const AddMonitoringFeedStep2Page();
                  }
                },
              ),
              GoRoute(
                path: 'add/confirmation',
                builder: (context, state) {
                  final type = state.uri.queryParameters['type'] ?? 'feed';
                  switch (type) {
                    case 'weight': return const AddMonitoringWeightConfirmationPage();
                    case 'medicine': return const AddMonitoringMedicineConfirmationPage();
                    case 'health': return const AddMonitoringHealthConfirmationPage();
                    default: return const AddMonitoringFeedConfirmationPage();
                  }
                },
              ),
              GoRoute(
                path: 'detail/weight',
                builder: (context, state) {
                  final item = state.extra as WeightMonitoring;
                  return WeightMonitoringDetailPage(item: item);
                },
              ),
              GoRoute(
                path: 'detail/medicine/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return MedicineMonitoringDetailPage(id: id);
                },
              ),
              GoRoute(
                path: 'detail/health/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AnimalHealthCheckDetailPage(id: id);
                },
              ),
              GoRoute(
                path: 'detail/feed/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return FeedMonitoringDetailPage(id: id);
                },
              ),

              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  final item = state.extra as WeightMonitoring;
                  return EditMonitoringWeightPage(item: item);
                },
              ),
              GoRoute(
                path: 'edit/step-2',
                builder: (context, state) {
                  final item = state.extra as WeightMonitoring;
                  return EditMonitoringWeightStep2Page(item: item);
                },
              ),
              GoRoute(
                path: 'edit/confirmation',
                builder: (context, state) {
                  final item = state.extra as WeightMonitoring;
                  return EditMonitoringWeightConfirmationPage(item: item);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'employee-attendance',
            builder: (context, state) => const EmployeeAttendancePage(),
          ),
          GoRoute(
            path: 'history-attendance',
            builder: (context, state) => const HistoryAttendancePage(),
          ),
          GoRoute(
            path: 'history-detail-attendance/:type/:transdate/:id',
            name: 'history-detail-attendance',
            builder: (context, state) {
              final String type = state.pathParameters['type']!;
              final String transDate = state.pathParameters['transdate']!;
              final String id = state.pathParameters['id']!;

              final extra = state.extra as Map<String, dynamic>?;
              final String? additionalInformation = extra?['additional_information'];

              return HistoryDetailAttendancePage(
                type: type,
                transDate: transDate,
                id: id,
                additionalInformation: additionalInformation,
              );
            },
          ),
          GoRoute(
            path: 'employee-overnight',
            builder: (context, state) => const EmployeeOvernightPage(),
          ),
          GoRoute(
            path: 'sales-order',
            builder: (context, state) => const SalesOrderPage(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) {
                  final type = state.uri.queryParameters['type'];
                  return AddSalesOrderPage(type: type);
                },
              ),
              GoRoute(
                path: 'add/step-2',
                builder: (context, state) => const AddSalesOrderStep2Page(),
              ),
              GoRoute(
                path: 'add/confirmation',
                builder: (context, state) =>
                    const AddSalesOrderConfirmationPage(),
              ),
              GoRoute(
                path: 'detail/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return SalesOrderDetailPage(id: id);
                },
              ),
              GoRoute(
                path: 'create-invoice',
                builder: (context, state) {
                  final item = state.extra as SalesOrderDetail;
                  return CreateInvoicePage(item: item);
                },
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  final detail = state.extra as SalesOrderDetail;
                  return EditSalesOrderPage(detail: detail);
                },
              ),
              GoRoute(
                path: 'edit/step-2',
                builder: (context, state) {
                  final detail = state.extra as SalesOrderDetail;
                  return EditSalesOrderStep2Page(detail: detail);
                },
              ),
              GoRoute(
                path: 'edit/confirmation',
                builder: (context, state) {
                  final detail = state.extra as SalesOrderDetail;
                  return EditSalesOrderConfirmationPage(detail: detail);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'change-password',
            builder: (context, state) => const ChangePasswordPage(),
          ),
        ],
      ),
      GoRoute(path: "/home", builder: (_, __) => const HomePage()),

      GoRoute(
        path: '/purchase-order',
        builder: (context, state) => const PurchaseOrderPage(),
      ),
      GoRoute(
        path: '/purchase-order/add',
        builder: (context, state) {
          final type = state.uri.queryParameters['type'];
          return AddPurchaseOrderPage(type: type);
        },
      ),
      GoRoute(
        path: '/purchase-order/add/step-2',
        builder: (context, state) => const AddPurchaseOrderStep2Page(),
      ),
      GoRoute(
        path: '/purchase-order/add/confirmation',
        builder: (context, state) => const AddPurchaseOrderConfirmationPage(),
      ),
      GoRoute(
        path: '/purchase-order/detail/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PurchaseOrderDetailPage(id: id);
        },
      ),
      GoRoute(
        path: '/purchase-order/edit',
        builder: (context, state) {
          final data = state.extra as PurchaseOrderList;
          return EditPurchaseOrderPage(data: data);
        },
      ),
      GoRoute(
        path: '/purchase-order/edit/step-2',
        builder: (context, state) {
          final data = state.extra as PurchaseOrderList;
          return EditPurchaseOrderStep2Page(data: data);
        },
      ),
      GoRoute(
        path: '/purchase-order/edit/confirmation',
        builder: (context, state) {
          final data = state.extra as PurchaseOrderList;
          return EditPurchaseOrderConfirmationPage(data: data);
        },
      ),
      GoRoute(
        path: '/purchase-order/create-invoice',
        builder: (context, state) {
          final data = state.extra as PurchaseOrderList;
          return CreatePurchaseOrderInvoicePage(item: data);
        },
      ),

      GoRoute(
        path: '/dispatch',
        builder: (context, state) => const DispatchPage(),
      ),
      GoRoute(
        path: '/dispatch/add',
        builder: (context, state) => const AddDispatchPage(),
      ),
      GoRoute(
        path: '/dispatch/add/step-2',
        builder: (context, state) => const AddDispatchStep2Page(),
      ),
      GoRoute(
        path: '/dispatch/add/confirmation',
        builder: (context, state) => const AddDispatchConfirmationPage(),
      ),
      GoRoute(
        path: '/dispatch/detail/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DispatchDetailPage(id: id);
        },
      ),
      GoRoute(
        path: '/dispatch/edit/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DispatchEditPage(id: id);
        },
      ),
      GoRoute(
        path: '/transfer',
        builder: (context, state) => const TransferPage(),
      ),
    ],
  );
});
