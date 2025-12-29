import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/widgets/text_field_disabled.dart';
import 'package:livestock/features/receiving/presentation/widgets/poh_item_card.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/card_wrapper.dart';
import '../../receiving_provider.dart' as receiving;
import '../widgets/confirmation_bottom_sheet.dart';
import '../widgets/receiving_detail_card.dart';
import '../widgets/receiving_item_double_card.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../widgets/upload_file_card.dart';

class AddReceivingConfirmationPage extends StatelessWidget {
  const AddReceivingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                _infoReceiving(),
                const SizedBox(height: 12),
                PohItemCard(item: dummyItem),
                const SizedBox(height: 12),
                _infoItem(),
                const SizedBox(height: 12),
                UploadFileCard(onTap: () {}),
              ],
            ),
          ),

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
                onPressed: () {
                  showModalBottomSheet(
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

  Widget _infoReceiving() {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Penerimaan",
            style: AppTypography.mediumNormalBlack,
          ),
          const SizedBox(height: 12),
          TextFieldDisabled(value: "14 Nov 2025"),
        ],
      ),
    );
  }

  Widget _infoItem() {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Item", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),
          ReceivingItemDoubleCard(item: dummyItem),
          ...receiving.items.map((e) => ReceivingDetailCard(item: e)),
        ],
      ),
    );
  }
}
