import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/helpers/utils.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../data/model/sales_order_item_request_model.dart';
import '../../sales_order_provider.dart';
import '../widgets/add_item_bottom_sheet_animal.dart';
import '../widgets/add_item_bottom_sheet_feed.dart';
import '../widgets/sales_order_item_detail_bottom_sheet.dart';

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
      ref.read(salesOrderFormProvider.notifier).addItem(result);
    }
  }

  void _showItemDetailSheet(SalesOrderItemRequest item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SalesOrderItemDetailBottomSheet(item: item),
    );
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
          Image.asset(AppImages.imgEmptyTransaction, width: 180, height: 180),
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
        ? "${item.weight ?? item.animalProfile!.weight} Kg"
        : item.feedMedicine!.feedType;
    final useForecast = ref.read(salesOrderFormProvider).useForecast ?? true;

    return InkWell(
      onTap: () => _showItemDetailSheet(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8.0,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.greyBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            AppImages.icNavCow,
                            fit: BoxFit.contain,
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(code, style: AppTypography.smallBoldBlack),
                          Text(
                            "${item.animalProfile?.name} • $secondValue",
                            style: AppTypography.smallNormalGrey,
                          ),
                        ],
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
                Icon(Icons.navigate_next_rounded),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  useForecast
                      ? 'Rp ${formatPrice(item.unitPrice ?? 0)}'
                      : formatDateTime(item.dlvDate),
                  style: AppTypography.smallBoldBlack,
                ),
                Text(
                  'Rp ${formatPrice(item.subtotal ?? 0)}',
                  style: AppTypography.smallBoldBlack,
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  useForecast ? 'Harga/kg Forecast' : 'Tanggal Pengiriman',
                  style: AppTypography.xSmallNormalBlack,
                ),
                Text(
                  useForecast ? 'Total Forecast' : 'Subtotal',
                  style: AppTypography.xSmallNormalBlack,
                ),
              ],
            ),
          ],
        ),
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
      backgroundColor: AppColors.greyBg,
      builder: (_) => _DeleteConfirmBottomSheet(
        onDelete: () {
          ref.read(salesOrderFormProvider.notifier).removeItem(item);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _NextButton extends ConsumerWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(salesOrderFormProvider);
    final items = form.items ?? [];

    final bool isEnabled = items.isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled ? AppColors.primary : AppColors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isEnabled
                ? () {
                    context.push("/sales-order/add/confirmation");
                  }
                : null,
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
      decoration: BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hapus Item", style: AppTypography.largeBoldBlack),
                RawMaterialButton(
                  onPressed: () => Navigator.pop(context),
                  elevation: 1.0,
                  constraints: BoxConstraints(minWidth: 0.0),
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(
                    side: const BorderSide(
                      color: AppColors.iconColor,
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Icon(Icons.close_rounded, size: 12.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Image.asset(AppImages.icDeleteConfirmation, height: 120),
          const SizedBox(height: 20),
          Text("Hapus Item Ini?", style: AppTypography.mediumBoldBlack),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Item yang telah diinput akan dihapus dan tidak dapat dikembalikan. "
              "Apakah Anda yakin ingin melanjutkan?",
              textAlign: TextAlign.center,
              style: AppTypography.smallNormalGrey,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 16.0,
            ),
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[4],
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primaryShade,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: BorderSide(color: AppColors.primaryShade),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Batal",
                      style: AppTypography.smallBoldBlack.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onDelete,
                    child: Text(
                      "Hapus Sekarang",
                      style: AppTypography.smallBoldBlack.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
