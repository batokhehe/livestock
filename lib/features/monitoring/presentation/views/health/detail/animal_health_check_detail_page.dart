import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/status_chips.dart';
import 'package:livestock/features/monitoring/data/animal_health_check_model.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';

class AnimalHealthCheckDetailPage extends ConsumerWidget {
  final int id;

  const AnimalHealthCheckDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(animalHealthCheckDetailProvider(id));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Detail Pemantauan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: asyncDetail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Gagal memuat detail pemantauan\n$err',
                  textAlign: TextAlign.center,
                  style: AppTypography.smallNormalGrey,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(animalHealthCheckDetailProvider(id)),
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          ),
        ),
        data: (data) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _MonitoringInfoSection(data: data),
              const SizedBox(height: 12),
              _FarmInfoSection(data: data),
              const SizedBox(height: 12),
              CardWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Informasi Item",
                      style: AppTypography.mediumNormalBlack,
                    ),
                    const SizedBox(height: 12),
                    if (data.details.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            "Belum ada item obat",
                            style: AppTypography.smallNormalGrey,
                          ),
                        ),
                      )
                    else
                      ...data.details.map((item) => _itemCard(item)).toList(),
                  ],
                ),
              ),
              if (data.details.isNotEmpty) ...[
                const SizedBox(height: 12),
                _summaryCard(data),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _summaryCard(AnimalHealthCheck data) {
    return SectionCard(
      title: 'Rincian Bayar',
      children: [
        CardWrapper(
          child: Column(
            children: [
              ...data.details.map((item) {
                return _rowSummary(
                  item.feedMedicine?.name ?? "-",
                  "Rp ${formatPrice(item.total.toInt())}",
                );
              }),
              const SizedBox(height: 4),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.fieldBorder,
              ),
              const SizedBox(height: 12),
              _rowSummary(
                "Total Keseluruhan",
                "Rp ${formatPrice(data.totalCost.toInt())}",
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _rowSummary(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTypography.smallBoldBlack
                : AppTypography.smallNormalGrey,
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.smallBoldPrimary
                : AppTypography.smallBoldBlack,
          ),
        ],
      ),
    );
  }

  Widget _itemCard(AnimalHealthCheckDetail item) {
    final qty = item.quantity;
    final qtyStr = qty.toStringAsFixed(qty.truncateToDouble() == qty ? 0 : 2);

    final name = item.feedMedicine?.name ?? "-";
    final code = item.feedMedicineCode;
    final uom = item.uom.isNotEmpty ? item.uom : "Botol";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.smallBoldBlack,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(code, style: AppTypography.smallNormalGrey),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusChips(text: "$qtyStr Stok", color: AppColors.success),
                  Text(uom, style: AppTypography.smallNormalGrey),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(qtyStr, style: AppTypography.smallBoldBlack),
                  const Text("Kuantitas", style: AppTypography.smallNormalGrey),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${item.qtyRatioPerAnimal.toStringAsFixed(item.qtyRatioPerAnimal.truncateToDouble() == item.qtyRatioPerAnimal ? 0 : 2)} ${uom.toLowerCase()}",
                    style: AppTypography.smallBoldBlack,
                  ),
                  const Text(
                    "Rasio kuantitas",
                    style: AppTypography.smallNormalGrey,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rp ${formatPrice(item.unitPrice.toInt())}",
                    style: AppTypography.smallBoldBlack,
                  ),
                  const Text(
                    "Harga Satuan",
                    style: AppTypography.smallNormalGrey,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Rp ${formatPrice(item.total.toInt())}",
                    style: AppTypography.smallBoldRed,
                  ),
                  const Text(
                    "Total Harga",
                    style: AppTypography.smallNormalGrey,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonitoringInfoSection extends StatelessWidget {
  final AnimalHealthCheck data;

  const _MonitoringInfoSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final dateStr = formatDateTime(data.checkDate);
    final medicineCount = data.detailsCount;
    final employeeName = data.employeeName.isNotEmpty ? data.employeeName : (data.employee?.name ?? '');

    return SectionCard(
      title: "Informasi pemantauan",
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.fieldBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.checkCode,
                                style: AppTypography.smallBoldBlack,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${data.animalCode ?? '-'} • ${data.animalName ?? '-'}",
                                style: AppTypography.xSmallNormalGrey,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          data.farmAreaName,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        if (employeeName.isNotEmpty)
                          InfoTag(label: employeeName),
                        InfoTag(label: "$medicineCount obat"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.fieldBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateStr, style: AppTypography.smallBoldBlack),
                const SizedBox(height: 4),
                const Text(
                  "Tanggal Pemantauan",
                  style: AppTypography.xSmallNormalGrey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FarmInfoSection extends StatelessWidget {
  final AnimalHealthCheck data;

  const _FarmInfoSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final animalLabel = [
      if (data.animalCode != null && data.animalCode!.isNotEmpty) data.animalCode,
      if (data.animalName != null && data.animalName!.isNotEmpty) data.animalName,
    ].join(' • ');

    return SectionCard(
      title: "Informasi Peternakan",
      children: [
        CardWrapper(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.farmLocationName, style: AppTypography.smallBoldBlack),
              Text(data.farmAreaName, style: AppTypography.smallBoldRed),
            ],
          ),
        ),
        const SizedBox(height: 8),
        CardWrapper(
          child: ProductHeaderCard(
            title: animalLabel.isNotEmpty ? animalLabel : "Hewan Terpantau",
            subtitle: "Hewan Terpantau",
            image: AppImages.icProduct,
          ),
        ),
      ],
    );
  }
}
