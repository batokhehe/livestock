import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/status_chips.dart';
import 'package:livestock/features/monitoring/data/medicine_monitoring_model.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';

class MedicineMonitoringDetailPage extends ConsumerWidget {
  final int id;

  const MedicineMonitoringDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(medicineMonitoringDetailProvider(id));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Detail Monitoring",
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
                  'Gagal memuat detail Monitoring\n$err',
                  textAlign: TextAlign.center,
                  style: AppTypography.smallNormalGrey,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(medicineMonitoringDetailProvider(id)),
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          ),
        ),
        data: (data) {
          return Column(
            children: [
              Expanded(
                child: ListView(
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
                            ...data.details.map((item) => _itemCard(item)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _EditButton(item: data),
            ],
          );
        },
      ),
    );
  }

  Widget _itemCard(MedicineMonitoringDetail item) {
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
                    "Rp ${formatPrice(item.unitPrice)}",
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
                    "Rp ${formatPrice(item.total)}",
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
  final MedicineMonitoring data;

  const _MonitoringInfoSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final dateStr = formatDateTime(data.monitoringDate);
    final animalCount = data.totalAnimal.toInt();
    final medicineCount = data.totalMedicine.toInt();

    return SectionCard(
      title: "Informasi Monitoring",
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
                                data.monitoringCode,
                                style: AppTypography.smallBoldBlack,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "$animalCount hewan • ${data.farmLocationName}",
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
                        InfoTag(label: data.employeeName),
                        InfoTag(label: "$medicineCount obat"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12.0),
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
                  "Tanggal Monitoring",
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
  final MedicineMonitoring data;

  const _FarmInfoSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final animalCount = data.totalAnimal.toInt();
    final unitPerAnimalStr = data.unitPerAnimal.toStringAsFixed(
      data.unitPerAnimal.truncateToDouble() == data.unitPerAnimal ? 0 : 2,
    );

    return SectionCard(
      title: "Informasi Peternakan",
      children: [
        CardWrapper(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data.farmLocationName,
                  style: AppTypography.smallBoldBlack,
                ),
              ),
              const SizedBox(width: 12),
              Text(data.farmAreaName, style: AppTypography.smallBoldRed),
            ],
          ),
        ),
        const SizedBox(height: 8),
        CardWrapper(
          child: Column(
            children: [
              ProductHeaderCard(
                title: "$animalCount Hewan",
                subtitle: "Hewan Terpantau",
                image: AppImages.icProduct,
              ),
              const SizedBox(height: 8),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.fieldBorder,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "satuan per hewan",
                    style: AppTypography.smallNormalBlack,
                  ),
                  Text(
                    "$unitPerAnimalStr Unit",
                    style: AppTypography.smallBoldBlack,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditButton extends StatelessWidget {
  final MedicineMonitoring item;
  const _EditButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () {
            context.push('/monitoring/edit/medicine', extra: item);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Edit Data",
                  style: AppTypography.smallBoldPrimary.copyWith(
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.edit_rounded, color: Colors.blue.shade700, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
