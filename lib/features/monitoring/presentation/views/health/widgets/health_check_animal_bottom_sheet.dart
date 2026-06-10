import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/widgets/search_bar_card.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';

class HealthCheckAnimalBottomSheet extends ConsumerStatefulWidget {
  final int farmLocationId;
  final int farmAreaId;
  final List<int> excludedIds;

  const HealthCheckAnimalBottomSheet({
    super.key,
    required this.farmLocationId,
    required this.farmAreaId,
    this.excludedIds = const [],
  });

  @override
  ConsumerState<HealthCheckAnimalBottomSheet> createState() => _HealthCheckAnimalBottomSheetState();
}

class _HealthCheckAnimalBottomSheetState extends ConsumerState<HealthCheckAnimalBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController searchCtrl;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref
            .read(
              paginatedHealthCheckAnimalProvider((
                farmLocationId: widget.farmLocationId,
                farmAreaId: widget.farmAreaId,
              )).notifier,
            )
            .loadMore();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(healthCheckAnimalSearchProvider.notifier).state = value;
    });
  }

  void _clearSearch() {
    searchCtrl.clear();
    _debounce?.cancel();
    ref.read(healthCheckAnimalSearchProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(
      paginatedHealthCheckAnimalProvider((
        farmLocationId: widget.farmLocationId,
        farmAreaId: widget.farmAreaId,
      )),
    );
    final selectedItem = ref.watch(selectedHealthCheckAnimalProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Gagal memuat data hewan\n$error",
                textAlign: TextAlign.center,
                style: AppTypography.smallNormalGrey,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(paginatedHealthCheckAnimalProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (d) {
          final items = d.data;
          final total = d.total ?? 0;
          final hasMore = items.length < total;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ===== HEADER =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Pilih Hewan", style: AppTypography.mediumBoldBlack),
                    RawMaterialButton(
                      onPressed: () => Navigator.pop(context),
                      elevation: 1.0,
                      constraints: const BoxConstraints(minWidth: 0.0),
                      padding: const EdgeInsets.all(8.0),
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: AppColors.iconColor,
                          width: 2.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Icon(Icons.close_rounded, size: 14.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ===== SEARCH =====
                SearchBarCard(
                  hint: "Cari hewan",
                  controller: searchCtrl,
                  resetPadding: true,
                  onChanged: _onSearchChanged,
                  onClear: _clearSearch,
                ),

                const SizedBox(height: 16),

                // ===== LIST =====
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            "Hewan tidak ditemukan",
                            style: AppTypography.smallNormalGrey,
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: items.length + (hasMore ? 1 : 0),
                          itemBuilder: (_, i) {
                            if (i == items.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            final e = items[i];
                            final isExcluded = widget.excludedIds.contains(e.id);
                            final isSelected = selectedItem?.id == e.id;

                            return GestureDetector(
                              onTap: isExcluded
                                  ? null
                                  : () {
                                      ref
                                          .read(
                                            selectedHealthCheckAnimalProvider.notifier,
                                          )
                                          .state = e;
                                    },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.fieldBorder,
                                  ),
                                  color: isExcluded
                                      ? AppColors.grey.withValues(alpha: 0.1)
                                      : isSelected
                                          ? AppColors.primary.withValues(alpha: 0.08)
                                          : Colors.white,
                                ),
                                child: Opacity(
                                  opacity: isExcluded ? 0.5 : 1.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 8.0,
                                          children: [
                                            Text(
                                              e.animalCode,
                                              overflow: TextOverflow.ellipsis,
                                              style: isSelected
                                                  ? AppTypography.smallBoldPrimary
                                                  : AppTypography.smallBoldBlack,
                                            ),
                                            Text(
                                              "${e.name} • ${e.weight.floor()} kg",
                                              overflow: TextOverflow.ellipsis,
                                              style: isSelected
                                                  ? AppTypography.xSmallNormalPrimary
                                                  : AppTypography.xSmallNormalBlack,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          spacing: 8.0,
                                          children: [
                                            _itemStatusBadge(e.available),
                                            Text(
                                              e.lastAdgDate?.toIndonesianDate() ??
                                                  '-',
                                              overflow: TextOverflow.ellipsis,
                                              style: isSelected
                                                  ? AppTypography.xSmallNormalPrimary
                                                  : AppTypography.xSmallNormalBlack,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 16),

                // ===== BUTTON =====
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedItem != null
                          ? AppColors.primary
                          : AppColors.greyBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: selectedItem == null
                        ? null
                        : () => Navigator.pop(context, selectedItem),
                    child: const Text(
                      "Simpan",
                      style: AppTypography.mediumBoldWhite,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _itemStatusBadge(String status) {
    String label;
    Color color;

    switch (status) {
      case 'available':
        label = 'Tersedia';
        color = AppColors.success;
        break;
      case 'booked':
        label = 'Dipesan';
        color = Colors.orange;
        break;
      case 'sold':
        label = 'Terjual';
        color = Colors.red;
        break;
      case 'dispatched':
        label = 'Dalam Pengiriman';
        color = Colors.blue;
        break;
      default:
        label = status;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTypography.xSmallNormalGreen.copyWith(color: color),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
