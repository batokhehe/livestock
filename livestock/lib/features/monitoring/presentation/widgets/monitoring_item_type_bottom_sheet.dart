import 'package:flutter/material.dart';
import 'package:livestock/core/widgets/status_chips.dart';
import 'package:livestock/features/monitoring/data/monitoring_type_item_model.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class MonitoringItemTypeBottomSheet extends StatelessWidget {
  final List<MonitoringTypeItemModel> feeds;

  const MonitoringItemTypeBottomSheet({super.key, required this.feeds});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pakan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ...feeds.map(
            (item) => InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.pop(context, item),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.fieldBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: AppTypography.smallBoldBlack),
                          const SizedBox(height: 2),
                          Text(
                            "${item.code} • Karung",
                            style: AppTypography.xSmallNormalBlack,
                          ),
                        ],
                      ),
                    ),
                    StatusChips(
                      text: "${item.quantity} Kuantitas",
                      color: AppColors.success,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
