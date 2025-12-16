import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/dashboard/dashboard_tab_provider.dart';
import 'package:livestock/features/dashboard/presentation/views/monitoring_view.dart';
import 'package:livestock/features/dashboard/presentation/views/operational_view.dart';
import 'package:livestock/features/dashboard/presentation/widgets/latest_transaction_card.dart';
import 'package:livestock/features/dashboard/presentation/widgets/status_grid_card.dart';
import 'package:livestock/features/dashboard/presentation/widgets/summary_card.dart';
import 'package:livestock/features/dashboard/presentation/widgets/tab_menu_card.dart';

import '../../data/dashboard_tab.dart';
import '../../data/monitoring_item.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(dashboardTabProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(title: const Text("Dashboard"), centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(),
            const SizedBox(height: 16),
            const SummaryCard(),
            const SizedBox(height: 16),
            const TabMenuCard(),
            const SizedBox(height: 16),
            if (selectedTab == DashboardTab.selling) ...[
              const StatusGridCard(),
              const SizedBox(height: 16),
              const LatestTransactionCard(),
            ] else if (selectedTab == DashboardTab.operational) ...[
              const OperationalView(),
            ] else ...[
              Column(
                children: [
                  MonitoringView(
                    title: "Feed Monitoring",
                    subtitle: "Penggunaan pakan dan biaya",
                    badgeText: "Data bulan ini : 8",
                    items: [
                      MonitoringItem(
                        label: "Total data",
                        value: "8",
                        valueColor: Colors.orange,
                      ),
                      MonitoringItem(
                        label: "Total biaya",
                        value: "Rp 185.250.000",
                      ),
                      MonitoringItem(
                        label: "Monitoring terakhir",
                        value: "15 Nov 2025",
                      ),
                      MonitoringItem(
                        label: "Lokasi terakhir",
                        value: "Sapi Jawara Bandung",
                      ),
                    ],
                    badgeColor: AppColors.success,
                  ),

                  MonitoringView(
                    title: "Weight Monitoring",
                    subtitle: "Performa pertumbuhan ternak",
                    badgeText: "Data bulan ini : 8",
                    items: [
                      MonitoringItem(
                        label: "Total data",
                        value: "5",
                        valueColor: Colors.orange,
                      ),
                      MonitoringItem(
                        label: "Total data",
                        value: "3",
                        valueColor: Colors.orange,
                      ),
                      MonitoringItem(
                        label: "Ternak dimonitor",
                        value: "6 Hewan",
                      ),
                      MonitoringItem(
                        label: "Monitoring terakhir",
                        value: "15 Nov 2025",
                      ),
                      MonitoringItem(
                        label: "Rata-rata ADG",
                        value: "0.59 kg/day",
                      ),
                    ],
                    badgeColor: AppColors.primary,
                  ),

                  MonitoringView(
                    title: "Health Monitoring",
                    subtitle: "Catatan kesehatan dan perawatan",
                    badgeText: "Data bulan ini : 3",
                    items: [
                      MonitoringItem(
                        label: "Total data",
                        value: "3",
                        valueColor: Colors.orange,
                      ),
                      MonitoringItem(
                        label: "Total biaya",
                        value: "Rp 2.620.000",
                      ),
                      MonitoringItem(
                        label: "Monitoring terakhir",
                        value: "15 Nov 2025",
                      ),
                      MonitoringItem(
                        label: "Lokasi terakhir",
                        value: "Sapi Jawara Bandung",
                      ),
                    ],
                    badgeColor: AppColors.success,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Cari Apapun",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
