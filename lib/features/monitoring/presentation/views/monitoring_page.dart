import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/features/monitoring/presentation/widgets/monitoring_date_group_card.dart';

import '../../../../core/constant/enum.dart';
import '../../../../core/data/model/filter_chip_item_model.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/filter_chips.dart';
import '../../../../core/widgets/search_bar_card.dart';
import '../../data/monitoring_model.dart';
import '../../monitoring_provider.dart';

class MonitoringPage extends ConsumerWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(filteredMonitoringProvider);
    final searchCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Pemantauan", style: AppTypography.largeBoldBlack),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          SearchBarCard(hint: 'Cari Apapun', controller: searchCtrl),
          FilterChips(
            items: [
              FilterChipItem('Pakan', ItemFilter.feed),
              FilterChipItem('Obat', ItemFilter.medicine),
              FilterChipItem('Bobot', ItemFilter.weight),
              FilterChipItem('Kesehatan', ItemFilter.health),
            ],
          ),
          Expanded(
            child: dataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  "Gagal memuat data data\n$error",
                  textAlign: TextAlign.center,
                  style: AppTypography.smallNormalGrey,
                ),
              ),
              data: (list) => _MonitoringList(list),
            ),
          ),
          _BottomButton(),
        ],
      ),
    );
  }
}

class _MonitoringList extends StatelessWidget {
  final List<Monitoring> list;

  const _MonitoringList(this.list);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text("Data kosong"));
    }

    final Map<String, List<Monitoring>> grouped = {};

    for (final item in list) {
      final key = item.dateLabel;
      grouped.putIfAbsent(key, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) {
        return MonitoringDateGroupCard(
          dateLabel: entry.key,
          items: entry.value,
        );
      }).toList(),
    );
  }
}

class _BottomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.push('/monitoring/add');
            },
            child: const Text(
              "Tambah Pemantauan",
              style: AppTypography.mediumBoldWhite,
            ),
          ),
        ),
      ),
    );
  }
}
