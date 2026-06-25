import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/constant/enum.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/status_chips.dart';
import 'package:livestock/core/widgets/success_notification.dart';
import 'package:livestock/features/monitoring/data/monitoring_item_model.dart';
import 'package:livestock/features/monitoring/data/monitoring_model.dart';
import 'package:livestock/features/monitoring/presentation/widgets/confirmation_item_double_card.dart';
import 'package:livestock/features/monitoring/data/medicine_monitoring_model.dart';

import '../../../../../../core/theme/AppColors.dart';
import '../../../../../../core/theme/AppTypography.dart';
import '../../../../../../core/widgets/section_card.dart';
import '../../../../../../core/widgets/step_info_card.dart';
import 'package:livestock/features/receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';
import 'package:livestock/features/monitoring/presentation/notifier/update_health_monitoring_notifier.dart';
import 'package:livestock/features/monitoring/presentation/notifier/health_monitoring_list_notifier.dart';
import 'edit_monitoring_medicine_provider.dart';

class EditMonitoringMedicineConfirmationPage extends ConsumerWidget {
  final MedicineMonitoring item;
  const EditMonitoringMedicineConfirmationPage({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(editAddedMonitoringMedicineItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Edit Pemantauan",
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
                const StepInfoCard(
                  title: "Tinjau Pemantauan",
                  step: 3,
                  totalStep: 3,
                ),
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
                      if (items.isEmpty)
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
                        ...items.map((item) => _itemCard(item)).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _NextButton(item: item),
        ],
      ),
    );
  }

  Widget _itemCard(MonitoringItem item) {
    final qty = item.quantity ?? 0.0;
    final qtyStr = qty.toStringAsFixed(qty.truncateToDouble() == qty ? 0 : 2);
    final stock = double.tryParse(item.stock ?? '0') ?? 0.0;
    final stockStr = stock.toStringAsFixed(
      stock.truncateToDouble() == stock ? 0 : 2,
    );

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
                      item.name ?? "-",
                      style: AppTypography.smallBoldBlack,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.code ?? "-",
                      style: AppTypography.smallNormalGrey,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusChips(
                    text: "$stockStr Stock",
                    color: AppColors.success,
                  ),
                  Text(
                    item.unit ?? "Botol",
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
                  Text(qtyStr, style: AppTypography.smallBoldBlack),
                  const Text("Kuantitas", style: AppTypography.smallNormalGrey),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.note?.isNotEmpty == true ? item.note! : "-",
                    style: AppTypography.smallBoldBlack,
                  ),
                  const Text("Catatan", style: AppTypography.smallNormalGrey),
                ],
              ),
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
    final selectedDate = ref.watch(editSelectedMedicineMonitoringDateProvider);
    final selectedEmployee = ref.watch(editSelectedMedicineMonitoringEmployeeProvider);
    final dateStr = selectedDate != null ? formatDateTime(selectedDate) : "-";
    final employeeStr = selectedEmployee != null
        ? "${selectedEmployee.name} • ${selectedEmployee.phone}"
        : "-";

    final items = ref.watch(editAddedMonitoringMedicineItemsProvider);
    final totalQty = items.fold<double>(
      0.0,
      (sum, item) => sum + (item.quantity ?? 0.0),
    );

    final monitoringItem = Monitoring(
      code: dateStr,
      subtitle: 'Obat',
      title: employeeStr,
      description: "Pemantauan Obat",
      count: totalQty.toInt(),
      total: totalQty.toInt(),
      status: ItemStatus.waiting,
      date: selectedDate ?? DateTime.now(),
      items: items,
      location: "Obat",
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
    final farm = ref.watch(editSelectedMedicineMonitoringFarmProvider);
    final area = ref.watch(editSelectedMedicineMonitoringAreaProvider);
    final animalCountAsync = ref.watch(editMonitoringAnimalAvailableCountProvider);
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
        const SizedBox(height: 8),
        CardWrapper(
          child: Column(
            children: [
              ProductHeaderCard(
                title: "$animalCount Hewan",
                subtitle: "Hewan Tersedia",
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
                    "$animalCount Hewan",
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

class _NextButton extends ConsumerStatefulWidget {
  final MedicineMonitoring item;
  const _NextButton({required this.item});

  @override
  ConsumerState<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends ConsumerState<_NextButton> {
  Future<void> _onConfirmTap() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ConfirmationBottomSheet(
        header: "Konfirmasi Pemantauan",
        title: "Ubah Pemantauan?",
        subTitle:
            "Pastikan data yang anda submit sudah sesuai, aksi ini tidak dapat dibatalkan atau diubah kembali.",
        saveText: "Ubah Pemantauan",
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final success = await ref
        .read(updateHealthMonitoringProvider.notifier)
        .updateHealthMonitoring(widget.item.id);

    if (!mounted) return;

    if (success) {
      ref.invalidate(healthMonitoringListProvider);
      ref.invalidate(medicineMonitoringDetailProvider(widget.item.id));
      context.go('/monitoring');
      SuccessNotification.show(
        title: 'Data berhasil diubah',
        subtitle: 'Perubahan pemantauan tercatat di sistem.',
      );
    } else {
      final err = ref.read(updateHealthMonitoringProvider).error;
      SuccessNotification.showError(
        title: 'Gagal mengubah pemantauan',
        subtitle: err?.toString() ?? 'Terjadi kesalahan, coba lagi.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(updateHealthMonitoringProvider).isLoading;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.grey3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isLoading ? null : _onConfirmTap,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Text(
                    "Konfirmasi Pemantauan",
                    style: AppTypography.mediumBoldWhite,
                  ),
          ),
        ),
      ),
    );
  }
}
