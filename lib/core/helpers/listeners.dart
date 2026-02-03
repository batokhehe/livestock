import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../errors/unauthorized_exception.dart';

class GlobalAuthListener extends ConsumerWidget {
  final Widget child;

  const GlobalAuthListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<UnauthorizedException?>(unauthorizedProvider, (prev, next) {
      if (next != null) {
        final navContext = rootNavigatorKey.currentContext;

        if (navContext == null) return;

        showDialog(
          context: navContext,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Sesi Berakhir"),
            content: Text(next.message),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(navContext).pop();

                  ref.read(logoutProvider).call();

                  ref.read(unauthorizedProvider.notifier).state = null;

                  navContext.go('/login');
                },
                child: const Text("Login Ulang"),
              ),
            ],
          ),
        );
      }
    });

    return child;
  }
}
