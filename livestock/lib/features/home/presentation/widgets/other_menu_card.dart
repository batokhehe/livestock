import 'package:flutter/material.dart';
import 'package:livestock/features/home/presentation/widgets/other_menu_button_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';

class OtherMenu extends StatelessWidget {
  const OtherMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Menu Lainnya", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                OtherMenuButton(AppImages.icClipboard, "Pemantauan"),
                SizedBox(width: 12),
                OtherMenuButton(AppImages.icShare, "Pemindahan"),
                SizedBox(width: 12),
                OtherMenuButton(AppImages.icTruckFast, "Pengiriman"),
                SizedBox(width: 12),
                OtherMenuButton(AppImages.icCalendarSearch, "Absensi Pekerja"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
