import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../data/model/purchase_order_item_request_model.dart';
import '../../purchase_order_provider.dart';
import '../widgets/add_item_bottom_sheet_animal.dart';
import '../widgets/add_item_bottom_sheet_feed.dart';

class AddPurchaseOrderStep2Page extends ConsumerStatefulWidget {
  const AddPurchaseOrderStep2Page({super.key});

  @override
  ConsumerState<AddPurchaseOrderStep2Page> createState() =>
      _AddPurchaseOrderStep2PageState();
}

class _AddPurchaseOrderStep2PageState
    extends ConsumerState<AddPurchaseOrderStep2Page> {
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

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(purchaseOrderFormProvider);
    final items = request.items ?? [];

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Pembelian",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: StepInfoCard(
              title: "Informasi Pesanan Pembelian",
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

  Widget _itemCard(PurchaseOrderItemRequest item, int index) {
    if (item.animalName != null || item.animalCode != null) {
      return _AnimalItemCard(
        item: item,
        onDelete: () => _showDeleteConfirmSheet(item),
        onEdit: () => _openEditItemSheet(item, index),
      );
    } else if (item.feedMedicine != null || item.feedMedicineName != null) {
      return _FeedItemCard(
        item: item,
        onDelete: () => _showDeleteConfirmSheet(item),
        onEdit: () => _openEditItemSheet(item, index),
      );
    } else {
      return _EquipmentItemCard(
        item: item,
        onDelete: () => _showDeleteConfirmSheet(item),
        onEdit: () => _openEditItemSheet(item, index),
      );
    }
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

  void _showDeleteConfirmSheet(PurchaseOrderItemRequest item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeleteConfirmBottomSheet(
        onDelete: () {
          final current = ref.read(purchaseOrderFormProvider);

          ref.read(purchaseOrderFormProvider.notifier).state = current.copyWith(
            items: current.items?.where((e) => e != item).toList(),
          );

          Navigator.pop(context);
        },
      ),
    );
  }

  void _openEditItemSheet(PurchaseOrderItemRequest item, int index) async {
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
}

class _NextButton extends ConsumerWidget {
  const _NextButton();

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
                    context.push("/purchase-order/add/confirmation");
                  }
                : null,
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}

class _AnimalItemCard extends StatelessWidget {
  final PurchaseOrderItemRequest item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _AnimalItemCard({
    required this.item,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseItemCard(
      title: item.animalCode ?? "-",
      subtitle: item.animalName ?? "-",
      icon: AppImages.icNavCow,
      isSvg: true,
      onDelete: onDelete,
      onEdit: onEdit,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${item.initialWeight} kg",
              style: AppTypography.smallBoldBlack,
            ),
            Text(
              'Rp ${formatPrice(item.purchPrice ?? 0)}',
              style: AppTypography.smallBoldBlack,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Berat', style: AppTypography.xSmallNormalBlack),
            Text('Harga Beli', style: AppTypography.xSmallNormalBlack),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${item.ageCategory}", style: AppTypography.smallBoldBlack),
            if (item.isVaccinated == true && item.vaccineDate != null)
              Text(
                formatDateTime(item.vaccineDate),
                style: AppTypography.smallBoldBlack,
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Kategori Umur', style: AppTypography.xSmallNormalBlack),
            if (item.isVaccinated == true && item.vaccineDate != null)
              const Text(
                'Tanggal Vaksin',
                style: AppTypography.xSmallNormalBlack,
              ),
          ],
        ),
      ],
    );
  }
}

class _FeedItemCard extends StatelessWidget {
  final PurchaseOrderItemRequest item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _FeedItemCard({
    required this.item,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseItemCard(
      title: item.feedMedicineCode ?? "-",
      subtitle: item.feedMedicineName ?? "-",
      icon: AppImages.icProduct,
      isSvg: false,
      onDelete: onDelete,
      onEdit: onEdit,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${item.quantity} item", style: AppTypography.smallBoldBlack),
            Text(
              'Rp ${formatPrice(item.purchPrice ?? 0)}',
              style: AppTypography.smallBoldBlack,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Kuantitas', style: AppTypography.xSmallNormalBlack),
            Text('Harga Beli', style: AppTypography.xSmallNormalBlack),
          ],
        ),
      ],
    );
  }
}

class _EquipmentItemCard extends StatelessWidget {
  final PurchaseOrderItemRequest item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _EquipmentItemCard({
    required this.item,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseItemCard(
      title: item.equipmentName ?? "-",
      subtitle: item.equipmentCode ?? "-",
      icon: AppImages.icBox,
      isSvg: false,
      onDelete: onDelete,
      onEdit: onEdit,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${item.quantity} item", style: AppTypography.smallBoldBlack),
            Text(
              'Rp ${formatPrice(item.purchPrice ?? 0)}',
              style: AppTypography.smallBoldBlack,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Kuantitas', style: AppTypography.xSmallNormalBlack),
            Text('Harga Beli', style: AppTypography.xSmallNormalBlack),
          ],
        ),
      ],
    );
  }
}

class _BaseItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final bool isSvg;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final List<Widget> children;

  const _BaseItemCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSvg,
    required this.onDelete,
    required this.onEdit,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _itemIcon(icon, isSvg: isSvg),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTypography.smallBoldBlack,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              subtitle,
                              style: AppTypography.smallNormalGrey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.0),
                _iconAction(
                  icon: Icons.delete,
                  color: AppColors.danger,
                  backColor: AppColors.danger.withOpacity(0.08),
                  onTap: onDelete,
                ),
                const SizedBox(width: 8),
                _iconAction(
                  icon: Icons.edit,
                  color: AppColors.white,
                  backColor: AppColors.primary,
                  onTap: onEdit,
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _itemIcon(String icon, {required bool isSvg}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: isSvg
            ? SvgPicture.asset(
                icon,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              )
            : Image.asset(icon, fit: BoxFit.contain),
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
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
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
