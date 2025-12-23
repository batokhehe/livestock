import 'package:flutter/material.dart';
import 'package:livestock/features/dashboard/presentation/views/dashboard_page.dart';
import 'package:livestock/features/notification/presentation/views/notification_page.dart';
import 'package:livestock/features/product/presentation/views/product_page.dart';
import 'package:livestock/features/profile/presentation/views/profile_page.dart';

import 'home_page.dart';

class MainPage extends StatefulWidget {
  final bool showFinishSnackBar;

  const MainPage({super.key, this.showFinishSnackBar = false});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = const [
      HomePage(),
      DashboardPage(),
      ProductPage(),
      NotificationPage(),
      ProfilePage(),
    ];
  }

  void changeTab(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: _CustomBottomNav(
        currentIndex: currentIndex,
        onTap: changeTab,
      ),
    );
  }
}

class _CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _CustomBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavItem(
                  icon: 'assets/icons/ic_home.png',
                  label: 'Home',
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  icon: 'assets/icons/ic_clipboard_text.png',
                  label: 'Dashboard',
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                ),

                const SizedBox(width: 40),

                _NavItem(
                  icon: 'assets/icons/ic_notification_bing.png',
                  label: 'Notif',
                  isActive: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
                _NavItem(
                  icon: 'assets/icons/ic_user_octagon.png',
                  label: 'Profile',
                  isActive: currentIndex == 4,
                  onTap: () => onTap(4),
                ),
              ],
            ),
          ),
          Positioned(
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Center(child: Image.asset('assets/images/bottom_nav.png')),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.orange : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageIcon(AssetImage(icon), color: color, size: 22),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
