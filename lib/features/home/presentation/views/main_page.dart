import 'package:flutter/material.dart';
import 'package:livestock/core/helpers/maintenance_helper.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/features/dashboard/presentation/views/dashboard_page.dart';
import 'package:livestock/features/notification/presentation/views/notification_page.dart';
import 'package:livestock/features/profile/presentation/views/profile_page.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/AppImages.dart';
import 'home_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_navigation_provider.dart';

class MainPage extends ConsumerStatefulWidget {
  final bool showFinishSnackBar;

  const MainPage({super.key, this.showFinishSnackBar = false});

  @override
  ConsumerState<MainPage> createState() => MainPageState();
}

class MainPageState extends ConsumerState<MainPage> {
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = const [
      HomePage(),
      DashboardPage(),
      NotificationPage(),
      ProfilePage(),
    ];
  }

  void changeTab(int index) {
    ref.read(mainNavIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(mainNavIndexProvider);
    return Scaffold(
      body: pages[currentIndex],
      backgroundColor: AppColors.baseBackground,
      bottomNavigationBar: _CustomBottomNav(
        currentIndex: currentIndex,
        onTap: changeTab,
      ),
    );
  }
}

class _NavItemModel {
  final String icon;
  final String label;
  final int pageIndex;

  const _NavItemModel({
    required this.icon,
    required this.label,
    required this.pageIndex,
  });
}

class _CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _CustomBottomNav({required this.currentIndex, required this.onTap});

  static const List<_NavItemModel> _navItems = [
    _NavItemModel(
      icon: 'assets/icons/ic_home.png',
      label: 'Home',
      pageIndex: 0,
    ),
    _NavItemModel(
      icon: 'assets/icons/ic_clipboard_text.png',
      label: 'Dashboard',
      pageIndex: 1,
    ),
    _NavItemModel(
      icon: 'assets/icons/ic_notification_bing.png',
      label: 'Notif',
      pageIndex: 2,
    ),
    _NavItemModel(
      icon: 'assets/icons/ic_user_octagon.png',
      label: 'Profile',
      pageIndex: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const enabledIndices = {0, 3};
    final List<Widget> items = List.generate(_navItems.length, (index) {
      final item = _navItems[index];
      final isEnabled = enabledIndices.contains(item.pageIndex);
      return _buildNavItem(
        context: context,
        item: item,
        isActive: currentIndex == item.pageIndex,
        isEnabled: isEnabled,
        onTap: () => onTap(item.pageIndex),
      );
    });

    items.insert(_navItems.length >> 1, _buildMiddleItem(context));

    return BottomAppBar(
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      elevation: 20,
      shadowColor: const Color(0xFF3D4147),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildMiddleItem(BuildContext context) {
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(10),
        child: Center(
          child: InkWell(
            onTap: () => context.push('/product'),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.45),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppImages.icNavCow,
                  fit: BoxFit.contain,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required _NavItemModel item,
    required bool isActive,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    final Color color;
    if (!isEnabled) {
      color = Colors.grey.shade300;
    } else if (isActive) {
      color = AppColors.primaryDark;
    } else {
      color = Colors.grey;
    }

    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: isEnabled
              ? onTap
              : () => MaintenanceHelper.showMaintenanceSnackBar(context),
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(AssetImage(item.icon), color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
