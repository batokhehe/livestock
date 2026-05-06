import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/section_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/info_item_card.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../../../core/widgets/success_notification.dart';
import '../../../../core/widgets/two_column_row_card.dart';
import '../../../receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../data/model/dispatch_item_request_model.dart';
import '../../data/model/dispatch_request_model.dart';
import '../../dispatch_provider.dart';

class AddDispatchConfirmationPage extends ConsumerWidget {
  const AddDispatchConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(dispatchFormProvider);
    final items = form.items ?? [];

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepInfoCard(
                  title: "Tinjau Rincian Pengiriman",
                  step: 3,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),

                _infoDispatch(form),
                const SizedBox(height: 12),

                _infoItem(form.items ?? []),
                const SizedBox(height: 12),

                _summaryCard(
                  totalItem: items.length,
                  deliveryFee: (form.shippingCostTotal ?? 0).toDouble(),
                  downPayment: (form.downPayment ?? 0).toDouble(),
                  additionalFee: (form.additionalCost ?? 0).toDouble(),
                  total: form.remainingPayment.toDouble(),
                ),
              ],
            ),
          ),

          /// BUTTON
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: items.isEmpty
                      ? AppColors.grey
                      : AppColors.primary,
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
                            header: "Konfirmasi Pengiriman",
                            title: "Lanjutkan Pengiriman Item?",
                            subTitle:
                                "Mohon pastikan semua item dan detail sudah sesuai sebelum melanjutkan transaksi",
                            saveText: "Simpan",
                          ),
                        );
                        if (result == true) {
                          try {
                            await ref
                                .read(dispatchFormProvider.notifier)
                                .submitDispatch();

                            ref.invalidate(dispatchListProvider);
                            ref.read(dispatchFormProvider.notifier).reset();

                            SuccessNotification.show(
                              title: "Pengiriman Berhasil",
                              subtitle: "Data pengiriman berhasil disimpan ke sistem",
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
                  "Selanjutnya",
                  style: AppTypography.mediumBoldWhite,
                ),
              ),
            ),
          ),
        ],
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
                "Informasi Item",
                style: AppTypography.mediumNormalBlack,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) => _itemCard(items[i]),
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
                // _iconAction(
                //   icon: Icons.delete,
                //   color: AppColors.danger,
                //   backColor: AppColors.danger.withOpacity(0.08),
                //   onTap: () => _showDeleteConfirmSheet(item),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

  /// =========================
  /// INFORMASI Pengiriman
  /// =========================

  Widget _infoDispatch(DispatchRequest form) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Pengiriman",
            style: AppTypography.smallNormalBlack,
          ),
          const SizedBox(height: 12),
          InfoItemCard(
            icon: AppImages.icCalendarTick,
            title: formatDateTime(form.dispatchDate),
            subtitle: "Tanggal Pengiriman",
          ),
          InfoItemCard(
            icon: AppImages.icCar,
            title: form.vehicleNumber ?? '-',
            subtitle: form.driverName ?? '-',
          ),
          InfoItemCard(
            icon: AppImages.icField,
            title: form.farmLocation?.name ?? '-',
            subtitle: "Lokasi Peternakan",
          ),
        ],
      ),
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
  }) {
    return SectionCard(
      title: 'Rincian Bayar',
      children: [
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
