import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/widgets/search_bar_card.dart';

import '../../app/providers.dart';
import '../../../../core/helpers/utils.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class AnimalBottomSheet extends ConsumerStatefulWidget {
  final String? available;
  const AnimalBottomSheet({super.key, this.available});

  @override
  ConsumerState<AnimalBottomSheet> createState() => _AnimalBottomSheetState();
}

class _AnimalBottomSheetState extends ConsumerState<AnimalBottomSheet> {
  late final TextEditingController searchCtrl;
  Timer? _debounce;
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    if (value.length < 2 && value.isNotEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _searchKeyword = value);
    });
  }

  void _clearSearch() {
    searchCtrl.clear();
    _debounce?.cancel();
    setState(() => _searchKeyword = '');
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(
      animalListProvider((available: widget.available, search: _searchKeyword)),
    );
    final selectedItem = ref.watch(selectedAnimalProvider);

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          "Gagal memuat data hewan\n$error",
          textAlign: TextAlign.center,
          style: AppTypography.smallNormalGrey,
        ),
      ),
      data: (d) {
        final filtered = d.data;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ===== HEADER =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hewan", style: AppTypography.mediumBoldBlack),
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

              // ===== SEARCH =====
              SearchBarCard(
                hint: "Cari hewan",
                controller: searchCtrl,
                resetPadding: true,
                onChanged: _onSearchChanged,
                onClear: _clearSearch,
              ),

              const SizedBox(height: 24),

              // ===== LIST =====
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          "Hewan tidak ditemukan",
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
                              ref.read(selectedAnimalProvider.notifier).state =
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                              ? AppTypography
                                                    .xSmallNormalPrimary
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      spacing: 8.0,
                                      children: [
                                        _itemStatusBadge(e.available),
                                        Text(
                                          e.lastAdgDate?.toIndonesianDate() ??
                                              '-',
                                          overflow: TextOverflow.ellipsis,
                                          style: isSelected
                                              ? AppTypography
                                                    .xSmallNormalPrimary
                                              : AppTypography.xSmallNormalBlack,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
