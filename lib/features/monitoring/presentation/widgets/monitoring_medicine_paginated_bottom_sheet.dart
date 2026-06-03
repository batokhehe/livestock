import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/widgets/status_chips.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';
import 'package:livestock/core/helpers/utils.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class MonitoringMedicinePaginatedBottomSheet extends ConsumerStatefulWidget {
  const MonitoringMedicinePaginatedBottomSheet({super.key});

  @override
  ConsumerState<MonitoringMedicinePaginatedBottomSheet> createState() =>
      _MonitoringMedicinePaginatedBottomSheetState();
}

class _MonitoringMedicinePaginatedBottomSheetState
    extends ConsumerState<MonitoringMedicinePaginatedBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(paginatedMonitoringMedicineStockProvider.notifier).loadMore();
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
    final asyncData = ref.watch(paginatedMonitoringMedicineStockProvider);
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                StatusChips(
                                  text: "${item.quantity} Kuantitas",
                                  color: AppColors.success,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rp ${formatPrice(item.price)}",
                                  style: AppTypography.smallBoldBlack,
                                ),
                              ],
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
