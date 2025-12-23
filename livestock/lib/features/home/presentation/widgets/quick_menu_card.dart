import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/AppImages.dart';
import 'menu_button_card.dart';

class QuickMenu extends StatelessWidget {
  const QuickMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MenuButton(
          AppImages.icDocumentForward,
          "Pembelian",
          onTap: () => context.push('/purchase'),
        ),
        MenuButton(
          AppImages.icClipboardImport,
          "Penerimaan",
          onTap: () => context.push('/receiving'),
        ),
        MenuButton(
          AppImages.icDocumentPrevious,
          "Penjualan",
          onTap: () => context.push('/sales'),
        ),
      ],
    );
  }
}
