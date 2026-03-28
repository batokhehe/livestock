import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';

import '../../../../core/helpers/currency_input_formatter.dart';
import '../../../../core/helpers/utils.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../../core/widgets/product_header_card.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../../../core/widgets/two_column_row_card.dart';
import '../../data/model/dispatch_item_request_model.dart';
import '../../dispatch_provider.dart';
import '../widgets/add_item_bottom_sheet.dart';

class AddDispatchStep2Page extends ConsumerStatefulWidget {
  const AddDispatchStep2Page({super.key});

  @override
  ConsumerState<AddDispatchStep2Page> createState() =>
      _AddDispatchStep2PageState();
}

class _AddDispatchStep2PageState extends ConsumerState<AddDispatchStep2Page> {
  late final TextEditingController downPaymentController;
  late final TextEditingController additionalCostController;

  @override
  void initState() {
    super.initState();

    downPaymentController = TextEditingController();
    additionalCostController = TextEditingController();

    downPaymentController.addListener(() {
      final raw = downPaymentController.text.replaceAll('.', '');
      final value = int.tryParse(raw) ?? 0;

      ref.read(dispatchFormProvider.notifier).setDownPayment(value);
    });

    additionalCostController.addListener(() {
      final raw = additionalCostController.text.replaceAll('.', '');
      final value = int.tryParse(raw) ?? 0;

      ref.read(dispatchFormProvider.notifier).setAdditionalCost(value);
    });
  }

  @override
  void dispose() {
    downPaymentController.dispose();
    additionalCostController.dispose();
    super.dispose();
  }

  void _openAddItemSheet() async {
    ref.read(soSearchProvider.notifier).state = '';

    final result = await showModalBottomSheet<DispatchItemRequest>(
      context: context,
      isScrollControlled: false,
      backgroundColor: AppColors.greyBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddItemBottomSheet(),
    );

    if (result != null) {
      ref.read(dispatchFormProvider.notifier).addItem(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(dispatchFormProvider);
    final items = request.items ?? [];

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Pengiriman",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: StepInfoCard(
              title: "Informasi Pesanan Pengiriman",
              step: 2,
              totalStep: 3,
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _infoItem(items),

                if (items.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _paymentDetail(),
                ],
              ],
            ),
          ),

          const _NextButton(),
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
            "Tambahkan minimal satu item untuk melanjutkan proses Pengiriman",
            textAlign: TextAlign.center,
            style: AppTypography.smallNormalGrey,
          ),
        ],
      ),
    );
  }

  Widget _itemCard(DispatchItemRequest item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // ICON
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryShade,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset(
                      AppImages.icProduct,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.animalProfileName,
                        style: AppTypography.smallBoldBlack,
                      ),
                      Text(item.orderId, style: AppTypography.smallNormalGrey),
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
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          TwoColumnRowCard(
            leftValue: item.city,
            leftLabel: "Kota Tujuan",
            rightValue: item.dlvDate,
            rightLabel: "Tanggal Kirim",
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Biaya Kirim", style: AppTypography.smallNormalGrey),
                Text(
                  "Rp ${formatPrice(item.shippingCost as num)}",
                  style: AppTypography.mediumBoldPrimary,
                ),
              ],
            ),
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

  Widget _infoItem(List<DispatchItemRequest> items) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Informasi Hewan",
                style: AppTypography.mediumNormalBlack,
              ),
              _addButtonSmall(),
            ],
          ),
          const SizedBox(height: 12),

          if (items.isEmpty)
            _emptyState()
          else
            ListView.builder(
              itemCount: items.length,
              shrinkWrap: true, // 🔥 WAJIB
              physics: const NeverScrollableScrollPhysics(), // 🔥 WAJIB
              itemBuilder: (_, i) => _itemCard(items[i]),
            ),
        ],
      ),
    );
  }

  Widget _addButtonSmall() {
    return OutlinedButton.icon(
      onPressed: _openAddItemSheet,
      icon: Icon(Icons.add, size: 16, color: AppColors.white),
      label: Text("Tambah Hewan", style: AppTypography.xSmallNormalWhite),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  void _showDeleteConfirmSheet(DispatchItemRequest item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeleteConfirmBottomSheet(
        onDelete: () {
          ref.read(dispatchFormProvider.notifier).removeItem(item);

          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _paymentDetail() {
    final dispatch = ref.watch(dispatchFormProvider);

    return SectionCard(
      title: "Rincian Biaya",
      children: [
        TextFields(
          label: "Uang Muka Pengiriman (Opsional)",
          hint: "Masukkan uang muka",
          prefixIcon: AppImages.icMoneyTime,
          controller: downPaymentController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyInputFormatter(),
          ],
        ),
        TextFields(
          label: "Biaya Tambahan (Opsional)",
          hint: "Masukkan biaya tambahan",
          prefixIcon: AppImages.icMoneyTime,
          controller: additionalCostController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyInputFormatter(),
          ],
        ),
        SectionCard(
          children: [
            ProductHeaderCard(
              title: "Rp. ${formatPrice(dispatch.remainingPayment)}",
              subtitle: "Sisa pembayaran",
              image: AppImages.icMoneyTime,
            ),
          ],
        ),
      ],
    );
  }
}

class _NextButton extends ConsumerWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(dispatchFormProvider).items ?? [];
    final isEnabled = items.isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled
                  ? AppColors.primary
                  : AppColors.fieldBorder,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isEnabled
                ? () {
                    context.push("/dispatch/add/confirmation");
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
