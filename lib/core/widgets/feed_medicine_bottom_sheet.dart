import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../features/product/presentation/views/add_feed_medicine_page.dart';
import '../data/model/feed_medicine_model.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';
import 'dart:async';

class FeedMedicineBottomSheet extends ConsumerStatefulWidget {
  final int? initialSelectedId;
  final String title;
  final String description;

  const FeedMedicineBottomSheet({
    super.key,
    this.initialSelectedId,
    this.title = "Pilih Pakan/Obat",
    this.description = "Silakan pilih salah satu pakan atau obat.",
  });

  @override
  ConsumerState<FeedMedicineBottomSheet> createState() =>
      _FeedMedicineBottomSheetState();
}

class _FeedMedicineBottomSheetState
    extends ConsumerState<FeedMedicineBottomSheet> {
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
        ref.read(paginatedFeedMedicineProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _navigateToAddFeedMedicine() async {
    final String? defaultType = widget.title.toLowerCase().contains('obat')
        ? 'obat'
        : (widget.title.toLowerCase().contains('pakan') ? 'pakan' : null);

    final newFeedMedicine = await Navigator.push<FeedMedicine>(
      context,
      MaterialPageRoute(
        builder: (_) => AddFeedMedicinePage(initialType: defaultType),
      ),
    );

    if (newFeedMedicine != null && mounted) {
      ref.invalidate(paginatedFeedMedicineProvider);
      ref.invalidate(feedMedicineListProvider);
      setState(() {
        _currentSelectedId = newFeedMedicine.id;
      });
      Navigator.pop(context, newFeedMedicine);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(paginatedFeedMedicineProvider);

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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(widget.title, style: AppTypography.largeBoldBlack),
              ),
              OutlinedButton.icon(
                onPressed: _navigateToAddFeedMedicine,
                icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                label: const Text(
                  "Tambah",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(widget.description, style: AppTypography.smallNormalGrey),
          const SizedBox(height: 20),

          TextField(
            onChanged: (val) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                ref.read(feedMedicineSearchProvider.notifier).state = val;
              });
            },
            decoration: InputDecoration(
              hintText: "Cari pakan atau obat...",
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

          Expanded(
            child: asyncData.when(
              data: (res) {
                final items = res.data;
                final total = res.total ?? 0;
                final hasMore = items.length < total;

                if (items.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.medication_outlined,
                            size: 48,
                            color: AppColors.grey,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Pakan/Obat tidak ditemukan",
                            style: AppTypography.smallNormalGrey,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _navigateToAddFeedMedicine,
                            icon: const Icon(Icons.add,
                                size: 16, color: Colors.white),
                            label: const Text(
                              "Tambah Pakan/Obat Baru",
                              style: AppTypography.smallBoldWhite,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    final isSelected = _currentSelectedId == item.id;

                    return _buildItem(
                      title: item.name,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _currentSelectedId = item.id;
                        });
                        Navigator.pop(context, item);
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
            Expanded(
              child: Text(
                title,
                style: isSelected
                    ? AppTypography.smallBoldBlack
                    : AppTypography.smallNormalBlack,
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
