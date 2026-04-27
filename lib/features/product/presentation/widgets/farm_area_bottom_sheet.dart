import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class FarmAreaBottomSheet extends ConsumerStatefulWidget {
  const FarmAreaBottomSheet({super.key});

  @override
  ConsumerState<FarmAreaBottomSheet> createState() => _FarmAreaBottomSheetState();
}

class _FarmAreaBottomSheetState extends ConsumerState<FarmAreaBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(paginatedFarmAreaProvider.notifier).loadMore();
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
    final asyncData = ref.watch(paginatedFarmAreaProvider);
    final selectedId = ref.watch(animalFarmAreaIdProvider);

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
          const Text(
            "Pilih Area Peternakan",
            style: AppTypography.largeBoldBlack,
          ),
          const SizedBox(height: 8),
          const Text(
            "Silakan pilih salah satu area peternakan untuk memfilter data hewan.",
            style: AppTypography.smallNormalGrey,
          ),
          const SizedBox(height: 20),

          Expanded(
            child: asyncData.when(
              data: (res) {
                final items = res.data;
                final total = res.total ?? 0;
                final hasMore = items.length < total;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: items.length + (hasMore ? 1 : 0) + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildItem(
                        title: "Semua Area",
                        isSelected: selectedId == null,
                        onTap: () {
                          ref.read(animalFarmAreaIdProvider.notifier).state = null;
                          Navigator.pop(context);
                        },
                      );
                    }

                    final itemIndex = index - 1;
                    if (itemIndex == items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final area = items[itemIndex];
                    return _buildItem(
                      title: area.name,
                      isSelected: selectedId == area.id,
                      onTap: () {
                        ref.read(animalFarmAreaIdProvider.notifier).state = area.id;
                        Navigator.pop(context);
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
    required String title,
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
            Text(
              title,
              style: isSelected ? AppTypography.smallBoldBlack : AppTypography.smallNormalBlack,
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
