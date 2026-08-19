import 'package:flutter/material.dart';
import 'package:livestock/features/monitoring/data/monitoring_model.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class ConfirmationItemDoubleCard extends StatelessWidget {
  final Monitoring item;

  const ConfirmationItemDoubleCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
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
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryShade,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "${item.count} ${item.subtitle}",
                        style: AppTypography.xSmallNormalPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monitoring ${item.subtitle}',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title.toString(),
                      style: AppTypography.smallBoldBlack,
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       item.description.toString(),
                //       style: AppTypography.xSmallNormalBlack,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
