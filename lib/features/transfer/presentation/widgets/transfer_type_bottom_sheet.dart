import 'package:flutter/material.dart';
import 'package:livestock/core/helpers/maintenance_helper.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';

class TransferTypeBottomSheet extends StatelessWidget {
  const TransferTypeBottomSheet({super.key});

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
                'Pilih Pemindahan',
                style: AppTypography.largeBoldBlack,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.iconColor,
                      width: 2,
                    ),
                  ),
                  child: const Icon(Icons.close_rounded, size: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Pemindahan Hewan
          _TransferTypeItem(
            title: 'Pemindahan Hewan',
            onTap: () {
              Navigator.pop(context);
              MaintenanceHelper.showMaintenanceSnackBar(context);
            },
          ),

          const SizedBox(height: 12),

          /// Pemindahan Stock
          _TransferTypeItem(
            title: 'Pemindahan Stock',
            onTap: () {
              Navigator.pop(context);
              MaintenanceHelper.showMaintenanceSnackBar(context);
            },
          ),
        ],
      ),
    );
  }
}

class _TransferTypeItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _TransferTypeItem({required this.title, required this.onTap});

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
