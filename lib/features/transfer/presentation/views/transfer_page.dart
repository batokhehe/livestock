import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/app/providers.dart';
import 'package:livestock/core/constant/enum.dart';
import 'package:livestock/core/data/model/filter_chip_item_model.dart';
import 'package:livestock/core/widgets/filter_chips.dart';
import 'package:livestock/core/widgets/search_bar_card.dart';
import 'package:livestock/core/widgets/bottom_button.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import '../../transfer_provider.dart';
import '../../data/model/transfer_list_model.dart';
import '../widgets/transfer_date_group_card.dart';
import '../widgets/transfer_type_bottom_sheet.dart';

class TransferPage extends ConsumerStatefulWidget {
  const TransferPage({super.key});

  @override
  ConsumerState<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends ConsumerState<TransferPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(paginatedTransferListProvider.notifier).loadMore();
      }
    });

    _searchCtrl.text = ref.read(transferSearchProvider);

    Future.microtask(() {
      if (mounted) {
        ref.read(itemFilterProvider.notifier).state = ItemFilter.health;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ItemFilter>(itemFilterProvider, (prev, next) {
      if (prev == next) return;
      _searchCtrl.clear();
      ref.read(transferSearchProvider.notifier).state = '';
    });

    final dataAsync = ref.watch(paginatedTransferListProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Pemindahan", style: AppTypography.largeBoldBlack),
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
            hint: 'Cari Pemindahan',
            controller: _searchCtrl,
            onChanged: (val) {
              ref.read(transferSearchProvider.notifier).state = val;
            },
            onClear: () {
              ref.read(transferSearchProvider.notifier).state = '';
            },
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: _locationFilters(context),
          // ),
          // const SizedBox(height: 12),
          FilterChips(
            items: [
              FilterChipItem('Hewan', ItemFilter.health),
              FilterChipItem('Stock', ItemFilter.feed),
            ],
          ),
          const SizedBox(height: 12),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(paginatedTransferListProvider);
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
                  final total = response.total ?? response.totalRows ?? 0;
                  final hasMore = list.length < total;

                  return _TransferList(
                    list: list,
                    scrollController: _scrollController,
                    hasMore: hasMore,
                  );
                },
              ),
            ),
          ),
          BottomButton(
            text: 'Tambah Pemindahan',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: false,
                builder: (_) => const TransferTypeBottomSheet(),
              );
            },
          ),
        ],
      ),
    );
  }

  /*
  Widget _locationFilters(BuildContext context) {
    final fromLocation = ref.watch(transferFromLocationFilterProvider);
    final toLocation = ref.watch(transferToLocationFilterProvider);

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final result = await showModalBottomSheet<FarmLocation?>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => FarmLocationPaginatedBottomSheet(
                  initialSelectedId: fromLocation?.id,
                ),
              );

              if (result != null) {
                ref.read(transferFromLocationFilterProvider.notifier).state = result;
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      fromLocation?.name ?? "Dari Lokasi",
                      style: AppTypography.xSmallNormalBlack,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  fromLocation != null
                      ? GestureDetector(
                          onTap: () {
                            ref.read(transferFromLocationFilterProvider.notifier).state = null;
                          },
                          child: const Icon(Icons.close, size: 14),
                        )
                      : const Icon(Icons.chevron_right, size: 14),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () async {
              final result = await showModalBottomSheet<FarmLocation?>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => FarmLocationPaginatedBottomSheet(
                  initialSelectedId: toLocation?.id,
                ),
              );

              if (result != null) {
                ref.read(transferToLocationFilterProvider.notifier).state = result;
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      toLocation?.name ?? "Ke Lokasi",
                      style: AppTypography.xSmallNormalBlack,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  toLocation != null
                      ? GestureDetector(
                          onTap: () {
                            ref.read(transferToLocationFilterProvider.notifier).state = null;
                          },
                          child: const Icon(Icons.close, size: 14),
                        )
                      : const Icon(Icons.chevron_right, size: 14),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  */
}

class _TransferList extends StatelessWidget {
  final List<TransferList> list;
  final ScrollController scrollController;
  final bool hasMore;

  const _TransferList({
    required this.list,
    required this.scrollController,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8.0,
            children: [
              Image.asset(
                AppImages.icEmptyDefault,
                width: 250,
                height: 250,
                fit: BoxFit.fitWidth,
              ),
              Text(
                "Belum Ada Data yang Tersedia",
                style: AppTypography.mediumBoldBlack,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Tambahkan data baru atau sesuaikan filter untuk\nmelihat informasi di kategori ini",
                  textAlign: TextAlign.center,
                  style: AppTypography.smallNormalWhite.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final Map<String, List<TransferList>> grouped = {};

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
        return TransferDateGroupCard(
          dateLabel: entry.key,
          items: entry.value,
        );
      },
    );
  }
}
