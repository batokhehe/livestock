import 'package:flutter/material.dart';
import '../../../../../../core/theme/AppColors.dart';
import '../../../../../../core/theme/AppTypography.dart';
import '../../../../data/monitoring_item_model.dart';

class MonitoringHealthItemCard extends StatelessWidget {
  final MonitoringItem item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const MonitoringHealthItemCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name.toString(),
                      style: AppTypography.smallBoldBlack,
                    ),
                    Text(
                      "${item.code ?? 'MED00001'} • ${item.unit ?? 'Botol'}",
                      style: AppTypography.smallNormalGrey,
                    ),
                  ],
                ),
              ),
              _iconAction(
                icon: Icons.delete,
                color: AppColors.danger,
                backColor: AppColors.danger.withValues(alpha: 0.08),
                onTap: onDelete,
              ),
              const SizedBox(width: 8),
              _iconAction(
                icon: Icons.edit,
                color: AppColors.white,
                backColor: AppColors.primary,
                onTap: onEdit,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${item.quantity} Obat",
              style: AppTypography.xSmallNormalPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Catatan", style: AppTypography.xSmallNormalGrey),
              Text(
                (item.note ?? '').isEmpty ? "-" : item.note!,
                style: AppTypography.smallBoldBlack,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconAction({
    required IconData icon,
    required Color color,
    required Color backColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
