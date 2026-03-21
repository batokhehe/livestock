import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/attendance/presentation/views/employee_attendance_page.dart';
import 'package:livestock/features/attendance/presentation/views/employee_overnight_page.dart';
import 'package:livestock/features/dashboard/presentation/views/dashboard_page.dart';
import 'package:livestock/features/dispatch/presentation/views/add_dispatch_page.dart';
import 'package:livestock/features/dispatch/presentation/views/dispatch_page.dart';
import 'package:livestock/features/home/presentation/views/home_page.dart';
import 'package:livestock/features/monitoring/presentation/views/add_monitoring_confirmation_page.dart';
import 'package:livestock/features/monitoring/presentation/views/add_monitoring_page.dart';
import 'package:livestock/features/product/presentation/views/product_detail_page.dart';
import 'package:livestock/features/product/presentation/views/product_page.dart';
import 'package:livestock/features/product/presentation/views/update_product_page.dart';
import 'package:livestock/features/purchase_order/presentation/views/add_purchase_order_confirmation_page.dart';
import 'package:livestock/features/purchase_order/presentation/views/add_purchase_order_page.dart';
import 'package:livestock/features/purchase_order/presentation/views/add_purchase_order_step_2_page.dart';
import 'package:livestock/features/purchase_order/presentation/views/purchase_order_page.dart';
import 'package:livestock/features/receiving/presentation/views/add_receiving_confirmation_page.dart';
import 'package:livestock/features/receiving/presentation/views/receiving_detail_page.dart';
import 'package:livestock/features/sales_order/presentation/views/add_sales_order_confirmation_page.dart';
import 'package:livestock/features/sales_order/presentation/views/add_sales_order_page.dart';
import 'package:livestock/features/sales_order/presentation/views/add_sales_order_step_2_page.dart';
import 'package:livestock/features/sales_order/presentation/views/sales_order_page.dart';
import 'package:livestock/features/welcome_page.dart';

import '../features/attendance/presentation/views/history_attendance_page.dart';
import '../features/attendance/presentation/views/history_detail_attendance_page.dart';
import '../features/auth/presentation/views/login_page.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/dispatch/presentation/views/add_dispatch_confirmation_page.dart';
import '../features/dispatch/presentation/views/add_dispatch_step_2_page.dart';
import '../features/home/presentation/views/main_page.dart';
import '../features/monitoring/presentation/views/add_monitoring_step_2_page.dart';
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
      ),
      GoRoute(path: "/home", builder: (_, __) => const HomePage()),
      GoRoute(path: "/dashboard", builder: (_, __) => const DashboardPage()),
      GoRoute(
        path: '/product',
        builder: (context, state) => const ProductPage(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailPage(productId: id);
        },
      ),
      GoRoute(
        path: "/product-update",
        builder: (_, __) => const UpdateProductPage(),
      ),
      GoRoute(
        path: '/receiving',
        builder: (context, state) => const ReceivingPage(),
      ),
      GoRoute(
        path: '/receiving/add',
        builder: (context, state) => const AddReceivingPage(),
      ),
      GoRoute(
        path: '/receiving/add/step-2',
        builder: (context, state) {
          final ReceivingPo item = state.extra as ReceivingPo;
          return AddReceivingStep2Page(item: item);
        },
      ),
      GoRoute(
        path: '/receiving/add/confirmation',
        builder: (context, state) => const AddReceivingConfirmationPage(),
      ),
      GoRoute(
        path: '/receiving/detail/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ReceivingDetailPage(receivingId: id);
        },
      ),

      GoRoute(
        path: '/monitoring',
        builder: (context, state) => const MonitoringPage(),
      ),
      GoRoute(
        path: '/monitoring/add',
        builder: (context, state) => const AddMonitoringPage(),
      ),
      GoRoute(
        path: '/monitoring/add/step-2',
        builder: (context, state) => const AddMonitoringStep2Page(),
      ),
      GoRoute(
        path: '/monitoring/add/confirmation',
        builder: (context, state) => const AddMonitoringConfirmationPage(),
      ),

      GoRoute(
        path: '/employee-attendance',
        builder: (context, state) => const EmployeeAttendancePage(),
      ),
      GoRoute(
        path: '/history-attendance',
        builder: (context, state) => const HistoryAttendancePage(),
      ),
      GoRoute(
        path: '/history-detail-attendance/:type/:transdate',
        name: 'history-detail-attendance',
        builder: (context, state) {
          final String type = state.pathParameters['type']!;
          final String transDate = state.pathParameters['transdate']!;

          return HistoryDetailAttendancePage(type: type, transDate: transDate);
        },
      ),
      GoRoute(
        path: '/employee-overnight',
        builder: (context, state) => const EmployeeOvernightPage(),
      ),

      GoRoute(
        path: '/sales-order',
        builder: (context, state) => const SalesOrderPage(),
      ),
      GoRoute(
        path: '/sales-order/add',
        builder: (context, state) {
          final type = state.uri.queryParameters['type'];
          return AddSalesOrderPage(type: type);
        },
      ),
      GoRoute(
        path: '/sales-order/add/step-2',
        builder: (context, state) => const AddSalesOrderStep2Page(),
      ),
      GoRoute(
        path: '/sales-order/add/confirmation',
        builder: (context, state) => const AddSalesOrderConfirmationPage(),
      ),
      GoRoute(
        path: '/sales-order/detail/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return SalesOrderDetailPage(id: id);
        },
      ),

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
    ],
  );
});
