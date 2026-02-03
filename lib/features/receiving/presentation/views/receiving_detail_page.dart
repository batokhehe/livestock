import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/features/receiving/data/model/receiving_detail_item_model.dart';
import 'package:livestock/features/receiving/data/model/receiving_item_model.dart';

import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../data/model/receiving_detail_model.dart';
import '../../receiving_provider.dart';
import '../widgets/receiving_detail_card.dart';

class ReceivingDetailPage extends ConsumerWidget {
  final int receivingId;

  const ReceivingDetailPage({super.key, required this.receivingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(receivingDetailProvider(receivingId));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        title: const Text("Detail Penerimaan"),
        leading: BackButton(),
      ),
      body: asyncDetail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoReceiving(data),
                const SizedBox(height: 12),
                _infoItems(data.details),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoReceiving(ReceivingDetail data) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Informasi Penerimaan", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 8),
          Text(data.stockCode),
          Text(data.receiveDate),
          Text(data.farmName),
        ],
      ),
    );
  }

  Widget _infoItems(List<ReceivingDetailItem>? items) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Item", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),
          if (items!.isEmpty) const Text("Tidak ada item"),
          ...items.map(
            (e) => ReceivingDetailCard(
              item: ReceivingItem(
                id: e.id,
                supplierId: 0,
                supplierName: e.supplierName,
                purchOrderId: 0,
                purchOrderDetailId: 0,
                purchOrderNo: e.purchOrderNo,
                item: '',
                itemName: e.itemName,
                itemCode: e.itemCode,
                poel: '',
                unitPrice: '',
                amountRemainder: 0,
                subtotal: '',
                codeRef: '',
                selected: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
