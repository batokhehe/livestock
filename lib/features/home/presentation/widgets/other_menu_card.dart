import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/home/presentation/widgets/other_menu_button_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/helpers/maintenance_helper.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../user/providers/user_provider.dart';
import 'employee_attendance_bottom_sheet.dart';

class OtherMenuItem {
  final String image;
  final String label;
  final VoidCallback? onTap;
  final bool isMaintenance;

  const OtherMenuItem({
    required this.image,
    required this.label,
    this.onTap,
    this.isMaintenance = false,
  });
}

class OtherMenu extends ConsumerWidget {
  const OtherMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => const SizedBox(),
      error: (e, _) => Text("Error: $e"),
      data: (user) {
        final menus = [
          if ((user?.hasPermission('feedmonitoring-read') ?? false) ||
              (user?.hasPermission('weightmonitoring-read') ?? false) ||
              (user?.hasPermission('healthmonitoring-read') ?? false))
            OtherMenuItem(
              image: AppImages.icClipboardSvg,
              label: 'Pemantauan',
              onTap: () => context.push('/monitoring'),
            ),

          if ((user?.hasPermission('animaltransfer-read') ?? false) ||
              (user?.hasPermission('stocktransfer-read') ?? false))
            const OtherMenuItem(
              image: AppImages.icShareSvg,
              label: 'Pemindahan',
            ),

          if (user?.hasPermission('dispatch-read') ?? false)
            OtherMenuItem(
              image: AppImages.icTruckFastSvg,
              label: 'Pengiriman',
              onTap: () => context.push('/dispatch'),
            ),

          OtherMenuItem(
            image: AppImages.icCalendarSearchSvg,
            label: 'Absensi Pekerja',
            isMaintenance: true,
            onTap: () => MaintenanceHelper.showMaintenanceSnackBar(context),
          ),
        ];
        return _buildMenu(menus);
      },
    );
  }

  Widget _buildMenu(List<OtherMenuItem> menus) {
    return Container(
      padding: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top: 16.0,
        bottom: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          const Text("Menu Lainnya", style: AppTypography.mediumNormalBlack),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 3 / 4,
            ),
            itemCount: menus.length,
            itemBuilder: (_, i) {
              final menu = menus[i];
              final child = OtherMenuButton(
                menu.image,
                menu.label,
                onTap: menu.onTap,
              );
              return menu.isMaintenance
                  ? Opacity(opacity: 0.6, child: child)
                  : child;
            },
          ),
        ],
      ),
    );
  }
}
