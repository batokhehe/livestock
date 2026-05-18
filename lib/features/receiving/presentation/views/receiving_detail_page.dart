import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/info_item_card.dart';
import 'package:livestock/features/receiving/data/model/receiving_detail_item_model.dart';
import 'package:livestock/features/receiving/data/model/receiving_item_model.dart';

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
        backgroundColor: AppColors.white,
        title: const Text(
          "Detail Penerimaan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
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
          const Text(
            "Informasi Penerimaan",
            style: AppTypography.mediumNormalBlack,
          ),
          const SizedBox(height: 12),
          InfoItemCard(
            label: 'Tanggal Penerimaan:',
            icon: AppImages.icCalendarNew,
            title: data.receiveDate,
            subtitle: data.farmName,
          ),
          if (data.farmAreaName != null)
            InfoItemCard(
              label: 'Area Peternakan:',
              icon: AppImages.icMapSvg,
              title: data.farmAreaName!,
              subtitle: 'Area Peternakan',
            ),
          if (data.remarks != null && data.remarks!.isNotEmpty)
            InfoItemCard(
              label: 'Catatan:',
              icon: AppImages.icNote,
              title: data.remarks!,
              subtitle: 'Catatan Penerimaan',
            ),
          if (data.receiveType != null && data.receiveType != 'animal')
            Builder(
              builder: (context) {
                String typeLabel = data.receiveType!;
                String typeIcon = AppImages.icNote;

                if (data.receiveType == 'equipment') {
                  typeLabel = 'Peralatan';
                  typeIcon = AppImages.icClipboardSvg;
                } else if (data.receiveType == 'supply' ||
                    data.receiveType == 'supplies') {
                  typeLabel = 'Perlengkapan';
                  typeIcon = AppImages.icClipboardSvg;
                } else if (data.receiveType == 'food' ||
                    data.receiveType == 'feed') {
                  typeLabel = 'Pakan';
                  typeIcon = AppImages.icClipboardSvg;
                } else if (data.receiveType == 'medicine') {
                  typeLabel = 'Obat';
                  typeIcon = AppImages.icClipboardSvg;
                }

                return InfoItemCard(
                  label: 'Tipe Penerimaan:',
                  icon: typeIcon,
                  title: typeLabel,
                  subtitle: 'Tipe Penerimaan',
                );
              },
            ),
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
          if (items == null || items.isEmpty)
            const Text("Tidak ada item", style: AppTypography.smallNormalGrey),
          if (items != null)
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
                  poel: e.poel ?? '',
                  ageCategory: e.ageCategory,
                  isVaccinated: e.isVaccinated,
                  vaccineDate: e.vaccineDate,
                  gender: e.gender,
                  qty: e.quantity,
                  unitPrice: '',
                  amountRemainder: 0,
                  subtotal: '0',
                  codeRef: e.codeRef ?? '',
                  selected: false,
                  receivedWeight: double.tryParse(e.weight),
                  uom: e.uom,
                  notes: e.notes, // Tambahkan jika ada di ReceivingDetailItem
                  proofImage:
                      e.proofImage, // Tambahkan jika ada di ReceivingDetailItem
                ),
              ),
            ),
        ],
      ),
    );
  }
}
