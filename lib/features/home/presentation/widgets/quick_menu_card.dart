import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/AppImages.dart';
import 'menu_button_card.dart';

class QuickMenu extends StatelessWidget {
  const QuickMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MenuButton(
          AppImages.icDocumentForward,
          "Pembelian",
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Coming Soon 🚧'),
              duration: Duration(seconds: 2),
            ),
          ),
        ),
        const SizedBox(width: 24),
        MenuButton(
          AppImages.icClipboardImport,
          "Penerimaan",
          onTap: () => context.push('/receiving'),
        ),
        const SizedBox(width: 24),
        MenuButton(
          AppImages.icDocumentPrevious,
          "Penjualan",
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Coming Soon 🚧'),
              duration: Duration(seconds: 2),
            ),
          ),
        ),
      ],
    );
  }
}
