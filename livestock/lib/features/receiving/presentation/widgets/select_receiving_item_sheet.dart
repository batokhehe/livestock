import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/receiving/presentation/widgets/poh_item_card.dart';
import 'package:livestock/features/receiving/presentation/widgets/receiving_item_double_card.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

import '../../data/receiving_item_model.dart';
import '../../data/receiving_model.dart';

class SelectReceivingItemSheet extends StatelessWidget {
  SelectReceivingItemSheet({super.key});

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
        color: AppColors.greyBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pilih Item Penerimaan",
                style: AppTypography.mediumBoldBlack,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Cari item penerimaan",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.fieldBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.fieldBorder),
              ),
            ),
            style: AppTypography.smallNormalBlack,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, i) => PohItemCard(item: dummyItem),
            ),
          ),
        ],
      ),
    );
  }
}
