import 'package:flutter/material.dart';
import 'package:livestock/features/dashboard/presentation/widgets/operational_item_card.dart';
import 'package:livestock/features/dashboard/presentation/widgets/operational_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../widgets/operational_summary_card.dart';

class OperationalView extends StatelessWidget {
  const OperationalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        OperationalCard(
          title: "Total Pengiriman",
          subtitle: "Ternak dikirim ke pelanggan",
          value: "8",
          children: [
            OperationalItemCard("Siap dikirim", "1"),
            OperationalItemCard("Dalam pengiriman", "1"),
            OperationalItemCard("Terkirim", "6"),
          ],
        ),
        SizedBox(height: 12),
        OperationalSummaryCard(
          title: "Total Penerimaan Hewan",
          value: "15",
          subtitle: 'Ternak yang diterima periode ini.',
          badgeColor: AppColors.primary,
        ),
        OperationalSummaryCard(
          title: "Total Penerimaan Obat & Pakan",
          value: "400",
          subtitle: 'Ternak yang diterima periode ini.',
          badgeColor: AppColors.info,
        ),
        OperationalSummaryCard(
          title: "Total Penerimaan Peralatan",
          value: "50",
          subtitle: 'Ternak yang diterima periode ini.',
          badgeColor: AppColors.primary,
        ),
      ],
    );
  }
}
