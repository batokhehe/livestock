import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/receiving_model.dart';
import '../../receiving_provider.dart';

class FilterChips extends ConsumerWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(receivingFilterProvider);

    return Row(
      children: [
        _chip("Hewan", ReceivingFilter.product, selected, ref),
        _chip("Pakan & Obat", ReceivingFilter.feed, selected, ref),
        _chip("Peralatan", ReceivingFilter.tools, selected, ref),
      ],
    );
  }

  Widget _chip(
    String label,
    ReceivingFilter value,
    ReceivingFilter selected,
    WidgetRef ref,
  ) {
    final isActive = value == selected;

    return GestureDetector(
      onTap: () => ref.read(receivingFilterProvider.notifier).state = value,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.orange.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label),
      ),
    );
  }
}
