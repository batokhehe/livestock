import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../user/providers/user_provider.dart';

import '../../../../core/theme/AppImages.dart';
import 'menu_button_card.dart';

class QuickMenuItem {
  final String image;
  final String label;
  final String route;

  const QuickMenuItem({
    required this.image,
    required this.label,
    required this.route,
  });
}

class QuickMenu extends ConsumerWidget {
  const QuickMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => const SizedBox(),
      error: (e, _) => Text("Error: $e"),
      data: (user) {
        final menus = [
          if (user?.hasPermission('purchorders-read') ?? false)
            const QuickMenuItem(
              image: AppImages.icDocumentForward,
              label: 'Pembelian',
              route: '/purchase-order',
            ),
          if (user?.hasPermission('receiving-read') ?? false)
            const QuickMenuItem(
              image: AppImages.icClipboardImport,
              label: 'Penerimaan',
              route: '/receiving',
            ),
          if (user?.hasPermission('salesorder-read') ?? false)
            const QuickMenuItem(
              image: AppImages.icDocumentPrevious,
              label: 'Penjualan',
              route: '/sales-order',
            ),
        ];

        if (menus.isEmpty) return const SizedBox();

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 4 / 3,
            crossAxisSpacing: 12,
          ),
          itemCount: menus.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final menu = menus[index];
            return MenuButton(
              menu.image,
              menu.label,
              onTap: () => context.push(menu.route),
            );
          },
        );
      },
    );
  }
}
