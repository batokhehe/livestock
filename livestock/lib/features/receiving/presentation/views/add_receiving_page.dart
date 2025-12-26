import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';
import 'package:livestock/features/receiving/presentation/widgets/step_info_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../widgets/select_receiving_item_sheet.dart';

class AddReceivingPage extends StatelessWidget {
  const AddReceivingPage({super.key});

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
              children: const [
                StepInfoCard(
                  title: "Informasi Penerimaan",
                  step: 1,
                  totalStep: 3,
                ),
                SizedBox(height: 12),
                _ReceivingInfoSection(),
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

class _ReceivingInfoSection extends StatelessWidget {
  const _ReceivingInfoSection();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: "Informasi Penerimaan",
      children: const [
        _SelectField(
          label: "Tanggal penerimaan",
          hint: "Pilih tanggal",
          icon: AppImages.icCalendarSearch,
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
    return _SectionCard(
      title: "Informasi Peternakan",
      children: const [
        _SelectField(
          label: "Lokasi peternakan",
          hint: "Pilih lokasi",
          icon: AppImages.icHomeHashTag,
        ),
        SizedBox(height: 12),
        _SelectField(
          label: "Area peternakan",
          hint: "Pilih area",
          icon: AppImages.icMap,
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.smallNormalBlack),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  final String label;
  final String hint;
  final String icon;

  const _SelectField({
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.smallBoldBlack),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.fieldBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(icon, width: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(hint, style: AppTypography.hint),
                ],
              ),
              const Icon(Icons.chevron_right),
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
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => SelectReceivingItemSheet(),
              );
            },
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
