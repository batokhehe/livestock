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
    final selectedNotes = ref.watch(selectedTransferNotesProvider);
    final selectedAnimals = ref.watch(selectedTransferAnimalsProvider);
    final toLocation = ref.watch(selectedTransferToLocationProvider);
    final toArea = ref.watch(selectedTransferToAreaProvider);

    final firstAnimal =
        selectedAnimals.isNotEmpty ? selectedAnimals.first.animal : null;

    final double totalShippingCost = selectedAnimals.fold<double>(
      0,
      (sum, item) => sum + (item.shippingCost ?? 0),
    );

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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatDateTime(selectedDate),
                                      style: AppTypography.smallBoldBlack
                                          .copyWith(fontSize: 16),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryShade,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${selectedAnimals.length} Ekor",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Pemindahan Batch Hewan",
                                  style: AppTypography.smallNormalGrey,
                                ),
                                if (selectedNotes.trim().isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    "Catatan: $selectedNotes",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.fieldBorder,
                          ),
                          ...selectedAnimals.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final item = entry.value;
                            final animal = item.animal;

                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: idx < selectedAnimals.length - 1
                                    ? const Border(
                                        bottom: BorderSide(
                                          color: AppColors.fieldBorder,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductHeaderCard(
                                    title: animal.animalCode,
                                    subtitle:
                                        "${animal.name} • ${animal.weight.floor()} kg",
                                    image: AppImages.icProduct,
                                    status: animal.available,
                                  ),
                                  if ((item.shippingCost != null &&
                                          item.shippingCost! > 0) ||
                                      item.notes.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (item.shippingCost != null &&
                                            item.shippingCost! > 0)
                                          Text(
                                            "Biaya: Rp ${formatPrice(item.shippingCost!.toInt())}",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        if (item.notes.isNotEmpty)
                                          Expanded(
                                            child: Text(
                                              "Catatan: ${item.notes}",
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.grey,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }),
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
                            title: firstAnimal?.farmLocation?.name ?? "-",
                            subtitle: firstAnimal?.farmArea?.name ?? "-",
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
                            "Total Biaya Pengiriman",
                            style: AppTypography.smallNormalBlack,
                          ),
                          Text(
                            totalShippingCost > 0
                                ? "Rp ${formatPrice(totalShippingCost.toInt())}"
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
        subtitle: 'Pemindahan batch hewan tercatat di sistem.',
      );
    } else {
      final err = ref.read(submitTransferProvider).error;
      SuccessNotification.showError(
        title: 'Gagal menyimpan Pemindahan',
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
