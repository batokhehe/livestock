import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/bottom_button.dart';
import '../../../../core/widgets/search_bar_card.dart';
import '../../data/model/dispatch_list_model.dart';
import '../../dispatch_provider.dart';
import '../widgets/dispatch_date_group_card.dart';

class DispatchPage extends ConsumerStatefulWidget {
  const DispatchPage({super.key});

  @override
  ConsumerState<DispatchPage> createState() => _DispatchPageState();
}

class _DispatchPageState extends ConsumerState<DispatchPage> {
  late TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(dispatchListProvider);
    final activeTab = ref.watch(dispatchTabProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Pengiriman", style: AppTypography.largeBoldBlack),
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
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: SearchBarCard(
              hint: 'Cari Apapun',
              controller: searchCtrl,
              onChanged: (value) {
                ref
                    .read(dispatchSearchProvider.notifier)
                    .onSearchChanged(value);
              },
              onClear: () {
                ref.read(dispatchSearchProvider.notifier).onSearchChanged('');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _tabItem(ref, DispatchTab.all, activeTab),
                  const SizedBox(width: 8),
                  _tabItem(ref, DispatchTab.ready, activeTab),
                  const SizedBox(width: 8),
                  _tabItem(ref, DispatchTab.inTransit, activeTab),
                  const SizedBox(width: 8),
                  _tabItem(ref, DispatchTab.delivered, activeTab),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.refresh(dispatchListProvider.future);
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
                data: (list) => _DispatchList(list),
              ),
            ),
          ),
          BottomButton(
            text: 'Tambah Pengiriman',
            onPressed: () {
              ref.invalidate(dispatchFormProvider);
              context.push('/dispatch/add');
            },
          ),
        ],
      ),
    );
  }

  Widget _tabItem(WidgetRef ref, DispatchTab value, DispatchTab active) {
    final isActive = value == active;

    return GestureDetector(
      onTap: () {
        ref.read(dispatchTabProvider.notifier).state = value;
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

class _DispatchList extends StatelessWidget {
  final List<DispatchList> list;

  const _DispatchList(this.list);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text("Data kosong"));
    }

    final Map<String, List<DispatchList>> grouped = {};

    for (final item in list) {
      grouped.putIfAbsent(item.dispatchDate, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) {
        return DispatchDateGroupCard(dateLabel: entry.key, items: entry.value);
      }).toList(),
    );
  }
}
