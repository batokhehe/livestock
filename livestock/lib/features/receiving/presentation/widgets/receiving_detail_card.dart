import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../../data/receiving_item_model.dart';

class ReceivingDetailCard extends StatelessWidget {
  final ReceivingItem item;

  const ReceivingDetailCard({super.key, required this.item});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.code, style: AppTypography.smallBoldBlack),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  item.statusText,
                  style: AppTypography.xSmallNormalBlack.copyWith(
                    color: item.statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(item.subtitle, style: AppTypography.xSmallNormalGrey),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _tag('${item.age} Bulan'),
              _tag('${item.weight} kg'),
              _tag('Rp ${_formatPrice(item.price)}'),
              if (item.vaccine != null) _tag(item.vaccine.toString()),
            ],
          ),

          const SizedBox(height: 6),

          Text(item.note.toString(), style: AppTypography.xSmallNormalGrey),

          const SizedBox(height: 10),
          const Divider(height: 1),

          const SizedBox(height: 8),

          /// ===== FOOTER =====
          Text(
            item.code.split(' / ').first,
            style: AppTypography.smallBoldBlack,
          ),
          const SizedBox(height: 2),
          Text('${item.weight} kg', style: AppTypography.xSmallNormalGrey),
          const SizedBox(height: 2),
          const Text('-', style: AppTypography.xSmallNormalGrey),
          const SizedBox(height: 2),
          const Text('Catatan', style: AppTypography.xSmallNormalGrey),
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: AppTypography.xSmallNormalPrimary),
    );
  }

  String _formatPrice(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }
}
