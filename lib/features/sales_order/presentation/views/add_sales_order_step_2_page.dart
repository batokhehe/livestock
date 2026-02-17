import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../data/model/sales_order_item_request_model.dart';
import '../../sales_order_provider.dart';
import '../widgets/add_item_bottom_sheet_animal.dart';
import '../widgets/add_item_bottom_sheet_feed.dart';

class AddSalesOrderStep2Page extends ConsumerStatefulWidget {
  const AddSalesOrderStep2Page({super.key});

  @override
  ConsumerState<AddSalesOrderStep2Page> createState() =>
      _AddSalesOrderStep2PageState();
}

class _AddSalesOrderStep2PageState
    extends ConsumerState<AddSalesOrderStep2Page> {
  void _openAddItemSheet() async {
    final form = ref.read(salesOrderFormProvider);
    final type = form.salesItemType;

    Widget sheet;

    if (type == 'animal') {
      sheet = const AddItemBottomSheetAnimal();
    } else {
      sheet = const AddItemBottomSheetFeed();
    }

    final result = await showModalBottomSheet<SalesOrderItemRequest>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );

    if (result != null) {
      final current = ref.read(salesOrderFormProvider);

      ref.read(salesOrderFormProvider.notifier).state = current.copyWith(
        items: [...?current.items, result],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(salesOrderFormProvider);
    final items = request.items ?? [];

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Penjualan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: StepInfoCard(
              title: "Informasi Pesanan Penjualan",
              step: 2,
              totalStep: 3,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
              child: _infoItem(items),
            ),
          ),
          _NextButton(),
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
          SizedBox(height: 24),
          Text(
            "Belum Ada Item yang Ditambahkan",
            style: AppTypography.mediumBoldBlack,
          ),
          SizedBox(height: 4),
          Text(
            "Tambahkan minimal satu item untuk melanjutkan proses penjualan",
            textAlign: TextAlign.center,
            style: AppTypography.smallNormalGrey,
          ),
        ],
      ),
    );
  }

  Widget _itemCard(SalesOrderItemRequest item) {
    final isAnimal = item.animalProfile != null;

    final code = isAnimal
        ? item.animalProfile!.animalCode
        : item.feedMedicine!.code;

    final secondValue = isAnimal
        ? "${item.animalProfile!.weight} Kg"
        : item.feedMedicine!.feedType;
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.animalProfile?.name ?? item.feedMedicine!.name,
                      style: AppTypography.smallBoldBlack,
                    ),
                    Text(
                      "$code • $secondValue",
                      style: AppTypography.smallNormalGrey,
                    ),
                  ],
                ),
              ),
              _iconAction(
                icon: Icons.delete,
                color: AppColors.danger,
                backColor: AppColors.danger.withOpacity(0.08),
                onTap: () => _showDeleteConfirmSheet(item),
              ),
              const SizedBox(width: 8),
              _iconAction(
                icon: Icons.edit,
                color: AppColors.white,
                backColor: AppColors.primary,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp ${item.unitPrice.toString()}',
                style: AppTypography.smallBoldBlack,
              ),
              Text(
                'Rp ${item.subtotal.toString()}',
                style: AppTypography.smallBoldBlack,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Harga/kg Forecast', style: AppTypography.xSmallNormalBlack),
              Text('Total Forecast', style: AppTypography.xSmallNormalBlack),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconAction({
    required IconData icon,
    required Color color,
    required Color backColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _infoItem(List<SalesOrderItemRequest> items) {
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
                    itemBuilder: (_, i) => _itemCard(items[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _addButtonSmall() {
    return OutlinedButton.icon(
      onPressed: _openAddItemSheet,
      icon: Icon(Icons.add, size: 16, color: AppColors.white),
      label: Text("Tambah Item", style: AppTypography.xSmallNormalWhite),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  void _showDeleteConfirmSheet(SalesOrderItemRequest item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeleteConfirmBottomSheet(
        onDelete: () {
          final current = ref.read(salesOrderFormProvider);

          ref.read(salesOrderFormProvider.notifier).state = current.copyWith(
            items: current.items?.where((e) => e != item).toList(),
          );

          Navigator.pop(context);
        },
      ),
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
              context.push("/sales-order/add/confirmation");
            },
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
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
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Hapus Item", style: AppTypography.largeBoldBlack),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Image.asset(AppImages.icDeleteConfirmation, height: 120),
          const SizedBox(height: 20),
          Text("Hapus Item Ini?", style: AppTypography.mediumBoldBlack),
          const SizedBox(height: 8),
          Text(
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
                    side: BorderSide(color: AppColors.primaryShade),
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
                    style: AppTypography.mediumBoldWhite,
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
