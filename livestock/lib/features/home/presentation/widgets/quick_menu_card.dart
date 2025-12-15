import 'package:flutter/material.dart';

import '../../../../core/theme/AppImages.dart';
import 'menu_button_card.dart';

class QuickMenu extends StatelessWidget {
  const QuickMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        MenuButton(AppImages.icDocumentForward, "Pembelian"),
        MenuButton(AppImages.icClipboardImport, "Penerimaan"),
        MenuButton(AppImages.icDocumentPrevious, "Penjualan"),
      ],
    );
  }
}
