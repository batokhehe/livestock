import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class MonitoringTypeBottomSheet extends StatelessWidget {
  const MonitoringTypeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pilih Monitoring',
                style: AppTypography.largeBoldBlack,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.iconColor, width: 2),
                  ),
                  child: const Icon(Icons.close_rounded, size: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Pemberian Pakan
          _MonitoringTypeItem(
            title: 'Monitoring Pakan',
            onTap: () {
              Navigator.pop(context);
              context.push('/monitoring/add?type=feed');
            },
          ),

          const SizedBox(height: 12),

          /// Monitoring Bobot
          _MonitoringTypeItem(
            title: 'Monitoring Bobot',
            onTap: () {
              Navigator.pop(context);
              context.push('/monitoring/add?type=weight');
            },
          ),

          const SizedBox(height: 12),

          /// Monitoring Kesehatan
          _MonitoringTypeItem(
            title: 'Monitoring Kesehatan',
            onTap: () {
              Navigator.pop(context);
              context.push('/monitoring/add?type=medicine');
            },
          ),

          const SizedBox(height: 12),

          /// Pengobatan
          _MonitoringTypeItem(
            title: 'Pengobatan',
            onTap: () {
              Navigator.pop(context);
              context.push('/monitoring/add?type=health');
            },
          ),
        ],
      ),
    );
  }
}

class _MonitoringTypeItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MonitoringTypeItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: AppTypography.mediumBoldBlack.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
