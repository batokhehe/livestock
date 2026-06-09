import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/success_notification.dart';
import '../widgets/monitoring_weight_item_card.dart';

import '../../../../../../core/theme/AppColors.dart';
import '../../../../../../core/theme/AppTypography.dart';
import '../../../../../../core/widgets/section_card.dart';
import '../../../../../../core/widgets/step_info_card.dart';
import 'package:livestock/features/receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../../notifier/update_weight_monitoring_notifier.dart';
import '../../../notifier/weight_monitoring_list_notifier.dart';
import '../../../../data/weight_monitoring_model.dart';
import 'edit_monitoring_weight_provider.dart';

class EditMonitoringWeightConfirmationPage extends ConsumerWidget {
  final WeightMonitoring item;
  const EditMonitoringWeightConfirmationPage({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(editAddedMonitoringWeightItemsProvider);

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
                              children: items.map((item) {
                                return MonitoringWeightItemCard(item: item);
                              }).toList(),
                            ),
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
}

class _MonitoringInfoSection extends ConsumerWidget {
  const _MonitoringInfoSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(editSelectedMonitoringDateProvider);
    final selectedEmployee = ref.watch(editSelectedMonitoringEmployeeProvider);

    final dateStr = selectedDate != null ? formatDateTime(selectedDate) : "-";
    final employeeStr = selectedEmployee != null
        ? "${selectedEmployee.name} • ${selectedEmployee.phone}"
        : "-";

    return SectionCard(
      title: "Informasi Pemantauan",
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
                      dateStr,
                      style: AppTypography.smallBoldBlack.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Pemantauan Bobot",
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
                child: Text(employeeStr, style: AppTypography.smallBoldBlack),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NextButton extends ConsumerStatefulWidget {
  final WeightMonitoring item;
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
        title: "Simpan Perubahan?",
        subTitle:
            "Pastikan data yang anda submit sudah sesuai, aksi ini tidak dapat dibatalkan atau diubah kembali.",
        saveText: "Simpan Perubahan",
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final success = await ref
        .read(updateWeightMonitoringProvider.notifier)
        .updateWeightMonitoring(widget.item.id);

    if (!mounted) return;

    if (success) {
      ref.invalidate(weightMonitoringListProvider);
      context.go('/monitoring');
      SuccessNotification.show(
        title: 'Perubahan berhasil disimpan',
        subtitle: 'Pemantauan terupdate di sistem.',
      );
    } else {
      final err = ref.read(updateWeightMonitoringProvider).error;
      SuccessNotification.showError(
        title: 'Gagal menyimpan perubahan',
        subtitle: err?.toString() ?? 'Terjadi kesalahan, coba lagi.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(updateWeightMonitoringProvider).isLoading;

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
