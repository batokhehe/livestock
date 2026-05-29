import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';

import '../../../../../../core/theme/AppColors.dart';
import '../../../../../../core/theme/AppTypography.dart';
import '../../../../../../core/widgets/card_wrapper.dart';
import '../../../../../../core/widgets/step_info_card.dart';
import '../../../../data/monitoring_item_model.dart';
import '../../../../data/weight_monitoring_model.dart';
import '../widgets/add_item_bottom_sheet_weight.dart';
import '../widgets/edit_item_bottom_sheet_weight.dart';
import '../widgets/monitoring_weight_item_card.dart';
import 'edit_monitoring_weight_provider.dart';

class EditMonitoringWeightStep2Page extends ConsumerStatefulWidget {
  final WeightMonitoring item;
  const EditMonitoringWeightStep2Page({super.key, required this.item});

  @override
  ConsumerState<EditMonitoringWeightStep2Page> createState() =>
      _EditMonitoringWeightStep2PageState();
}

class _EditMonitoringWeightStep2PageState
    extends ConsumerState<EditMonitoringWeightStep2Page> {
  List<MonitoringItem> get items =>
      ref.read(editAddedMonitoringWeightItemsProvider);

  void _openAddItemSheet() async {
    final result = await showModalBottomSheet<MonitoringItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddItemBottomSheetWeight(
        excludedIds: items.map((e) => int.tryParse(e.id ?? '') ?? 0).toList(),
      ),
    );

    if (result != null) {
      ref
          .read(editAddedMonitoringWeightItemsProvider.notifier)
          .update((state) => [...state, result]);
    }
  }

  void _openEditItemSheet(MonitoringItem item) async {
    final result = await showModalBottomSheet<MonitoringItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditItemBottomSheetWeight(
        excludedIds: items
            .where((e) => e.id != item.id)
            .map((e) => int.tryParse(e.id ?? '') ?? 0)
            .toList(),
        item: item,
      ),
    );

    if (result != null) {
      final index = items.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        ref.read(editAddedMonitoringWeightItemsProvider.notifier).update((state) {
          final list = [...state];
          list[index] = result;
          return list;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(editAddedMonitoringWeightItemsProvider);
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: StepInfoCard(
              title: "Item Pemantauan",
              step: 2,
              totalStep: 3,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _infoItem(),
            ),
          ),
          _NextButton(item: widget.item),
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

  Widget _infoItem() {
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
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return MonitoringWeightItemCard(
                        item: item,
                        onDelete: () => _showDeleteConfirmSheet(item),
                        onEdit: () => _openEditItemSheet(item),
                      );
                    },
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
      builder: (_) => _DeleteConfirmBottomSheet(
        onDelete: () {
          ref
              .read(editAddedMonitoringWeightItemsProvider.notifier)
              .update((state) => state.where((e) => e.id != item.id).toList());
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _NextButton extends ConsumerWidget {
  final WeightMonitoring item;
  const _NextButton({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(editAddedMonitoringWeightItemsProvider);
    final isValid = items.isNotEmpty;

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
            onPressed: isValid
                ? () {
                    context.push("/monitoring/edit/confirmation", extra: item);
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

class _DeleteConfirmBottomSheet extends StatelessWidget {
  final VoidCallback onDelete;

  const _DeleteConfirmBottomSheet({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Hapus Item", style: AppTypography.largeBoldBlack),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Image.asset(AppImages.icDeleteConfirmation, height: 120),
          const SizedBox(height: 20),
          const Text("Hapus Item Ini?", style: AppTypography.mediumBoldBlack),
          const SizedBox(height: 8),
          const Text(
            "Item yang telah diinput akan dihapus dan tidak dapat dikembalikan. "
            "Apakah Anda yakin ingin melanjutkan?",
            textAlign: TextAlign.center,
            style: AppTypography.smallNormalGrey,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.primaryShade,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.primaryShade),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Batal",
                    style: AppTypography.mediumBoldPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onDelete,
                  child: Text(
                    "Hapus Sekarang",
                    style: AppTypography.mediumBoldWhite.copyWith(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
