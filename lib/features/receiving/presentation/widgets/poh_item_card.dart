import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/receiving/data/model/receiving_po_model.dart';
import 'package:livestock/features/receiving/presentation/widgets/receiving_item_double_card.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

class PohItemCard extends StatelessWidget {
  final ReceivingPo item;
  final ReceivingTab tab;

  const PohItemCard({super.key, required this.item, required this.tab});

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = item.items.isEmpty;

    return Opacity(
      opacity: isEmpty ? 0.5 : 1.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isEmpty
            ? null
            : () {
                context.push('/receiving/add/step-2', extra: item);
              },
        child: ReceivingItemDoubleCard(item: item, tab: tab),
      ),
    );
  }
}
