import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/custom_date_picker_sheet.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';

import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/select_field.dart';
import '../../../../../core/widgets/step_info_card.dart';
import '../../../../../core/helpers/utils.dart';

class AddMonitoringHealthPage extends StatelessWidget {
  const AddMonitoringHealthPage({super.key});

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
                StepInfoCard(title: "Pemeriksaan Kesehatan", step: 1, totalStep: 3),
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

class _MonitoringInfoSection extends ConsumerWidget {
  const _MonitoringInfoSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedHealthMonitoringDateProvider);
    return SectionCard(
      title: "Informasi Pemantauan",
      children: [
        SelectField(
          label: "Tanggal Pemantauan",
          hint: selectedDate != null
              ? formatDateTime(selectedDate)
              : "Pilih tanggal",
          style: selectedDate != null ? AppTypography.smallNormalBlack : null,
          icon: AppImages.icCalendarSearch,
          onTap: () async {
            final pickedDate = await showModalBottomSheet<DateTime?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) =>
                  const CustomDatePickerSheet(title: "Pilih Tanggal Pemantauan"),
            );
            if (pickedDate != null) {
              ref.read(selectedHealthMonitoringDateProvider.notifier).state =
                  pickedDate;
            }
          },
        ),
        const SizedBox(height: 12),
        const SelectField(
          label: "Karyawan",
          hint: "Pilih karyawan",
          icon: AppImages.icUserTag,
        ),
        const SizedBox(height: 12),
        const TextFieldWithInnerCounter(
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
              context.push('/monitoring/add/step-2?type=health');
            },
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
