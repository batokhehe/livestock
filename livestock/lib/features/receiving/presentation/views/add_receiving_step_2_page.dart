import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/features/receiving/presentation/widgets/poh_item_card.dart';
import 'package:livestock/features/receiving/presentation/widgets/receiving_detail_form_card.dart';
import 'package:livestock/core/widgets/step_info_card.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../receiving_provider.dart' as receiving;
import '../widgets/receiving_item_double_card.dart';
import '../widgets/upload_file_card.dart';

class AddReceivingStep2Page extends StatelessWidget {
  const AddReceivingStep2Page({super.key});

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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const StepInfoCard(
                  title: "Detail Penerimaan",
                  step: 2,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                PohItemCard(item: dummyItem),
                const SizedBox(height: 12),
                _infoItem(),
                const SizedBox(height: 12),
                UploadFileCard(onTap: () {}),
              ],
            ),
          ),
          _NextButtonStep2(),
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
          ...receiving.items.map(
            (e) => ReceivingDetailFormCard(item: e, selected: e.id == 0),
          ),
        ],
      ),
    );
  }
}

class _NextButtonStep2 extends StatelessWidget {
  const _NextButtonStep2();

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
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.push('/receiving/add/confirmation');
            },
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
