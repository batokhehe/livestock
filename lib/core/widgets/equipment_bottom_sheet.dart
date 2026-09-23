import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../data/model/equipment_model.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class EquipmentBottomSheet extends ConsumerStatefulWidget {
  final int? initialSelectedId;
  final String title;
  final String description;

  const EquipmentBottomSheet({
    super.key,
    this.initialSelectedId,
    this.title = "Pilih Peralatan",
    this.description = "Silakan pilih salah satu peralatan.",
  });

  @override
  ConsumerState<EquipmentBottomSheet> createState() =>
      _EquipmentBottomSheetState();
}

class _EquipmentBottomSheetState extends ConsumerState<EquipmentBottomSheet> {
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
        ref.read(paginatedEquipmentProvider.notifier).loadMore();
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
    final asyncData = ref.watch(paginatedEquipmentProvider);

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
                ref.read(equipmentSearchProvider.notifier).state = val;
              });
            },
            decoration: InputDecoration(
              hintText: "Cari peralatan...",
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
                        children: const [
                          Icon(
                            Icons.handyman_outlined,
                            size: 48,
                            color: AppColors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Peralatan tidak ditemukan",
                            style: AppTypography.smallNormalGrey,
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
                      item: item,
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
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Gagal memuat data peralatan",
                        style: AppTypography.smallNormalGrey,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () =>
                            ref.invalidate(paginatedEquipmentProvider),
                        child: const Text("Coba Lagi"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildItem({
    required Equipment item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.fieldBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: isSelected
                        ? AppTypography.smallBoldBlack
                        : AppTypography.smallBoldBlack,
                  ),
                  if (item.code.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.code,
                      style: AppTypography.xSmallNormalGrey,
                    ),
                  ],
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
