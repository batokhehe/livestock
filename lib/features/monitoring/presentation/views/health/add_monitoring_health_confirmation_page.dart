import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/constant/enum.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/success_notification.dart';
import 'package:livestock/features/monitoring/data/monitoring_item_model.dart';
import 'package:livestock/features/monitoring/data/monitoring_model.dart';
import 'package:livestock/features/monitoring/presentation/widgets/confirmation_item_double_card.dart';
import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/step_info_card.dart';
import 'package:livestock/features/receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../../monitoring_provider.dart';
import '../../notifier/submit_animal_health_check_notifier.dart';

class AddMonitoringHealthConfirmationPage extends ConsumerWidget {
  const AddMonitoringHealthConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(addedMonitoringHealthItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Monitoring",
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
                  title: "Tinjau Monitoring",
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
                        ...items.map((item) => _itemCard(item)),
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

  Widget _itemCard(MonitoringItem item) {
    final qty = item.quantity ?? 0.0;
    final qtyStr = qty.toStringAsFixed(qty.truncateToDouble() == qty ? 0 : 2);

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
    final selectedDate = ref.watch(selectedHealthMonitoringDateProvider);
    final selectedEmployee = ref.watch(selectedMonitoringEmployeeProvider);
    final dateStr = selectedDate != null ? formatDateTime(selectedDate) : "-";
    final employeeStr = selectedEmployee != null
        ? "${selectedEmployee.name} • ${selectedEmployee.phone}"
        : "-";

    final items = ref.watch(addedMonitoringHealthItemsProvider);
    final totalQty = items.fold<double>(
      0.0,
      (sum, item) => sum + (item.quantity ?? 0.0),
    );

    final monitoringItem = Monitoring(
      code: dateStr,
      subtitle: 'Kesehatan',
      title: employeeStr,
      description: "Pengobatan",
      count: totalQty.toInt(),
      total: totalQty.toInt(),
      status: ItemStatus.waiting,
      date: selectedDate ?? DateTime.now(),
      items: items,
      location: "Kesehatan",
    );

    return SectionCard(
      title: "Informasi Monitoring",
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
    final animal = ref.watch(selectedHealthCheckAnimalProvider);

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
        if (animal != null)
          CardWrapper(
            child: ProductHeaderCard(
              title: animal.animalCode,
              subtitle: "${animal.name} • ${animal.weight.floor()} kg",
              image: AppImages.icProduct,
              status: animal.available,
            ),
          ),
      ],
    );
  }
}

class _NextButton extends ConsumerStatefulWidget {
  const _NextButton();

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
        header: "Konfirmasi Monitoring",
        title: "Simpan Monitoring?",
        subTitle:
            "Pastikan data yang anda submit sudah sesuai, aksi ini tidak dapat dibatalkan atau diubah kembali.",
        saveText: "Simpan Monitoring",
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final success = await ref
        .read(submitAnimalHealthCheckProvider.notifier)
        .submit();

    if (!mounted) return;

    if (success) {
      ref.invalidate(animalHealthCheckListProvider);
      context.go('/monitoring');
      SuccessNotification.show(
        title: 'Data berhasil disimpan',
        subtitle: 'Monitoring tercatat di sistem.',
      );
    } else {
      final err = ref.read(submitAnimalHealthCheckProvider).error;
      SuccessNotification.showError(
        title: 'Gagal menyimpan Monitoring',
        subtitle: err?.toString() ?? 'Terjadi kesalahan, coba lagi.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(submitAnimalHealthCheckProvider).isLoading;

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
                    "Konfirmasi Monitoring",
                    style: AppTypography.mediumBoldWhite,
                  ),
          ),
        ),
      ),
    );
  }
}
