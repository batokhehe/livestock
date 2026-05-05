import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/features/dispatch/data/model/dispatch_list_model.dart';
import 'package:livestock/features/dispatch/data/model/dispatch_request_model.dart';
import 'package:livestock/features/dispatch/presentation/widgets/dispatch_item_double_card.dart';
import '../../../../core/widgets/success_notification.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/info_item_card.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../../core/widgets/product_header_card.dart';
import '../../../../core/widgets/two_column_row_card.dart';
import '../../../receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../data/model/dispatch_item_request_model.dart';
import '../../dispatch_provider.dart';
import '../widgets/add_item_bottom_sheet.dart';

class DispatchEditPage extends ConsumerStatefulWidget {
  final int id;

  const DispatchEditPage({super.key, required this.id});

  @override
  ConsumerState<DispatchEditPage> createState() => _DispatchEditPageState();
}

class _DispatchEditPageState extends ConsumerState<DispatchEditPage> {
  bool isInit = false;
  late TextEditingController downPaymentController;
  late TextEditingController additionalCostController;

  @override
  void initState() {
    super.initState();

    downPaymentController = TextEditingController();
    additionalCostController = TextEditingController();

    downPaymentController.addListener(() {
      final raw = downPaymentController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final value = int.tryParse(raw) ?? 0;

      ref.read(dispatchFormProvider.notifier).setDownPayment(value);
    });

    additionalCostController.addListener(() {
      final raw = additionalCostController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      final value = int.tryParse(raw) ?? 0;

      ref.read(dispatchFormProvider.notifier).setAdditionalCost(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(dispatchDetailProvider(widget.id));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Ubah Pengiriman",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: detailAsync.when(
        data: (detail) {
          if (!isInit) {
            Future.microtask(() {
              ref.read(dispatchFormProvider.notifier).setFromDetail(detail);
              downPaymentController.text = formatPrice(
                parseToInt(detail.downPayment),
              );

              additionalCostController.text = formatPrice(
                parseToInt(detail.additionalCost),
              );
            });
            isInit = true;
          }

          return _body(context, detail);
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text("Error: $e"),
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, _) {
          final request = ref.watch(dispatchFormProvider);
          final items = request.items ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: items.isEmpty
                    ? null
                    : () async {
                        final result = await showModalBottomSheet<bool>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const ConfirmationBottomSheet(
                            header: "Konfirmasi Perubahan",
                            title: "Yakin Merubah Pengiriman?",
                            subTitle:
                                "Data pengiriman hewan akan diperbarui di sistem.",
                            saveText: "Simpan",
                          ),
                        );

                        if (result == true) {
                          try {
                            await ref
                                .read(dispatchFormProvider.notifier)
                                .updateDispatch(widget.id);

                            ref.invalidate(dispatchListProvider);
                            ref.read(dispatchFormProvider.notifier).reset();

                            SuccessNotification.show(
                              title: "Pengiriman Berhasil",
                              subtitle: "Perubahan data pengiriman berhasil disimpan",
                            );

                            context.go('/dispatch');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Gagal menyimpan: $e")),
                            );
                          }
                        }
                      },
                child: Text(
                  "Simpan Perubahan",
                  style: AppTypography.mediumBoldWhite,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, DispatchList detail) {
    final request = ref.watch(dispatchFormProvider);
    final items = request.items ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoDispatch(detail, request),
          const SizedBox(height: 12),
          _infoItem(items, detail.dispatchStatus.toString()),
          // 🔥 dari provider
          const SizedBox(height: 12),
          _summaryCard(
            totalItem: items.length,
            deliveryFee: request.totalShipping.toDouble(),
            downPayment: (request.downPayment ?? 0).toDouble(),
            additionalFee: (request.additionalCost ?? 0).toDouble(),
            total: request.remainingPayment.toDouble(),
            status: detail.dispatchStatus.toString(),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(List<DispatchItemRequest> items, String status) {
    final isReady = status.toLowerCase() == "ready";
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
              if (isReady) _addButtonSmall(),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) => _itemCard(items[i], isReady),
          ),
        ],
      ),
    );
  }

  Widget _itemCard(DispatchItemRequest item, bool isReady) {
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
                if (isReady)
                  _iconAction(
                    icon: Icons.delete,
                    color: AppColors.danger,
                    backColor: AppColors.danger.withOpacity(0.08),
                    onTap: () => _showDeleteConfirmSheet(item),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
            child: TwoColumnRowCard(
              leftValue: item.city,
              leftLabel: "Kota Tujuan",
              rightValue: item.dlvDate,
              rightLabel: "Tanggal Kirim",
            ),
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

  Widget _infoDispatch(DispatchList detail, DispatchRequest request) {
    final tab = DispatchTabParser.fromApi(request.dispatchStatus);
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Pengiriman"),
          const SizedBox(height: 12),
          DispatchItemDoubleCard(item: detail),
          InfoItemCard(
            title: formatDateString(detail.dispatchDate),
            subtitle: "Tanggal Pengiriman",
          ),
          const SizedBox(height: 12),
          TextFields(
            label: "Nomor Mobil",
            hint: detail.vehicleNumber,
            prefixIcon: AppImages.icCar,
            enabled: false,
          ),
          TextFields(
            label: "Nama Supir",
            hint: detail.driverName,
            prefixIcon: AppImages.icUser,
            enabled: false,
          ),
          Dropdowns(
            label: "Status Pengiriman",
            value: tab.label,
            onTap: () => showStatusBottomSheet(context),
          ),
        ],
      ),
    );
  }

  void showStatusBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status Pengiriman',
                    style: AppTypography.largeBoldBlack,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.iconColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.close_rounded, size: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              _TypeItem(
                title: 'Sedang Dikirim',
                onTap: () {
                  ref
                      .read(dispatchFormProvider.notifier)
                      .setStatus("in_transit");
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _TypeItem(
                title: 'Selesai Dikirim',
                onTap: () {
                  ref
                      .read(dispatchFormProvider.notifier)
                      .setStatus("delivered");
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _TypeItem(
                title: 'Dibatalkan',
                onTap: () {
                  ref
                      .read(dispatchFormProvider.notifier)
                      .setStatus("cancelled");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// =========================
  /// SUMMARY CARD
  /// =========================

  Widget _summaryCard({
    required int totalItem,
    required double deliveryFee,
    required double downPayment,
    required double additionalFee,
    required double total,
    required String status,
  }) {
    final isReady = status.toLowerCase() == "ready";

    return SectionCard(
      title: "Rincian Bayar",
      children: [
        if (isReady)
          SectionCard(
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
                    title: "Rp ${formatPrice(total)}",
                    subtitle: "Sisa pembayaran",
                    image: AppImages.icMoneyTime,
                  ),
                ],
              ),
            ],
          ),

        /// 🔥 selain READY → tampilkan SUMMARY (bawah)
        if (!isReady)
          SectionCard(
            children: [
              _rowSummary("Jumlah Item", totalItem.toString()),
              _rowSummary("Total Biaya Kirim", formatPrice(deliveryFee)),
              _rowSummary("Uang Muka Pengiriman", formatPrice(downPayment)),
              _rowSummary("Biaya Tambahan", formatPrice(additionalFee)),
              _rowSummary(
                "Total Sisa Pembayaran",
                formatPrice(total),
                isBold: true,
              ),
            ],
          ),
      ],
    );
  }

  Widget _rowSummary(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isBold
                ? AppTypography.xSmallBoldBlack
                : AppTypography.xSmallNormalBlack,
          ),
          Text(
            value,
            style: isBold
                ? AppTypography.smallBoldPrimary
                : AppTypography.smallBoldBlack,
          ),
        ],
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

class _TypeItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _TypeItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: AppTypography.mediumBoldBlack.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
