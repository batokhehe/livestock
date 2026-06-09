import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';

import '../../../../../../core/theme/AppColors.dart';
import '../../../../../../core/theme/AppTypography.dart';

class MonitoringHealthMedicinePaginatedBottomSheet extends ConsumerStatefulWidget {
  const MonitoringHealthMedicinePaginatedBottomSheet({super.key});

  @override
  ConsumerState<MonitoringHealthMedicinePaginatedBottomSheet> createState() =>
      _MonitoringHealthMedicinePaginatedBottomSheetState();
}

class _MonitoringHealthMedicinePaginatedBottomSheetState
    extends ConsumerState<MonitoringHealthMedicinePaginatedBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(paginatedAnimalHealthCheckMedicinesProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(paginatedAnimalHealthCheckMedicinesProvider);
    final selectedObat = ref.watch(selectedMonitoringMedicineProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Obat",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.cancel_outlined, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: asyncData.when(
              data: (res) {
                final items = res.data;
                final total = res.totalRows ?? res.total ?? 0;
                final hasMore = items.length < total;

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Obat tidak ditemukan",
                      style: AppTypography.smallNormalGrey,
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: items.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = items[index];
                    final isSelected = item.code == selectedObat?.code;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        ref
                                .read(
                                  selectedMonitoringMedicineProvider.notifier,
                                )
                                .state =
                            item;
                        await Future.delayed(const Duration(milliseconds: 250));
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.fieldBorder,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: AppTypography.smallBoldBlack,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${item.code} • ${item.uom.isNotEmpty ? item.uom : 'Botol'}",
                                    style: AppTypography.xSmallNormalBlack,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
        ],
      ),
    );
  }
}
