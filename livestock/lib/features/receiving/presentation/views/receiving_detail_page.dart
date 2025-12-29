import 'package:flutter/material.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/features/receiving/presentation/widgets/receiving_detail_card.dart';
import 'package:livestock/features/receiving/presentation/widgets/receiving_item_double_card.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

import '../../../../core/constant/enum.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../data/receiving_model.dart';

class ReceivingDetailPage extends StatelessWidget {
  final Receiving receiving;

  const ReceivingDetailPage({super.key, required this.receiving});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Detail Penerimaan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoReceiving(),
                const SizedBox(height: 12),
                _infoItem(),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  /// TODO: update item
                },
                child: Text(
                  "Perbarui Item",
                  style: AppTypography.mediumBoldWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoReceiving() {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Penerimaan",
            style: AppTypography.mediumNormalBlack,
          ),
          const SizedBox(height: 12),

          ReceivingItemDoubleCard(
            item: Receiving(
              code: 'RECV-2511-0019',
              count: 2,
              subtitle: 'Sapi Jawara',
              total: 2,
              status: ItemStatus.received,
              title: 'Sapi Jawara',
              location: 'Area Pandeglang 1',
              description: '',
              items: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem() {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Item", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),
          ReceivingItemDoubleCard(item: dummyItem),
          ...receiving.items.map((e) => ReceivingDetailCard(item: e)),
        ],
      ),
    );
  }
}
