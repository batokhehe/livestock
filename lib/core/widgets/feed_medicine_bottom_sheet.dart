import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/widgets/search_bar_card.dart';

import '../../app/providers.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class FeedMedicineBottomSheet extends ConsumerStatefulWidget {
  const FeedMedicineBottomSheet({super.key});

  @override
  ConsumerState<FeedMedicineBottomSheet> createState() =>
      _FeedMedicineBottomSheetState();
}

class _FeedMedicineBottomSheetState
    extends ConsumerState<FeedMedicineBottomSheet> {
  late final TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();

    // 🔥 reset search setiap buka
    ref.read(feedMedicineSearchProvider.notifier).state = '';
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(feedMedicineListProvider);
    final selectedItem = ref.watch(selectedFeedMedicineProvider);
    final keyword = ref.watch(feedMedicineSearchProvider);

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          "Gagal memuat data Pakan/Obat\n$error",
          textAlign: TextAlign.center,
          style: AppTypography.smallNormalGrey,
        ),
      ),
      data: (d) {
        final filtered = d.where((e) {
          return e.name.toLowerCase().contains(keyword.toLowerCase());
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ===== HEADER =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pakan/Obat", style: AppTypography.mediumBoldBlack),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              // ===== SEARCH =====
              SearchBarCard(
                hint: "Cari Pakan/Obat",
                controller: searchCtrl,
                onChanged: (value) {
                  ref.read(feedMedicineSearchProvider.notifier).state = value;
                },
                onClear: () {
                  searchCtrl.clear();
                  ref.read(feedMedicineSearchProvider.notifier).state = '';
                },
              ),

              const SizedBox(height: 12),

              // ===== LIST =====
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          "Pakan/Obat tidak ditemukan",
                          style: AppTypography.smallNormalGrey,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final e = filtered[i];
                          final isSelected = selectedItem?.id == e.id;

                          return GestureDetector(
                            onTap: () {
                              ref
                                      .read(
                                        selectedFeedMedicineProvider.notifier,
                                      )
                                      .state =
                                  e;
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
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.08)
                                    : Colors.white,
                              ),
                              child: Text(
                                e.name,
                                style: isSelected
                                    ? AppTypography.smallBoldPrimary
                                    : AppTypography.smallBoldBlack,
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 24),

              // ===== BUTTON =====
              SizedBox(
                width: double.infinity,
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
    );
  }
}
