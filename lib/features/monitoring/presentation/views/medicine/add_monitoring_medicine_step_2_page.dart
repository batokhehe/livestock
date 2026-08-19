import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';

import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/card_wrapper.dart';
import '../../../../../core/widgets/step_info_card.dart';
import '../../../data/monitoring_item_model.dart';
import '../../../monitoring_provider.dart';
import 'widgets/add_item_medicine_bottom_sheet.dart';
import 'widgets/edit_item_medicine_bottom_sheet.dart';
import 'widgets/monitoring_medicine_item_card.dart';
import 'widgets/delete_confirm_bottom_sheet.dart';

class AddMonitoringMedicineStep2Page extends ConsumerStatefulWidget {
  const AddMonitoringMedicineStep2Page({super.key});

  @override
  ConsumerState<AddMonitoringMedicineStep2Page> createState() =>
      _AddMonitoringMedicineStep2PageState();
}

class _AddMonitoringMedicineStep2PageState
    extends ConsumerState<AddMonitoringMedicineStep2Page> {
  void _openAddItemSheet() async {
    final result = await showModalBottomSheet<MonitoringItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddItemMedicineBottomSheet(),
    );

    if (result != null) {
      ref
          .read(addedMonitoringMedicineItemsProvider.notifier)
          .update((state) => [...state, result]);
    }
  }

  void _openEditItemSheet(int index, MonitoringItem item) async {
    final result = await showModalBottomSheet<MonitoringItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditItemMedicineBottomSheet(itemToEdit: item),
    );

    if (result != null) {
      ref.read(addedMonitoringMedicineItemsProvider.notifier).update((state) {
        final list = [...state];
        list[index] = result;
        return list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(addedMonitoringMedicineItemsProvider);

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
          Padding(
            padding: const EdgeInsets.all(16),
            child: StepInfoCard(title: "Item Obat", step: 2, totalStep: 3),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _infoItem(items),
            ),
          ),
          _NextButton(enabled: items.isNotEmpty),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.icNoItem),
          const SizedBox(height: 24),
          const Text(
            "Belum Ada Item yang Ditambahkan",
            style: AppTypography.mediumBoldBlack,
          ),
          const SizedBox(height: 4),
          const Text(
            "Tambahkan minimal satu item untuk melanjutkan proses Monitoring",
            textAlign: TextAlign.center,
            style: AppTypography.smallNormalGrey,
          ),
        ],
      ),
    );
  }

  Widget _infoItem(List<MonitoringItem> items) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Informasi Item",
                style: AppTypography.mediumNormalBlack,
              ),
              _addButtonSmall(),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: items.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_emptyState()],
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) => MonitoringMedicineItemCard(
                      item: items[i],
                      onDelete: () => _showDeleteConfirmSheet(items[i]),
                      onEdit: () => _openEditItemSheet(i, items[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _addButtonSmall() {
    return OutlinedButton.icon(
      onPressed: _openAddItemSheet,
      icon: const Icon(Icons.add, size: 16, color: AppColors.white),
      label: const Text("Tambah Item", style: AppTypography.xSmallNormalWhite),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  void _showDeleteConfirmSheet(MonitoringItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeleteConfirmBottomSheet(
        onDelete: () {
          ref
              .read(addedMonitoringMedicineItemsProvider.notifier)
              .update((state) => state.where((e) => e != item).toList());
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final bool enabled;
  const _NextButton({required this.enabled});

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
              disabledBackgroundColor: AppColors.grey3,
              disabledForegroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: enabled
                ? () {
                    context.push("/monitoring/add/confirmation?type=medicine");
                  }
                : null,
            child: const Text(
              "Selanjutnya",
              style: AppTypography.mediumBoldWhite,
            ),
          ),
        ),
      ),
    );
  }
}
