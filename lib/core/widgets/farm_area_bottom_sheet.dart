import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/widgets/search_bar_card.dart';

import '../../app/providers.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class FarmAreaBottomSheet extends ConsumerStatefulWidget {
  const FarmAreaBottomSheet({super.key});

  @override
  ConsumerState<FarmAreaBottomSheet> createState() =>
      _FarmAreaBottomSheetState();
}

class _FarmAreaBottomSheetState extends ConsumerState<FarmAreaBottomSheet> {
  late final TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();

    // 🔥 reset search setiap buka
    ref.read(farmAreaSearchProvider.notifier).state = '';
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(farmAreaListProvider);
    final selectedItem = ref.watch(selectedFarmAreaProvider);
    final keyword = ref.watch(farmAreaSearchProvider);

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          "Gagal memuat data lokasi\n$error",
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
                  Text(
                    "Lokasi Peternakan",
                    style: AppTypography.mediumBoldBlack,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              // ===== SEARCH =====
              SearchBarCard(
                hint: "Cari lokasi",
                controller: searchCtrl,
                onChanged: (value) {
                  ref.read(farmAreaSearchProvider.notifier).state = value;
                },
                onClear: () {
                  searchCtrl.clear();
                  ref.read(farmAreaSearchProvider.notifier).state = '';
                },
              ),

              const SizedBox(height: 12),

              // ===== LIST =====
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          "Lokasi tidak ditemukan",
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
                                      .read(selectedFarmAreaProvider.notifier)
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
                      : () => Navigator.pop(context),
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
