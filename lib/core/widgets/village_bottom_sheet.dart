import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/widgets/search_bar_card.dart';

import '../../app/providers.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class VillageBottomSheet extends ConsumerStatefulWidget {
  const VillageBottomSheet({super.key, required String param});

  @override
  ConsumerState<VillageBottomSheet> createState() => _VillageBottomSheetState();
}

class _VillageBottomSheetState extends ConsumerState<VillageBottomSheet> {
  late final TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();

    ref.read(villageSearchProvider.notifier).state = '';
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(villageListProvider);
    final selectedItem = ref.watch(selectedVillageProvider);
    final keyword = ref.watch(villageSearchProvider);

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          "Gagal memuat data kota\n$error",
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
                  Text("Kota", style: AppTypography.mediumBoldBlack),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              // ===== SEARCH =====
              SearchBarCard(
                hint: "Cari kota",
                controller: searchCtrl,
                onChanged: (value) {
                  ref.read(villageSearchProvider.notifier).state = value;
                },
                onClear: () {
                  searchCtrl.clear();
                  ref.read(villageSearchProvider.notifier).state = '';
                },
              ),

              const SizedBox(height: 12),

              // ===== LIST =====
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          "kota tidak ditemukan",
                          style: AppTypography.smallNormalGrey,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final e = filtered[i];
                          final isSelected = selectedItem?.code == e.code;

                          return GestureDetector(
                            onTap: () {
                              ref.read(selectedVillageProvider.notifier).state =
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
