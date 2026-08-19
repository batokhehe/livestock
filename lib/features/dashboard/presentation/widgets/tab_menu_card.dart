import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../dashboard_tab_provider.dart';
import '../../data/dashboard_tab.dart';

class TabMenuCard extends ConsumerWidget {
  const TabMenuCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(dashboardTabProvider);
    return Row(
      children: [
        _TabChip(
          label: "Penjualan",
          selected: selectedTab == DashboardTab.selling,
          onTap: () => ref.read(dashboardTabProvider.notifier).state =
              DashboardTab.selling,
        ),
        const SizedBox(width: 8),
        _TabChip(
          label: "Operasional",
          selected: selectedTab == DashboardTab.operational,
          onTap: () => ref.read(dashboardTabProvider.notifier).state =
              DashboardTab.operational,
        ),
        const SizedBox(width: 8),
        _TabChip(
          label: "Monitoring",
          selected: selectedTab == DashboardTab.monitoring,
          onTap: () => ref.read(dashboardTabProvider.notifier).state =
              DashboardTab.monitoring,
        ),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryShade : AppColors.white,
          borderRadius: BorderRadius.circular(20), // 🔵 radius di sini
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.fieldBorder, // 🔵 border color
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.mediumNormalWhite.copyWith(
            color: selected ? AppColors.primary : AppColors.black,
          ),
        ),
      ),
    );
  }
}
