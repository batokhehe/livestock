import 'package:flutter/material.dart';
import 'package:livestock/features/home/presentation/widgets/other_menu_button_card.dart';

import '../../../../core/helpers/maintenance_helper.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';

class OtherMenuItem {
  final String image;
  final String label;

  const OtherMenuItem({required this.image, required this.label});
}

class OtherMenu extends StatelessWidget {
  const OtherMenu({super.key});

  static const List<OtherMenuItem> _menus = [
    OtherMenuItem(image: AppImages.icClipboardSvg, label: 'Pemantauan'),
    OtherMenuItem(image: AppImages.icShareSvg, label: 'Pemindahan'),
    OtherMenuItem(image: AppImages.icTruckFastSvg, label: 'Pengiriman'),
    OtherMenuItem(
      image: AppImages.icCalendarSearchSvg,
      label: 'Absensi Pekerja',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Opacity(
        opacity: 0.4,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Menu Lainnya", style: AppTypography.mediumNormalBlack),
            const SizedBox(height: 12),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 3 / 4,
              ),
              itemCount: _menus.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final menu = _menus[index];
                return OtherMenuButton(
                  menu.image,
                  menu.label,
                  onTap: () =>
                      MaintenanceHelper.showMaintenanceSnackBar(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

