import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import '../../transfer_provider.dart';

class TransferAnimalPaginatedBottomSheet extends ConsumerStatefulWidget {
  final int? initialSelectedId;
  final String title;
  final String description;
  final bool showSearch;

  const TransferAnimalPaginatedBottomSheet({
    super.key,
    this.initialSelectedId,
    this.title = "Pilih Hewan",
    this.description = "Silakan pilih salah satu hewan untuk pemindahan.",
    this.showSearch = true,
  });

  @override
  ConsumerState<TransferAnimalPaginatedBottomSheet> createState() =>
      _TransferAnimalPaginatedBottomSheetState();
}

class _TransferAnimalPaginatedBottomSheetState
    extends ConsumerState<TransferAnimalPaginatedBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  int? _currentSelectedId;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _currentSelectedId = widget.initialSelectedId;
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

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(transferAnimalProfilesProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(widget.title, style: AppTypography.largeBoldBlack),
          const SizedBox(height: 8),
          Text(widget.description, style: AppTypography.smallNormalGrey),
          const SizedBox(height: 20),

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
            const SizedBox(height: 20),
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
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final animal = items[index];
                    final isSelected = _currentSelectedId == animal.id;

                    return _buildItem(
                      animal: animal,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _currentSelectedId = animal.id;
                        });
                        Navigator.pop(context, animal);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildItem({
    required AnimalProfile animal,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.fieldBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal.name,
                    style: isSelected
                        ? AppTypography.smallBoldBlack
                        : AppTypography.smallNormalBlack,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    animal.animalCode,
                    style: AppTypography.xSmallNormalGrey,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
