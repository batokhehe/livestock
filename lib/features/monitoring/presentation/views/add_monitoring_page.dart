import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/step_info_card.dart';

class AddMonitoringPage extends StatelessWidget {
  const AddMonitoringPage({super.key});

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
              children: const [
                StepInfoCard(title: "Pemantauan Pakan", step: 1, totalStep: 3),
                SizedBox(height: 12),
                _MonitoringInfoSection(),
                SizedBox(height: 12),
                _FarmInfoSection(),
              ],
            ),
          ),
          const _NextButton(),
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
      children: [
        SelectField(
          label: "Tanggal Pemantauan",
          hint: "Pilih tanggal",
          icon: AppImages.icCalendarSearch,
        ),
        SizedBox(height: 12),
        SelectField(
          label: "Karyawan",
          hint: "Pilih karyawan",
          icon: AppImages.icUserTag,
        ),
        SizedBox(height: 12),
        TextFieldWithInnerCounter(
          label: "Catatan",
          subLabel: "(Optional)",
          hint: "Masukkan catatan",
          maxLength: 80,
        ),
      ],
    );
  }
}

class _FarmInfoSection extends StatelessWidget {
  const _FarmInfoSection();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Informasi Peternakan",
      children: const [
        SelectField(
          label: "Lokasi peternakan",
          hint: "Pilih lokasi",
          icon: AppImages.icHomeHashTag,
        ),
        SizedBox(height: 12),
        SelectField(
          label: "Area peternakan",
          hint: "Pilih area",
          icon: AppImages.icMap,
        ),
        SizedBox(height: 12),
        CardWrapper(
          child: ProductHeaderCard(
            title: "3 Hewan",
            subtitle: "Hewan Tersedia",
            image: AppImages.icProduct,
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
              context.push('/monitoring/add/step-2');
            },
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
