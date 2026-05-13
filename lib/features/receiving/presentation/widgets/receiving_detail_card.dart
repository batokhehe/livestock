import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';

import '../../../../core/helpers/utils.dart';
import '../../../../core/widgets/info_tag.dart';
import '../../data/model/receiving_item_model.dart';

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
              Text(item.purchOrderNo, style: AppTypography.smallBoldBlack),
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
                  'Dikonfirmasi',
                  style: AppTypography.xSmallNormalBlack.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(item.itemName, style: AppTypography.xSmallNormalGrey),
          const SizedBox(height: 4),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              InfoTag(label: item.ageCategory.toString()),
              InfoTag(label: '${item.receivedWeight} kg'),
              InfoTag(
                label: 'Rp ${formatPrice(double.parse(item.subtotal).toInt())}',
              ),
              if (item.isVaccinated ?? false)
                InfoTag(label: item.vaccineDate.toString()),
            ],
          ),

          const SizedBox(height: 10),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.icNote,
                      width: 18,
                      color: (item.notes ?? '').isNotEmpty
                          ? AppColors.primary
                          : AppColors.hint,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        (item.notes ?? '').isNotEmpty
                            ? item.notes!
                            : "Tidak ada catatan",
                        style: (item.notes ?? '').isNotEmpty
                            ? AppTypography.xSmallNormalBlack
                            : AppTypography.xSmallNormalGrey,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              if (item.proofImage != null)
                GestureDetector(
                  onTap: () => _showPreviewDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.image,
                          size: 14,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Lihat Bukti",
                          style: AppTypography.xSmallBoldPrimary.copyWith(
                            color: AppColors.success,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // const SizedBox(height: 12),
          // Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          // const SizedBox(height: 8),

          // Text(item.itemCode, style: AppTypography.smallBoldBlack),
          // const SizedBox(height: 2),
          // Text(
          //   '${item.receivedWeight} kg',
          //   style: AppTypography.xSmallNormalGrey,
          // ),
        ],
      ),
    );
  }

  void _showPreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.file(item.proofImage!, fit: BoxFit.contain),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Tutup",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}
