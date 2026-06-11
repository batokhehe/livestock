import 'package:flutter/material.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import '../../data/model/transfer_list_model.dart';
import 'transfer_list_item_card.dart';

class TransferDateGroupCard extends StatelessWidget {
  final String dateLabel;
  final List<TransferList> items;

  const TransferDateGroupCard({
    super.key,
    required this.dateLabel,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDateString(dateLabel),
            style: AppTypography.smallNormalBlack,
          ),
          const SizedBox(height: 8),
          ...items.map((e) => TransferCard(item: e)),
        ],
      ),
    );
  }
}
