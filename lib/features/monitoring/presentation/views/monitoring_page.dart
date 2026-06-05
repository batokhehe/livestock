import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/app/providers.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/features/monitoring/data/weight_monitoring_model.dart';
import 'package:livestock/features/monitoring/data/feed_monitoring_model.dart';
import 'package:livestock/features/monitoring/data/health_monitoring_model.dart';
import 'package:livestock/features/monitoring/presentation/notifier/weight_monitoring_list_notifier.dart';
import 'package:livestock/features/monitoring/presentation/notifier/feed_monitoring_list_notifier.dart';
import 'package:livestock/features/monitoring/presentation/notifier/health_monitoring_list_notifier.dart';
import 'package:livestock/features/monitoring/presentation/widgets/weight_monitoring_card.dart';
import 'package:livestock/features/monitoring/presentation/widgets/feed_monitoring_card.dart';
import 'package:livestock/features/monitoring/presentation/widgets/health_monitoring_card.dart';
import '../widgets/monitoring_type_bottom_sheet.dart';

import '../../../../core/constant/enum.dart';
import '../../../../core/data/model/filter_chip_item_model.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/filter_chips.dart';
import '../../../../core/widgets/search_bar_card.dart';
import '../../monitoring_provider.dart';

class MonitoringPage extends ConsumerStatefulWidget {
  const MonitoringPage({super.key});

  @override
  ConsumerState<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends ConsumerState<MonitoringPage> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    Future.microtask(() {
      if (mounted) {
        ref.read(itemFilterProvider.notifier).state = ItemFilter.feed;
      }
    });
  }

  void _onScroll() {
    final filter = ref.read(itemFilterProvider);
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      if (filter == ItemFilter.weight) {
        ref.read(weightMonitoringListProvider.notifier).loadMore();
      } else if (filter == ItemFilter.feed) {
        ref.read(feedMonitoringListProvider.notifier).loadMore();
      } else if (filter == ItemFilter.medicine) {
        ref.read(healthMonitoringListProvider.notifier).loadMore();
      }
    }
  }

  void _onSearchChanged(String val) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final filter = ref.read(itemFilterProvider);
      if (filter == ItemFilter.weight) {
        ref.read(weightMonitoringSearchProvider.notifier).state = val;
      } else if (filter == ItemFilter.feed) {
        ref.read(feedMonitoringSearchProvider.notifier).state = val;
      } else if (filter == ItemFilter.medicine) {
        ref.read(healthMonitoringSearchProvider.notifier).state = val;
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ItemFilter>(itemFilterProvider, (prev, next) {
      if (prev == next) return;
      String newSearch = '';
      if (next == ItemFilter.weight) {
        newSearch = ref.read(weightMonitoringSearchProvider);
      } else if (next == ItemFilter.feed) {
        newSearch = ref.read(feedMonitoringSearchProvider);
      } else if (next == ItemFilter.medicine) {
        newSearch = ref.read(healthMonitoringSearchProvider);
      }
      _searchCtrl.text = newSearch;
    });

    final filter = ref.watch(itemFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Pemantauan", style: AppTypography.largeBoldBlack),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          SearchBarCard(
            hint: 'Cari Apapun',
            controller: _searchCtrl,
            onChanged: _onSearchChanged,
          ),
          FilterChips(
            items: [
              FilterChipItem('Pakan', ItemFilter.feed),
              FilterChipItem('Obat', ItemFilter.medicine),
              FilterChipItem('Bobot', ItemFilter.weight),
              FilterChipItem('Kesehatan', ItemFilter.health),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: _buildList(filter),
          ),
          _BottomButton(),
        ],
      ),
    );
  }

  Widget _buildList(ItemFilter filter) {
    switch (filter) {
      case ItemFilter.weight:
        return _WeightMonitoringList(scrollCtrl: _scrollCtrl);
      case ItemFilter.feed:
        return _FeedMonitoringList(scrollCtrl: _scrollCtrl);
      case ItemFilter.medicine:
        return _HealthMonitoringList(scrollCtrl: _scrollCtrl);
      default:
        return const Center(
          child: Text('Fitur belum tersedia', style: AppTypography.smallNormalGrey),
        );
    }
  }
}

class _WeightMonitoringList extends ConsumerWidget {
  final ScrollController scrollCtrl;

  const _WeightMonitoringList({required this.scrollCtrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(weightMonitoringListProvider);

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Gagal memuat data\n$e',
              textAlign: TextAlign.center,
              style: AppTypography.smallNormalGrey,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref.invalidate(weightMonitoringListProvider),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
      data: (response) {
        final list = response.data;

        if (list.isEmpty) {
          return const Center(
            child: Text('Tidak ada data', style: AppTypography.smallNormalGrey),
          );
        }

        // Group by date
        final Map<String, List<WeightMonitoring>> grouped = {};
        for (final item in list) {
          grouped.putIfAbsent(item.dateLabel, () => []).add(item);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(weightMonitoringListProvider);
            await ref.read(weightMonitoringListProvider.future);
          },
          child: ListView(
            controller: scrollCtrl,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              ...grouped.entries.map((entry) {
                return _DateGroup(dateLabel: entry.key, items: entry.value);
              }),
              // Load more indicator
              if ((response.total ?? 0) > list.length)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DateGroup extends StatelessWidget {
  final String dateLabel;
  final List<WeightMonitoring> items;

  const _DateGroup({required this.dateLabel, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dateLabel, style: AppTypography.smallNormalGrey),
          const SizedBox(height: 8),
          ...items.map(
            (e) => WeightMonitoringCard(
              item: e,
              onTap: () => context.push('/monitoring/detail/weight', extra: e),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedMonitoringList extends ConsumerWidget {
  final ScrollController scrollCtrl;

  const _FeedMonitoringList({required this.scrollCtrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(feedMonitoringListProvider);

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Gagal memuat data\n$e',
              textAlign: TextAlign.center,
              style: AppTypography.smallNormalGrey,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref.invalidate(feedMonitoringListProvider),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
      data: (response) {
        final list = response.data;

        if (list.isEmpty) {
          return const Center(
            child: Text('Tidak ada data', style: AppTypography.smallNormalGrey),
          );
        }

        // Group by date
        final Map<String, List<FeedMonitoring>> grouped = {};
        for (final item in list) {
          grouped.putIfAbsent(item.dateLabel, () => []).add(item);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(feedMonitoringListProvider);
            await ref.read(feedMonitoringListProvider.future);
          },
          child: ListView(
            controller: scrollCtrl,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              ...grouped.entries.map((entry) {
                return _FeedDateGroup(dateLabel: entry.key, items: entry.value);
              }),
              if ((response.total ?? 0) > list.length)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _FeedDateGroup extends StatelessWidget {
  final String dateLabel;
  final List<FeedMonitoring> items;

  const _FeedDateGroup({required this.dateLabel, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dateLabel, style: AppTypography.smallNormalGrey),
          const SizedBox(height: 8),
          ...items.map(
            (e) => FeedMonitoringCard(
              item: e,
              onTap: () => context.push('/monitoring/detail/feed/${e.id}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthMonitoringList extends ConsumerWidget {
  final ScrollController scrollCtrl;

  const _HealthMonitoringList({required this.scrollCtrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(healthMonitoringListProvider);

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Gagal memuat data\n$e',
              textAlign: TextAlign.center,
              style: AppTypography.smallNormalGrey,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref.invalidate(healthMonitoringListProvider),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
      data: (response) {
        final list = response.data;

        if (list.isEmpty) {
          return const Center(
            child: Text('Tidak ada data', style: AppTypography.smallNormalGrey),
          );
        }

        // Group by date
        final Map<String, List<HealthMonitoring>> grouped = {};
        for (final item in list) {
          grouped.putIfAbsent(item.dateLabel, () => []).add(item);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(healthMonitoringListProvider);
            await ref.read(healthMonitoringListProvider.future);
          },
          child: ListView(
            controller: scrollCtrl,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              ...grouped.entries.map((entry) {
                return _HealthDateGroup(dateLabel: entry.key, items: entry.value);
              }),
              if ((response.total ?? 0) > list.length)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HealthDateGroup extends StatelessWidget {
  final String dateLabel;
  final List<HealthMonitoring> items;

  const _HealthDateGroup({required this.dateLabel, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dateLabel, style: AppTypography.smallNormalGrey),
          const SizedBox(height: 8),
          ...items.map(
            (e) => HealthMonitoringCard(
              item: e,
              onTap: () => context.push('/monitoring/detail/medicine/${e.id}'),
            ),
          ),
        ],
      ),
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
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: false,
                builder: (_) => const MonitoringTypeBottomSheet(),
              );
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
