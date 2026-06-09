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
import 'widgets/add_item_health_bottom_sheet.dart';
import 'widgets/edit_item_health_bottom_sheet.dart';
import 'widgets/monitoring_health_item_card.dart';
import '../medicine/widgets/delete_confirm_bottom_sheet.dart';

class AddMonitoringHealthStep2Page extends ConsumerStatefulWidget {
  const AddMonitoringHealthStep2Page({super.key});

  @override
  ConsumerState<AddMonitoringHealthStep2Page> createState() =>
      _AddMonitoringHealthStep2PageState();
}

class _AddMonitoringHealthStep2PageState
    extends ConsumerState<AddMonitoringHealthStep2Page> {
  void _openAddItemSheet() async {
    final result = await showModalBottomSheet<MonitoringItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddItemHealthBottomSheet(),
    );

    if (result != null) {
      ref
          .read(addedMonitoringHealthItemsProvider.notifier)
          .update((state) => [...state, result]);
    }
  }

  void _openEditItemSheet(int index, MonitoringItem item) async {
    final result = await showModalBottomSheet<MonitoringItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditItemHealthBottomSheet(itemToEdit: item),
    );

    if (result != null) {
      ref.read(addedMonitoringHealthItemsProvider.notifier).update((state) {
        final list = [...state];
        list[index] = result;
        return list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keep Step 1 providers alive during Step 2
    ref.watch(selectedHealthMonitoringDateProvider);
    ref.watch(selectedMonitoringEmployeeProvider);
    ref.watch(selectedMonitoringFarmProvider);
    ref.watch(selectedMonitoringAreaProvider);
    ref.watch(selectedHealthCheckAnimalProvider);

    final items = ref.watch(addedMonitoringHealthItemsProvider);

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
          const Padding(
            padding: EdgeInsets.all(16),
            child: StepInfoCard(title: "Item Kesehatan", step: 2, totalStep: 3),
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
            "Tambahkan minimal satu item untuk melanjutkan proses pemantauan",
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
                    itemBuilder: (_, i) => MonitoringHealthItemCard(
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
              .read(addedMonitoringHealthItemsProvider.notifier)
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
                    context.push("/monitoring/add/confirmation?type=health");
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
