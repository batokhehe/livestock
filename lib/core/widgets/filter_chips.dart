import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../constant/enum.dart';
import '../data/model/filter_chip_item_model.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class FilterChips extends ConsumerWidget {
  final List<FilterChipItem> items;

  const FilterChips({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(itemFilterProvider);

    return Row(
      children: items.map((item) {
        return _chip(
          label: item.label,
          value: item.value,
          selected: selected,
          ref: ref,
        );
      }).toList(),
    );
  }

  Widget _chip({
    required String label,
    required ItemFilter value,
    required ItemFilter selected,
    required WidgetRef ref,
  }) {
    final isActive = value == selected;

    return GestureDetector(
      onTap: () => ref.read(itemFilterProvider.notifier).state = value,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryShade : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        child: Text(
          label,
          style: isActive
              ? AppTypography.smallNormalPrimary
              : AppTypography.smallNormalBlack,
        ),
      ),
    );
  }
}
