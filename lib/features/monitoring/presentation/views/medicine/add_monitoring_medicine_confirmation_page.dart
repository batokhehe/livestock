import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/status_chips.dart';
import 'package:livestock/features/monitoring/presentation/widgets/confirmation_item_double_card.dart';

import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/step_info_card.dart';
import 'package:livestock/features/receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import '../../../monitoring_provider.dart';

class AddMonitoringMedicineConfirmationPage extends StatelessWidget {
  const AddMonitoringMedicineConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Pemantauan",
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
                const StepInfoCard(title: "Tinjau Pemantauan", step: 3, totalStep: 3),
                const SizedBox(height: 12),
                const _MonitoringInfoSection(),
                const SizedBox(height: 12),
                const _FarmInfoSection(),
                const SizedBox(height: 12),
                CardWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Informasi Item",
                        style: AppTypography.mediumNormalBlack,
                      ),
                      const SizedBox(height: 12),
                      _itemCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const _NextButton(),
        ],
      ),
    );
  }

  Widget _itemCard() {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Rumput Sinnoh", style: AppTypography.smallBoldBlack),
                  Text("FD00001", style: AppTypography.smallNormalGrey),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  StatusChips(text: "400 Stock", color: AppColors.success),
                  Text("Karung", style: AppTypography.smallNormalGrey),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("100", style: AppTypography.smallBoldBlack),
                  Text("Kuantitas", style: AppTypography.smallNormalGrey),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text("33 ember", style: AppTypography.smallBoldBlack),
                  Text("Rasio Kuantitas", style: AppTypography.smallNormalGrey),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Catatan", style: AppTypography.xSmallNormalGrey),
              Text("Kasih Makan", style: AppTypography.smallBoldBlack),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonitoringInfoSection extends StatelessWidget {
  const _MonitoringInfoSection();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Informasi Pemantauan",
      children: [ConfirmationItemDoubleCard(item: dummyItem)],
    );
  }
}

class _FarmInfoSection extends StatelessWidget {
  const _FarmInfoSection();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Informasi Peternakan",
      children: [
        CardWrapper(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Sapi Agri Bandung", style: AppTypography.smallBoldBlack),
              Text("Area 3", style: AppTypography.smallBoldRed),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const CardWrapper(
          child: Column(
            children: [
              ProductHeaderCard(
                title: "3 Hewan",
                subtitle: "Hewan Tersedia",
                image: AppImages.icProduct,
              ),
              SizedBox(height: 8),
              Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "satuan per hewan",
                    style: AppTypography.smallNormalBlack,
                  ),
                  Text("30 Hewan", style: AppTypography.smallBoldBlack),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

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
                  header: "Konfirmasi Pemantauan",
                  title: "Simpan Pemantauan?",
                  subTitle:
                      "Data Pemantauan Obat akan disimpan dan diterapkan ke seluruh hewan di area ini.",
                  saveText: "Simpan Pemantauan",
                ),
              );
            },
            child: const Text(
              "Konfirmasi Pemantauan",
              style: AppTypography.mediumBoldWhite,
            ),
          ),
        ),
      ),
    );
  }
}
