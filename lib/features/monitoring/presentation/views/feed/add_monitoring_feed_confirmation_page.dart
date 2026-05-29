import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/status_chips.dart';
import 'package:livestock/features/monitoring/presentation/widgets/confirmation_item_double_card.dart';

import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/step_info_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/helpers/utils.dart';
import '../../../../../core/constant/enum.dart';
import 'package:livestock/features/monitoring/data/monitoring_model.dart';
import 'package:livestock/features/monitoring/data/monitoring_item_model.dart';
import 'package:livestock/features/receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../../monitoring_provider.dart';

class AddMonitoringFeedConfirmationPage extends ConsumerWidget {
  const AddMonitoringFeedConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(addedMonitoringFeedItemsProvider);
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Pemantauan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const StepInfoCard(title: "Tinjau Pemantauan", step: 3, totalStep: 3),
                const SizedBox(height: 12),
                const _MonitoringInfoSection(),
                const SizedBox(height: 12),
                const _FarmInfoSection(),
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
                      items.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "Belum ada item",
                                  style: AppTypography.smallNormalGrey,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                ...items.map((item) {
                                  return _itemCard(item, ref);
                                }),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total Keseluruhan",
                                      style: AppTypography.smallBoldBlack,
                                    ),
                                    Text(
                                      "Rp ${formatPrice(items.fold<int>(0, (sum, item) => sum + ((item.quantity ?? 0) * (item.price ?? 0))))}",
                                      style: AppTypography.smallBoldPrimary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const _NextButton(),
        ],
      ),
    );
  }

  Widget _itemCard(MonitoringItem item, WidgetRef ref) {
    final availableCountAsync = ref.watch(monitoringAnimalAvailableCountProvider);
    final availableCount = availableCountAsync.value ?? 0;
    
    final satuan = ref.watch(monitoringFeedSatuanProvider);
    final qty = item.quantity ?? 0;
    final ratio = availableCount > 0 ? (qty / availableCount) : 0.0;
    final ratioStr = ratio == ratio.toInt() ? ratio.toInt().toString() : ratio.toStringAsFixed(2);
    
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name ?? "-", style: AppTypography.smallBoldBlack),
                  Text(item.code ?? "-", style: AppTypography.smallNormalGrey),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusChips(text: "${item.stock ?? 0} Stock", color: AppColors.success),
                  Text(item.unit ?? "Karung", style: AppTypography.smallNormalGrey),
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
                  Text("$qty", style: AppTypography.smallBoldBlack),
                  const Text("Kuantitas", style: AppTypography.smallNormalGrey),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("$ratioStr ${satuan.isNotEmpty ? satuan : (item.unit ?? '')}", style: AppTypography.smallBoldBlack),
                  const Text("Rasio Kuantitas", style: AppTypography.smallNormalGrey),
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
              const Text("Harga Total", style: AppTypography.xSmallNormalGrey),
              Text("Rp ${formatPrice(qty * (item.price ?? 0))}", style: AppTypography.smallBoldBlack),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Catatan", style: AppTypography.xSmallNormalGrey),
              Text(item.note?.isNotEmpty == true ? item.note! : "-", style: AppTypography.smallBoldBlack),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonitoringInfoSection extends ConsumerWidget {
  const _MonitoringInfoSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedMonitoringDateProvider);
    final selectedEmployee = ref.watch(selectedMonitoringEmployeeProvider);
    final dateStr = selectedDate != null ? formatDateTime(selectedDate) : "-";
    final employeeStr = selectedEmployee != null
        ? "${selectedEmployee.name} • ${selectedEmployee.phone}"
        : "-";
        
    final items = ref.watch(addedMonitoringFeedItemsProvider);
    final totalQty = items.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));
    
    final monitoringItem = Monitoring(
      code: dateStr,
      subtitle: 'Pakan',
      title: employeeStr,
      description: "Satuan ${ref.watch(monitoringFeedSatuanProvider)}",
      count: totalQty,
      total: totalQty,
      status: ItemStatus.feed,
      date: selectedDate ?? DateTime.now(),
      items: items,
      location: "Satuan ${ref.watch(monitoringFeedSatuanProvider)}"
    );

    return SectionCard(
      title: "Informasi Pemantauan",
      children: [ConfirmationItemDoubleCard(item: monitoringItem)],
    );
  }
}

class _FarmInfoSection extends ConsumerWidget {
  const _FarmInfoSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farm = ref.watch(selectedMonitoringFarmProvider);
    final area = ref.watch(selectedMonitoringAreaProvider);
    final animalCountAsync = ref.watch(monitoringAnimalAvailableCountProvider);
    final animalCount = animalCountAsync.value ?? 0;

    return SectionCard(
      title: "Informasi Peternakan",
      children: [
        CardWrapper(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(farm?.name ?? "-", style: AppTypography.smallBoldBlack),
              Text(area?.name ?? "-", style: AppTypography.smallBoldRed),
            ],
          ),
        ),
        const SizedBox(height: 24),
        CardWrapper(
          child: Column(
            children: [
              ProductHeaderCard(
                title: "$animalCount Hewan",
                subtitle: "Hewan Tersedia",
                image: AppImages.icProduct,
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "satuan per hewan",
                    style: AppTypography.smallNormalBlack,
                  ),
                  Text("$animalCount Hewan", style: AppTypography.smallBoldBlack),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const ConfirmationBottomSheet(
                  header: "Konfirmasi Pemantauan",
                  title: "Simpan Pemantauan?",
                  subTitle:
                      "Data Pemantauan Pakan akan disimpan dan diterapkan ke seluruh hewan di area ini.",
                  saveText: "Simpan Pemantauan",
                ),
              );
            },
            child: const Text(
              "Konfirmasi Pemantauan",
              style: AppTypography.mediumBoldWhite,
            ),
          ),
        ),
      ),
    );
  }
}
