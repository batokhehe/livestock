import 'package:flutter/material.dart';

import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  final bool showFinishSnackBar;

  const HomePage({super.key, this.showFinishSnackBar = false});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const DashboardPage(),
      const Placeholder(),
      const Placeholder(),
      const Placeholder(),
    ];
  }

  void changeTab(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: changeTab,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/ic_home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/ic_receipt.png')),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/ic_notification.png')),
            label: 'Notif',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/ic_profile.png')),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
