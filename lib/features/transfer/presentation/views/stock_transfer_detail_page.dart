import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/info_item_card.dart';
import '../../transfer_provider.dart';

class StockTransferDetailPage extends ConsumerWidget {
  final int transferId;

  const StockTransferDetailPage({super.key, required this.transferId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(stockTransferDetailProvider(transferId));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Detail Pemindahan Stock",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (detail) {
          final transferDate = DateTime.tryParse(detail.transferDate) ?? DateTime.now();
          final double qtyDouble = double.tryParse(detail.qty) ?? 0;
          final String qtyStr = qtyDouble % 1 == 0
              ? qtyDouble.toInt().toString()
              : qtyDouble.toString();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SectionCard(
                title: "Informasi Pemindahan",
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.fieldBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formatDateTime(transferDate),
                                style: AppTypography.smallBoldBlack.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                detail.transferCode,
                                style: AppTypography.smallNormalGrey,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.fieldBorder,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ProductHeaderCard(
                            title: detail.itemCode,
                            subtitle: "${detail.itemName} • $qtyStr Unit",
                            image: AppImages.icProduct,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SectionCard(
                title: "Informasi Pengiriman",
                children: [
                  CardWrapper(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Informasi Asal",
                          style: AppTypography.smallBoldBlack,
                        ),
                        const SizedBox(height: 4),
                        InfoItemCard(
                          icon: AppImages.icHome,
                          title: detail.fromFarmLocation.name,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Informasi Tujuan",
                          style: AppTypography.smallBoldBlack,
                        ),
                        const SizedBox(height: 4),
                        InfoItemCard(
                          icon: AppImages.icHome,
                          title: detail.toFarmLocation.name,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
