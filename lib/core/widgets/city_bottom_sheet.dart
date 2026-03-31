import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';
import 'search_bar_card.dart';

class CityBottomSheet extends ConsumerStatefulWidget {
  const CityBottomSheet({super.key});

  @override
  ConsumerState<CityBottomSheet> createState() => _CityBottomSheetState();
}

class _CityBottomSheetState extends ConsumerState<CityBottomSheet> {
  late final TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();

    Future.microtask(() {
      ref.read(citySearchProvider.notifier).state = '';
      ref.read(selectedCityProvider.notifier).state = null;
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final province = ref.watch(selectedProvinceProvider);

    if (province == null) {
      return const Center(child: Text("Pilih provinsi terlebih dahulu"));
    }

    final dataAsync = ref.watch(cityListProvider);
    final selectedItem = ref.watch(selectedCityProvider);
    final keyword = ref.watch(citySearchProvider);

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          "Gagal memuat data kota\n$error",
          textAlign: TextAlign.center,
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

              SearchBarCard(
                hint: "Cari kota",
                controller: searchCtrl,
                onChanged: (value) {
                  ref.read(citySearchProvider.notifier).state = value;
                },
                onClear: () {
                  searchCtrl.clear();
                  ref.read(citySearchProvider.notifier).state = '';
                },
              ),

              const SizedBox(height: 12),

              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          "Kota tidak ditemukan",
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
                              ref.read(selectedCityProvider.notifier).state = e;
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedItem != null
                        ? AppColors.primary
                        : AppColors.greyBg,
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
