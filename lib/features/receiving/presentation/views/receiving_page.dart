import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/widgets/farm_location_paginated_bottom_sheet.dart';
import 'package:livestock/features/receiving/presentation/notifier/receiving_list_notifier.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/bottom_button.dart';
import '../../../../core/widgets/search_bar_card.dart';
import '../../data/model/receiving_list_model.dart';
import '../../receiving_provider.dart';
import '../widgets/receiving_date_group_card.dart';

class ReceivingPage extends ConsumerStatefulWidget {
  const ReceivingPage({super.key});

  @override
  ConsumerState<ReceivingPage> createState() => _ReceivingPageState();
}

class _ReceivingPageState extends ConsumerState<ReceivingPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(paginatedReceivingListProvider.notifier).loadMore();
      }
    });

    _searchCtrl.text = ref.read(receivingSearchProvider);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(paginatedReceivingListProvider);
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
          SearchBarCard(
            hint: 'Cari Apapun',
            controller: _searchCtrl,
            onChanged: (val) {
              ref.read(receivingSearchProvider.notifier).state = val;
            },
            onClear: () {
              ref.read(receivingSearchProvider.notifier).state = '';
            },
          ),

          /// 🔥 LOCATION FILTER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _locationFilter(context),
          ),
          const SizedBox(height: 12),

          /// 🔥 TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _tabItem(ReceivingTab.animal, activeTab),
                const SizedBox(width: 8),
                _tabItem(ReceivingTab.feed, activeTab),
                const SizedBox(width: 8),
                _tabItem(ReceivingTab.equipment, activeTab),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(paginatedReceivingListProvider);
              },
              child: dataAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                data: (response) {
                  final list = response.data;
                  final total = response.total ?? 0;
                  final hasMore = list.length < total;

                  return _ReceivingList(
                    list: list,
                    scrollController: _scrollController,
                    hasMore: hasMore,
                  );
                },
              ),
            ),
          ),
          BottomButton(route: '/receiving/add', text: 'Terima Item'),
        ],
      ),
    );
  }

  Widget _locationFilter(BuildContext context) {
    final selectedLocation = ref.watch(receivingLocationFilterProvider);

    return InkWell(
      onTap: () async {
        final result = await showModalBottomSheet<FarmLocation?>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => FarmLocationPaginatedBottomSheet(
            initialSelectedId: selectedLocation?.id,
          ),
        );

        if (result != null) {
          ref.read(receivingLocationFilterProvider.notifier).state = result;
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selectedLocation?.name ?? "Semua lokasi peternakan",
                style: AppTypography.smallNormalBlack,
              ),
            ),
            selectedLocation != null
                ? GestureDetector(
                    onTap: () {
                      ref.read(receivingLocationFilterProvider.notifier).state =
                          null;
                    },
                    child: const Icon(Icons.close),
                  )
                : const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(ReceivingTab value, ReceivingTab active) {
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
  final ScrollController scrollController;
  final bool hasMore;

  const _ReceivingList({
    required this.list,
    required this.scrollController,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text("Data kosong"));
    }

    final Map<String, List<ReceivingList>> grouped = {};

    for (final item in list) {
      grouped.putIfAbsent(item.dateLabel, () => []).add(item);
    }

    final entries = grouped.entries.toList();

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: entries.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == entries.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final entry = entries[index];
        return ReceivingDateGroupCard(dateLabel: entry.key, items: entry.value);
      },
    );
  }
}
