import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/info_item_card.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/step_info_card.dart';
import 'package:livestock/core/widgets/success_notification.dart';
import 'package:livestock/features/receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../transfer_provider.dart';

class AddTransferConfirmationPage extends ConsumerWidget {
  const AddTransferConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedTransferDateProvider);
    final animal = ref.watch(selectedTransferAnimalProvider);
    final toLocation = ref.watch(selectedTransferToLocationProvider);
    final toArea = ref.watch(selectedTransferToAreaProvider);
    final shippingCost = ref.watch(transferDeliveryCostProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Pemindahan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const StepInfoCard(
                  title: "Tinjau Pemindahan",
                  step: 3,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: "Informasi Pemindahan",
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.fieldBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatDateTime(selectedDate),
                                  style: AppTypography.smallBoldBlack.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Pemindahan Hewan",
                                  style: AppTypography.smallNormalGrey,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.fieldBorder,
                          ),
                          if (animal != null)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: ProductHeaderCard(
                                title: animal.animalCode,
                                subtitle:
                                    "${animal.name} • ${animal.weight.floor()} kg",
                                image: AppImages.icProduct,
                                status: animal.available,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: "Informasi Pengiriman",
                  children: [
                    CardWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Informasi Asal",
                            style: AppTypography.smallBoldBlack,
                          ),
                          const SizedBox(height: 4),
                          InfoItemCard(
                            icon: AppImages.icHome,
                            title: animal?.farmLocation?.name ?? "-",
                            subtitle: animal?.farmArea?.name ?? "-",
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Informasi Tujuan",
                            style: AppTypography.smallBoldBlack,
                          ),
                          const SizedBox(height: 4),
                          InfoItemCard(
                            icon: AppImages.icHome,
                            title: toLocation?.name ?? "-",
                            subtitle: toArea?.name ?? "-",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: "Rincian Biaya",
                  children: [
                    CardWrapper(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Biaya Pengiriman",
                            style: AppTypography.smallNormalBlack,
                          ),
                          Text(
                            shippingCost != null
                                ? "Rp ${formatPrice(shippingCost.toInt())}"
                                : "Rp 0",
                            style: AppTypography.mediumBoldPrimary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const _NextButton(),
        ],
      ),
    );
  }
}

class _NextButton extends ConsumerStatefulWidget {
  const _NextButton();

  @override
  ConsumerState<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends ConsumerState<_NextButton> {
  Future<void> _onConfirmTap() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ConfirmationBottomSheet(
        header: "Konfirmasi Pemindahan",
        title: "Simpan Pemindahan?",
        subTitle:
            "Pastikan data yang anda submit sudah sesuai, aksi ini tidak dapat dibatalkan atau diubah kembali.",
        saveText: "Simpan Pemindahan",
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final success = await ref.read(submitTransferProvider.notifier).submit();

    if (!mounted) return;

    if (success) {
      ref.read(submitTransferProvider.notifier).reset();
      ref.invalidate(paginatedTransferListProvider);
      context.go('/transfer');
      SuccessNotification.show(
        title: 'Data berhasil disimpan',
        subtitle: 'Pemindahan tercatat di sistem.',
      );
    } else {
      final err = ref.read(submitTransferProvider).error;
      SuccessNotification.showError(
        title: 'Gagal menyimpan Monitoring',
        subtitle: err?.toString() ?? 'Terjadi kesalahan, coba lagi.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(submitTransferProvider).isLoading;

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isLoading ? null : _onConfirmTap,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Text(
                    "Konfirmasi Pemindahan",
                    style: AppTypography.mediumBoldWhite,
                  ),
          ),
        ),
      ),
    );
  }
}
