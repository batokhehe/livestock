import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:livestock/features/dashboard/providers/dashboard_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/features/home/presentation/providers/home_navigation_provider.dart';
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
      backgroundColor: AppColors.greyBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const _MonitoringSection(),
            ],
          ],
        ),
      ),
      ),
    );
  }
}

class _MonitoringSection extends ConsumerWidget {
  const _MonitoringSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monitoringAsync = ref.watch(dashboardMonitoringProvider);

    return monitoringAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Error: $e")),
      data: (monitoring) {
        final feed = monitoring.feedMonitoring;
        final weight = monitoring.weightMonitoring;
        final health = monitoring.healthMonitoring;
        
        final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

        return Column(
          children: [
            MonitoringView(
              title: "Feed Monitoring",
              subtitle: "Penggunaan pakan dan biaya",
              badgeText: "Data bulan ini : ${feed.totalData}",
              items: [
                MonitoringItem(
                  label: "Total data",
                  value: feed.totalData.toString(),
                  valueColor: AppColors.primary,
                ),
                MonitoringItem(
                  label: "Total biaya",
                  value: currencyFormat.format(feed.totalCost),
                ),
                if (feed.lastMonitoringDate != null)
                  MonitoringItem(
                    label: "Monitoring terakhir",
                    value: feed.lastMonitoringDate!,
                  ),
                if (feed.lastFarmLocation != null)
                  MonitoringItem(
                    label: "Lokasi terakhir",
                    value: feed.lastFarmLocation!,
                  ),
              ],
              badgeColor: AppColors.success,
            ),
            MonitoringView(
              title: "Weight Monitoring",
              subtitle: "Performa pertumbuhan ternak",
              badgeText: "Data bulan ini : ${weight.totalData}",
              items: [
                MonitoringItem(
                  label: "Total data",
                  value: weight.totalData.toString(),
                  valueColor: AppColors.primary,
                ),
                MonitoringItem(
                  label: "Ternak dimonitor",
                  value: "${weight.totalAnimal} Hewan",
                ),
                if (weight.lastMonitoringDate != null)
                  MonitoringItem(
                    label: "Monitoring terakhir",
                    value: weight.lastMonitoringDate!,
                  ),
                MonitoringItem(
                  label: "Rata-rata ADG",
                  value: "${weight.averageADG} kg/day",
                ),
              ],
              badgeColor: AppColors.primary,
            ),
            MonitoringView(
              title: "Health Monitoring",
              subtitle: "Catatan kesehatan dan perawatan",
              badgeText: "Data bulan ini : ${health.totalData}",
              items: [
                MonitoringItem(
                  label: "Total data",
                  value: health.totalData.toString(),
                  valueColor: AppColors.primary,
                ),
                MonitoringItem(
                  label: "Total biaya",
                  value: currencyFormat.format(health.totalCost),
                ),
                if (health.lastMonitoringDate != null)
                  MonitoringItem(
                    label: "Monitoring terakhir",
                    value: health.lastMonitoringDate!,
                  ),
                if (health.lastFarmLocation != null)
                  MonitoringItem(
                    label: "Lokasi terakhir",
                    value: health.lastFarmLocation!,
                  ),
              ],
              badgeColor: AppColors.success,
            ),
          ],
        );
      },
    );
  }
}

