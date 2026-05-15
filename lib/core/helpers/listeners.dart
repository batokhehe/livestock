import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../errors/unauthorized_exception.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

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
          builder: (_) => Dialog(
            insetPadding: EdgeInsets.all(16),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/icons/ic_logout_confirmation.png',
                    height: 120,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Sesi Berakhir",
                    style: AppTypography.largeBoldBlack.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Sesi Anda telah berakhir",
                    style: AppTypography.smallNormalGrey,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.of(navContext).pop();
                        ref.read(logoutProvider).call();
                        ref.read(unauthorizedProvider.notifier).state = null;
                        navContext.go('/login');
                      },
                      child: const Text(
                        "Login Ulang",
                        style: AppTypography.mediumBoldWhite,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      }
    });

    return child;
  }
}
