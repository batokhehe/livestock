import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';

import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/card_wrapper.dart';
import '../../../../../core/widgets/step_info_card.dart';
import '../../../data/model/purchase_order_item_request_model.dart';
import '../../../data/model/purchase_order_list_model.dart';
import '../../../purchase_order_provider.dart';
import '../../widgets/add_item_bottom_sheet_animal.dart';
import '../../widgets/add_item_bottom_sheet_feed.dart';
import 'widgets/delete_confirm_bottom_sheet.dart';
import 'widgets/edit_animal_item_card.dart';
import 'widgets/edit_equipment_item_card.dart';
import 'widgets/edit_feed_item_card.dart';

class EditPurchaseOrderStep2Page extends ConsumerStatefulWidget {
  final PurchaseOrderList data;

  const EditPurchaseOrderStep2Page({super.key, required this.data});

  @override
  ConsumerState<EditPurchaseOrderStep2Page> createState() =>
      _EditPurchaseOrderStep2PageState();
}

class _EditPurchaseOrderStep2PageState
    extends ConsumerState<EditPurchaseOrderStep2Page> {
  void _openAddItemSheet() async {
    final form = ref.read(purchaseOrderFormProvider);
    final type = form.purchaseItemType;

    Widget sheet;
    if (type == 'animal') {
      sheet = const AddItemBottomSheetAnimal();
    } else {
      sheet = const AddItemBottomSheetFeed();
    }

    final result = await showModalBottomSheet<PurchaseOrderItemRequest>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );

    if (result != null) {
      final current = ref.read(purchaseOrderFormProvider);
      ref.read(purchaseOrderFormProvider.notifier).state = current.copyWith(
        items: [...?current.items, result],
      );
    }
  }

  void _onEdit(PurchaseOrderItemRequest item, int index) async {
    final form = ref.read(purchaseOrderFormProvider);
    final type = form.purchaseItemType;

    Widget sheet;
    if (type == 'animal') {
      sheet = AddItemBottomSheetAnimal(initialData: item);
    } else {
      sheet = AddItemBottomSheetFeed(initialData: item);
    }

    final result = await showModalBottomSheet<PurchaseOrderItemRequest>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );

    if (result != null) {
      final current = ref.read(purchaseOrderFormProvider);
      final updatedItems = [...?current.items];
      updatedItems[index] = result;
      ref.read(purchaseOrderFormProvider.notifier).state = current.copyWith(
        items: updatedItems,
      );
    }
  }

  void _onDelete(int index) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeleteConfirmBottomSheet(
        onDelete: () => Navigator.pop(context, true),
      ),
    );

    if (result == true) {
      final current = ref.read(purchaseOrderFormProvider);
      final updatedItems = [...?current.items];
      updatedItems.removeAt(index);
      ref.read(purchaseOrderFormProvider.notifier).state = current.copyWith(
        items: updatedItems,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(purchaseOrderFormProvider);
    final items = request.items ?? [];

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Edit Pembelian",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: const StepInfoCard(
              title: "Informasi Pesanan Pembelian",
              step: 2,
              totalStep: 3,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _infoItem(items),
            ),
          ),
          _EditStep2NextButton(data: widget.data),
        ],
      ),
    );
  }

  Widget _infoItem(List<PurchaseOrderItemRequest> items) {
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
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) => _itemCard(items[i], i),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.icNoItem, width: 120),
          const SizedBox(height: 16),
          const Text(
            "Belum Ada Item yang Ditambahkan",
            style: AppTypography.mediumBoldBlack,
          ),
          const SizedBox(height: 4),
          const Text(
            "Tambahkan minimal satu item untuk melanjutkan proses Pembelian",
            textAlign: TextAlign.center,
            style: AppTypography.smallNormalGrey,
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

  Widget _itemCard(PurchaseOrderItemRequest item, int index) {
    if (item.animalName != null || item.animalCode != null) {
      return EditAnimalItemCard(
        item: item,
        onDelete: () => _onDelete(index),
        onEdit: () => _onEdit(item, index),
      );
    } else if (item.feedMedicine != null || item.feedMedicineName != null) {
      return EditFeedItemCard(
        item: item,
        onDelete: () => _onDelete(index),
        onEdit: () => _onEdit(item, index),
      );
    } else {
      return EditEquipmentItemCard(
        item: item,
        onDelete: () => _onDelete(index),
        onEdit: () => _onEdit(item, index),
      );
    }
  }
}

class _EditStep2NextButton extends ConsumerWidget {
  final PurchaseOrderList data;

  const _EditStep2NextButton({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(purchaseOrderFormProvider);
    final items = request.items ?? [];
    final isValid = items.isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isValid ? AppColors.primary : AppColors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isValid
                ? () {
                    context.push(
                      '/purchase-order/edit/confirmation',
                      extra: data,
                    );
                  }
                : null,
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}

// ---- Item Cards (copied structure from Step 2) ----
