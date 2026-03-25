import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/widgets/search_bar_card.dart';

import '../../app/providers.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class CustomerBottomSheet extends ConsumerStatefulWidget {
  const CustomerBottomSheet({super.key});

  @override
  ConsumerState<CustomerBottomSheet> createState() =>
      _CustomerBottomSheetState();
}

class _CustomerBottomSheetState extends ConsumerState<CustomerBottomSheet> {
  late final TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();

    // 🔥 reset search setiap buka
    ref.read(customerSearchProvider.notifier).state = '';
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(customerListProvider);
    final selectedItem = ref.watch(selectedCustomerProvider);
    final keyword = ref.watch(customerSearchProvider);

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ===== HEADER =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pilih Pelanggan", style: AppTypography.mediumBoldBlack),
                  RawMaterialButton(
                    onPressed: () => Navigator.pop(context),
                    elevation: 1.0,
                    constraints: BoxConstraints(minWidth: 0.0),
                    padding: EdgeInsets.all(8.0),
                    shape: CircleBorder(
                      side: const BorderSide(
                        color: AppColors.iconColor,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Icon(Icons.close_rounded, size: 14.0),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              // ===== SEARCH =====
              SearchBarCard(
                hint: "Cari pelanggan",
                controller: searchCtrl,
                resetPadding: true,
                onChanged: (value) {
                  ref.read(customerSearchProvider.notifier).state = value;
                },
                onClear: () {
                  searchCtrl.clear();
                  ref.read(customerSearchProvider.notifier).state = '';
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
                                      .read(selectedCustomerProvider.notifier)
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
