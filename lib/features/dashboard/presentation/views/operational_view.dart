import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/dashboard/providers/dashboard_provider.dart';
import 'package:livestock/features/dashboard/presentation/widgets/operational_item_card.dart';
import 'package:livestock/features/dashboard/presentation/widgets/operational_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../widgets/operational_summary_card.dart';

class OperationalView extends ConsumerWidget {
  const OperationalView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opsAsync = ref.watch(dashboardOperationalProvider);

    return opsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Error: $e")),
      data: (ops) {
        return Column(
          children: [
        OperationalCard(
          title: "Total Pengiriman",
          subtitle: "Ternak dikirim ke pelanggan",
          value: ops.totalDispatch.toString(),
          children: [
            OperationalItemCard("Siap dikirim", ops.totalDispatchReady.toString()),
            OperationalItemCard("Dalam pengiriman", ops.totalDispatchInTransit.toString()),
            OperationalItemCard("Terkirim", ops.totalDispatchDelivered.toString()),
          ],
        ),
        const SizedBox(height: 12),
        OperationalSummaryCard(
          title: "Total Penerimaan Hewan",
          value: ops.totalAnimalReceived.toString(),
          subtitle: 'Ternak yang diterima periode ini.',
          badgeColor: AppColors.primary,
        ),
        OperationalSummaryCard(
          title: "Total Penerimaan Obat & Pakan",
          value: ops.totalFeedMedicineReceived.toString(),
          subtitle: 'Ternak yang diterima periode ini.',
          badgeColor: AppColors.info,
        ),
        OperationalSummaryCard(
          title: "Total Penerimaan Peralatan",
          value: ops.totalEquipmentSuppliesReceived.toString(),
          subtitle: 'Ternak yang diterima periode ini.',
          badgeColor: AppColors.primary,
        ),
      ],
    );
      },
    );
  }
}
