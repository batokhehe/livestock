import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

class QuickMenu extends StatelessWidget {
  const QuickMenu({super.key});

  static const List<QuickMenuItem> _menus = [
    QuickMenuItem(
      image: AppImages.icDocumentForward,
      label: 'Pembelian',
      route: '/purchase-order',
    ),
    QuickMenuItem(
      image: AppImages.icClipboardImport,
      label: 'Penerimaan',
      route: '/receiving',
    ),
    QuickMenuItem(
      image: AppImages.icDocumentPrevious,
      label: 'Penjualan',
      route: '/sales-order',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 4 / 3,
        crossAxisSpacing: 12,
      ),
      itemCount: _menus.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final menu = _menus[index];
        return MenuButton(
          menu.image,
          menu.label,
          onTap: () => context.push(menu.route),
        );
      },
    );
  }
}
