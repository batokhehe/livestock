import 'package:flutter/material.dart';

import '../../../../core/theme/AppImages.dart';
import 'menu_button_card.dart';

class OtherMenu extends StatelessWidget {
  const OtherMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: const [
        MenuButton(AppImages.icClipboard, "Pemantauan"),
        MenuButton(AppImages.icShare, "Pemindahan"),
        MenuButton(AppImages.icTruckFast, "Pengiriman"),
        MenuButton(AppImages.icCalendarSearch, "Absensi"),
      ],
    );
  }
}
