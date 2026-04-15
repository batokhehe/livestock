import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/home/presentation/widgets/other_menu_button_card.dart';

import '../../../../core/helpers/maintenance_helper.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../user/providers/user_provider.dart';
import 'employee_attendance_bottom_sheet.dart';

class OtherMenuItem {
  final String image;
  final String label;
  final VoidCallback? onTap;

  const OtherMenuItem({required this.image, required this.label, this.onTap});
}

class OtherMenu extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => const SizedBox(),
      error: (e, _) => Text("Error: $e"),
      data: (user) {
        // final menus = [
        //   OtherMenuItem(
        //     image: AppImages.icClipboardSvg,
        //     label: 'Pemantauan',
        //     onTap: () => context.push('/monitoring'),
        //   ),
        //   const OtherMenuItem(image: AppImages.icShareSvg, label: 'Pemindahan'),
        //
        //   if (user?.hasPermission('dispatch-read') ?? false)
        //     OtherMenuItem(
        //       image: AppImages.icTruckFastSvg,
        //       label: 'Pengiriman',
        //       onTap: () => context.push('/dispatch'),
        //     ),
        //
        //   OtherMenuItem(
        //     image: AppImages.icCalendarSearchSvg,
        //     label: 'Absensi Pekerja',
        //     onTap: () {
        //       showModalBottomSheet(
        //         context: context,
        //         isScrollControlled: true,
        //         backgroundColor: Colors.transparent,
        //         builder: (_) => const EmployeeAttendanceBottomSheet(),
        //       );
        //     },
        //   ),
        // ];
        // return _buildMenu(menus);
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
                const Text(
                  "Menu Lainnya",
                  style: AppTypography.mediumNormalBlack,
                ),
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
      },
    );
  }

  Widget _buildMenu(List<OtherMenuItem> menus) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 3 / 4,
        ),
        itemCount: menus.length,
        itemBuilder: (_, i) {
          final menu = menus[i];
          return OtherMenuButton(menu.image, menu.label, onTap: menu.onTap);
        },
      ),
    );
  }
}
