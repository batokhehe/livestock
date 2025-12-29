import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/dashboard/presentation/views/dashboard_page.dart';
import 'package:livestock/features/monitoring/presentation/views/add_monitoring_confirmation_page.dart';
import 'package:livestock/features/monitoring/presentation/views/add_monitoring_page.dart';
import 'package:livestock/features/product/presentation/views/product_detail_page.dart';
import 'package:livestock/features/product/presentation/views/update_product_page.dart';
import 'package:livestock/features/receiving/presentation/views/add_receiving_confirmation_page.dart';
import 'package:livestock/features/receiving/presentation/views/receiving_detail_page.dart';
import 'package:livestock/features/welcome_page.dart';

import '../features/auth/presentation/views/login_page.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/home/presentation/views/main_page.dart';
import '../features/monitoring/presentation/views/add_monitoring_step_2_page.dart';
import '../features/monitoring/presentation/views/monitoring_page.dart';
import '../features/receiving/data/receiving_model.dart';
import '../features/receiving/presentation/views/add_receiving_page.dart';
import '../features/receiving/presentation/views/add_receiving_step_2_page.dart';
import '../features/receiving/presentation/views/receiving_page.dart';
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

final hasShownSplashProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>((ref) {
  final hasShownSplash = ref.watch(hasShownSplashProvider);
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: "/splash",

    observers: [ChuckerFlutter.navigatorObserver],

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
        return "/home";
      }

      return null;
    },
    routes: [
      GoRoute(path: "/splash", builder: (_, __) => const SplashPage()),
      GoRoute(path: "/welcome", builder: (_, __) => const WelcomePage()),
      GoRoute(path: "/login", builder: (_, __) => const LoginPage()),
      GoRoute(path: "/home", builder: (_, __) => const MainPage()),
      GoRoute(path: "/dashboard", builder: (_, __) => const DashboardPage()),
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
        builder: (context, state) => const AddReceivingStep2Page(),
      ),
      GoRoute(
        path: '/receiving/add/confirmation',
        builder: (context, state) => const AddReceivingConfirmationPage(),
      ),
      GoRoute(
        path: '/receiving/detail',
        builder: (context, state) {
          final receiving = state.extra as Receiving;
          return ReceivingDetailPage(receiving: receiving);
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
    ],
  );
});
