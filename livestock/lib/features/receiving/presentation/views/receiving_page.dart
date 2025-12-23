import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/features/receiving/presentation/widgets/search_bar_card.dart';

import '../../../../core/theme/AppTypography.dart';
import '../../data/receiving_model.dart';
import '../../receiving_provider.dart';
import '../widgets/filter_chips.dart';
import '../widgets/receiving_date_group_card.dart';

class ReceivingPage extends ConsumerWidget {
  const ReceivingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(filteredReceivingProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Penerimaan", style: AppTypography.largeBoldBlack),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          SearchBarCard(),
          FilterChips(),
          Expanded(
            child: dataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text("Gagal memuat data")),
              data: (list) => _ReceivingList(list),
            ),
          ),
          _BottomButton(),
        ],
      ),
    );
  }
}

class _ReceivingList extends StatelessWidget {
  final List<Receiving> list;

  const _ReceivingList(this.list);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text("Data kosong"));
    }

    final Map<String, List<Receiving>> grouped = {};

    for (final item in list) {
      final key = item.dateLabel;
      grouped.putIfAbsent(key, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) {
        return ReceivingDateGroupCard(dateLabel: entry.key, items: entry.value);
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
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.push('/receiving/add');
            },
            child: const Text(
              "Terima Item",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
