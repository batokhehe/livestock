import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/widgets/text_field_disabled.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/info_item_card.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

import '../../../../app/providers.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../data/model/receiving_item_model.dart';
import '../widgets/confirmation_bottom_sheet.dart';
import '../widgets/receiving_detail_card.dart';
import '../widgets/upload_file_card.dart';

class AddReceivingConfirmationPage extends ConsumerWidget {
  const AddReceivingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(receivingFormProvider);
    final selectedItems = provider.selectedItems;

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Penerimaan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepInfoCard(
                  title: "Tinjau Penerimaan",
                  step: 3,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                _infoReceiving(ref),
                const SizedBox(height: 12),
                _infoItem(selectedItems),
                const SizedBox(height: 12),
                // const UploadFileCard(),
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
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedItems.isEmpty
                    ? null
                    : () async {
                        final result = await showModalBottomSheet<bool>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const ConfirmationBottomSheet(
                            header: "Konfirmasi Penerimaan",
                            title: "Lanjutkan Penerimaan Item?",
                            subTitle:
                                "Tindakan ini akan menandai penerimaan sebagai "
                                "dikonfirmasi dan tidak dapat dibatalkan",
                            saveText: "Simpan Penerimaan",
                          ),
                        );

                        if (result == true) {
                          try {
                            final provider = ref.read(receivingFormProvider);
                            final api = ref.read(receivingApiProvider);

                            // 🔥 ambil dari step 1
                            final farmLocation = ref.read(
                              selectedFarmLocationProvider,
                            );
                            final farmArea = ref.read(selectedFarmAreaProvider);
                            final receiveDate = ref.read(receivingDateProvider);
                            final type = ref.read(receivingTabProvider);
                            final isAnimal = type == ReceivingTab.animal;

                            // VALIDASI WAJIB
                            if (farmLocation == null || receiveDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Lengkapi informasi penerimaan",
                                  ),
                                ),
                              );
                              return;
                            }

                            if (isAnimal && farmArea == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Area peternakan wajib untuk hewan",
                                  ),
                                ),
                              );
                              return;
                            }

                            await provider.submitReceiving(
                              api: api,
                              type: type,
                              farmLocationId: farmLocation.id,
                              farmAreaId: isAnimal ? farmArea!.id : 0,
                              receiveDate: receiveDate,
                              remarks: provider.remarks,
                            );

                            provider.reset();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: const [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Penerimaan berhasil disimpan",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.green.shade600,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );

                            context.go('/receiving');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Gagal menyimpan: $e")),
                            );
                          }
                        }
                      },
                child: Text(
                  "Konfirmasi Penerimaan",
                  style: AppTypography.mediumBoldWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoReceiving(WidgetRef ref) {
    final receiveDate = ref.watch(receivingDateProvider);
    final farmLocation = ref.watch(selectedFarmLocationProvider);
    final farmArea = ref.watch(selectedFarmAreaProvider);
    final remarks = ref.watch(receivingFormProvider).remarks;

    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Penerimaan",
            style: AppTypography.mediumNormalBlack,
          ),
          const SizedBox(height: 12),
          InfoItemCard(
            label: 'Tanggal Penerimaan:',
            icon: AppImages.icCalendarNew,
            title: formatDateTime(receiveDate),
            subtitle: farmLocation?.name ?? '-',
          ),
          if (farmArea != null)
            InfoItemCard(
              label: 'Area Peternakan:',
              icon: AppImages.icMapSvg,
              title: farmArea.name,
              subtitle: 'Area Peternakan',
            ),
          if (remarks.isNotEmpty)
            InfoItemCard(
              label: 'Catatan:',
              icon: AppImages.icNote,
              title: remarks,
              subtitle: 'Catatan Penerimaan',
            ),
        ],
      ),
    );
  }

  Widget _infoItem(List<ReceivingItem> selectedItems) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Item", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),

          if (selectedItems.isEmpty)
            const Text(
              "Tidak ada item dipilih",
              style: AppTypography.smallNormalGrey,
            ),

          ...selectedItems.map((e) => ReceivingDetailCard(item: e)),
        ],
      ),
    );
  }
}
