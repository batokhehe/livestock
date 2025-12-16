import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/dashboard_tab.dart';

final dashboardTabProvider = StateProvider<DashboardTab>(
  (ref) => DashboardTab.selling,
);
