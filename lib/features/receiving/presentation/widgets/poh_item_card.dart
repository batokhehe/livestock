import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/receiving/data/model/receiving_po_model.dart';
import 'package:livestock/features/receiving/presentation/widgets/receiving_item_double_card.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PohItemCard extends ConsumerWidget {
  final ReceivingPo item;
  final ReceivingTab tab;
  final bool isClickable;

  const PohItemCard({
    super.key,
    required this.item,
    required this.tab,
    this.isClickable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isEmpty = item.items.isEmpty;

    return Opacity(
      opacity: isEmpty ? 0.5 : 1.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: (isEmpty || !isClickable)
            ? null
            : () {
                ref.read(receivingFormProvider).reset();
                context.push('/receiving/add/step-2', extra: item);
              },
        child: ReceivingItemDoubleCard(item: item, tab: tab),
      ),
    );
  }
}
