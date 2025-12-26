import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/receiving/presentation/widgets/receiving_item_double_card.dart';

import '../../data/receiving_model.dart';

class PohItemCard extends StatelessWidget {
  final Receiving item;

  const PohItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        context.push('/receiving/add/step-2');
      },
      child: ReceivingItemDoubleCard(item: item),
    );
  }
}
