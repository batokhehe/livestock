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

class TransferDetailPage extends ConsumerWidget {
  final int transferId;

  const TransferDetailPage({super.key, required this.transferId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(transferDetailProvider(transferId));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Detail Pemindahan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
                const SizedBox(height: 12),
                Text(
                  "Gagal memuat detail pemindahan:\n$e",
                  textAlign: TextAlign.center,
                  style: AppTypography.smallNormalBlack,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.invalidate(transferDetailProvider(transferId)),
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          ),
        ),
        data: (detail) {
          final transferDate =
              DateTime.tryParse(detail.transferDate) ?? DateTime.now();
          final animalCount =
              detail.details.isNotEmpty ? detail.details.length : 1;

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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatDateTime(transferDate),
                                    style: AppTypography.smallBoldBlack.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryShade,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "$animalCount Ekor",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                detail.transferCode,
                                style: AppTypography.smallNormalGrey,
                              ),
                              if (detail.notes != null &&
                                  detail.notes!.trim().isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  "Catatan: ${detail.notes}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.black,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.fieldBorder,
                        ),
                        if (detail.details.isNotEmpty)
                          ...detail.details.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final item = entry.value;
                            final animal = item.animalProfile;

                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: idx < detail.details.length - 1
                                    ? const Border(
                                        bottom: BorderSide(
                                          color: AppColors.fieldBorder,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductHeaderCard(
                                    title: animal.animalCode,
                                    subtitle:
                                        "${animal.name} • ${animal.weight > 0 ? '${animal.weight.floor()} kg' : (animal.animalGroup?.name ?? '-')}",
                                    image: AppImages.icProduct,
                                    status: animal.available,
                                  ),
                                  if (item.shippingCost > 0 ||
                                      item.notes.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (item.shippingCost > 0)
                                          Text(
                                            "Biaya: Rp ${formatPrice(item.shippingCost.toInt())}",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        if (item.notes.isNotEmpty)
                                          Expanded(
                                            child: Text(
                                              "Catatan: ${item.notes}",
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.grey,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            );
                          })
                        else if (detail.animalProfile != null)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: ProductHeaderCard(
                              title: detail.animalProfile!.animalCode,
                              subtitle:
                                  "${detail.animalProfile!.name} • ${detail.animalProfile!.animalGroup?.name ?? '-'}",
                              image: AppImages.icProduct,
                              status: detail.animalProfile!.available,
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
                          subtitle: detail.fromFarmArea.areaName,
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
                          subtitle: detail.toFarmArea.areaName,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SectionCard(
                title: "Rincian Biaya",
                children: [
                  CardWrapper(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Biaya Pengiriman",
                          style: AppTypography.smallNormalBlack,
                        ),
                        Text(
                          "Rp ${formatPrice(double.tryParse(detail.shippingCost)?.toInt() ?? 0)}",
                          style: AppTypography.mediumBoldPrimary,
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
