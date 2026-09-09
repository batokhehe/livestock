import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import '../../transfer_provider.dart';

class TransferAnimalPaginatedBottomSheet extends ConsumerStatefulWidget {
  final List<AnimalProfile>? initialSelectedAnimals;
  final int? initialSelectedId;
  final String title;
  final String description;
  final bool showSearch;

  const TransferAnimalPaginatedBottomSheet({
    super.key,
    this.initialSelectedAnimals,
    this.initialSelectedId,
    this.title = "Pilih Hewan",
    this.description = "Silakan pilih hewan untuk pemindahan.",
    this.showSearch = true,
  });

  @override
  ConsumerState<TransferAnimalPaginatedBottomSheet> createState() =>
      _TransferAnimalPaginatedBottomSheetState();
}

class _TransferAnimalPaginatedBottomSheetState
    extends ConsumerState<TransferAnimalPaginatedBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, AnimalProfile> _selectedAnimalMap = {};
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedAnimals != null) {
      for (final a in widget.initialSelectedAnimals!) {
        _selectedAnimalMap[a.id] = a;
      }
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(transferAnimalProfilesProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _toggleSelection(AnimalProfile animal) {
    setState(() {
      if (_selectedAnimalMap.containsKey(animal.id)) {
        _selectedAnimalMap.remove(animal.id);
      } else {
        if (_selectedAnimalMap.isNotEmpty) {
          final firstAnimal = _selectedAnimalMap.values.first;
          final firstLocId = firstAnimal.farmLocation?.id;
          final firstAreaId = firstAnimal.farmArea?.id;

          if (animal.farmLocation?.id != firstLocId ||
              animal.farmArea?.id != firstAreaId) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Hewan harus berasal dari lokasi & area yang sama (${firstAnimal.farmLocation?.name ?? '-'} • ${firstAnimal.farmArea?.name ?? '-'})",
                ),
                backgroundColor: AppColors.danger,
                duration: const Duration(seconds: 2),
              ),
            );
            return;
          }
        }
        _selectedAnimalMap[animal.id] = animal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(transferAnimalProfilesProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: AppTypography.largeBoldBlack),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(widget.description, style: AppTypography.smallNormalGrey),
          const SizedBox(height: 16),

          if (widget.showSearch) ...[
            TextField(
              onChanged: (val) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  ref.read(transferAnimalSearchProvider.notifier).state = val;
                });
              },
              decoration: InputDecoration(
                hintText: "Cari hewan...",
                hintStyle: AppTypography.smallNormalGrey,
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                filled: true,
                fillColor: AppColors.greyBg,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          Expanded(
            child: asyncData.when(
              data: (res) {
                final items = res.data;
                final total = res.total ?? 0;
                final hasMore = items.length < total;

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada hewan ditemukan.",
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
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }

                    final animal = items[index];
                    final isSelected = _selectedAnimalMap.containsKey(animal.id);

                    return _buildItem(
                      animal: animal,
                      isSelected: isSelected,
                      onTap: () => _toggleSelection(animal),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAnimalMap.isNotEmpty
                        ? AppColors.primary
                        : AppColors.grey3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: _selectedAnimalMap.isNotEmpty ? 2 : 0,
                  ),
                  onPressed: _selectedAnimalMap.isNotEmpty
                      ? () {
                          Navigator.pop(
                            context,
                            _selectedAnimalMap.values.toList(),
                          );
                        }
                      : null,
                  child: Text(
                    _selectedAnimalMap.isEmpty
                        ? "Pilih Hewan"
                        : "Pilih (${_selectedAnimalMap.length}) Hewan",
                    style: AppTypography.mediumBoldWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required AnimalProfile animal,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final locationName = animal.farmLocation?.name ?? '-';
    final areaName = animal.farmArea?.name ?? '-';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryShade.withValues(alpha: 0.3)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.fieldBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        animal.name,
                        style: AppTypography.smallBoldBlack,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.baseBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "${animal.weight.floor()} kg",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    animal.animalCode,
                    style: AppTypography.xSmallNormalGrey,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.warehouse_outlined,
                        size: 12,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "$locationName • $areaName",
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
