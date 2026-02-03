import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/bottom_button.dart';
import '../../../../core/widgets/search_bar_card.dart';
import '../../data/model/receiving_list_model.dart';
import '../../receiving_provider.dart';
import '../widgets/receiving_date_group_card.dart';

class ReceivingPage extends ConsumerWidget {
  const ReceivingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(receivingListProvider);
    final searchCtrl = TextEditingController();
    final activeTab = ref.watch(receivingTabProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Penerimaan", style: AppTypography.largeBoldBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Column(
        children: [
          SearchBarCard(hint: 'Cari Apapun', controller: searchCtrl),

          /// 🔥 TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _tabItem(ref, ReceivingTab.animal, activeTab),
                const SizedBox(width: 8),
                _tabItem(ref, ReceivingTab.feed, activeTab),
                const SizedBox(width: 8),
                _tabItem(ref, ReceivingTab.equipment, activeTab),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(receivingListProvider);
              },
              child: dataAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Terjadi Error:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(err.toString()),
                        const SizedBox(height: 16),
                        const Text(
                          "Stacktrace:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(stack.toString()),
                      ],
                    ),
                  );
                },
                data: (list) => _ReceivingList(list),
              ),
            ),
          ),
          BottomButton(route: '/receiving/add', text: 'Terima Item'),
        ],
      ),
    );
  }

  Widget _tabItem(WidgetRef ref, ReceivingTab value, ReceivingTab active) {
    final isActive = value == active;

    return GestureDetector(
      onTap: () {
        ref.read(receivingTabProvider.notifier).state = value;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryShade : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        child: Text(
          value.label,
          style: AppTypography.smallNormalPrimary.copyWith(
            color: isActive ? AppColors.primary : AppColors.black,
          ),
        ),
      ),
    );
  }
}

class _ReceivingList extends StatelessWidget {
  final List<ReceivingList> list;

  const _ReceivingList(this.list);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text("Data kosong"));
    }

    final Map<String, List<ReceivingList>> grouped = {};

    for (final item in list) {
      grouped.putIfAbsent(item.dateLabel, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) {
        return ReceivingDateGroupCard(dateLabel: entry.key, items: entry.value);
      }).toList(),
    );
  }
}
