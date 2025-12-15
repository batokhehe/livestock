import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/welcome_page.dart';

import '../features/auth/presentation/views/login_page.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/home/presentation/views/home_page.dart';
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
      GoRoute(path: "/home", builder: (_, __) => const HomePage()),
    ],
  );
});
