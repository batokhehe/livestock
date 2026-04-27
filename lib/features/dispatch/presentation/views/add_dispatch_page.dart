import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/input_field_card.dart';

import '../../../../core/data/model/farm_location_model.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/custom_date_picker_sheet.dart';
import '../../../../core/widgets/farm_location_paginated_bottom_sheet.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../data/model/dispatch_request_model.dart';
import '../../dispatch_provider.dart';

class AddDispatchPage extends ConsumerStatefulWidget {
  const AddDispatchPage({super.key});

  @override
  ConsumerState<AddDispatchPage> createState() => _AddDispatchPageState();
}

class _AddDispatchPageState extends ConsumerState<AddDispatchPage> {
  late TextEditingController driverController = TextEditingController();
  late TextEditingController vehicleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final form = ref.read(dispatchFormProvider);

    driverController.text = form.driverName ?? "";
    vehicleController.text = form.vehicleNumber ?? "";
  }

  @override
  void dispose() {
    driverController.dispose();
    vehicleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(dispatchFormProvider);

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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const StepInfoCard(
                  title: "Informasi Pesanan Pengiriman",
                  step: 1,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                _DispatchInfoSection(
                  form: form,
                  driverController: driverController,
                  vehicleController: vehicleController,
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

class _DispatchInfoSection extends ConsumerWidget {
  final TextEditingController driverController;
  final TextEditingController vehicleController;
  final DispatchRequest form;

  const _DispatchInfoSection({
    required this.form,
    required this.driverController,
    required this.vehicleController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: "Informasi Pengiriman",
      children: [
        SelectField(
          label: "Tanggal Pengiriman",
          hint: formatDateTime(form.dispatchDate),
          icon: AppImages.icCalendarSearch,
          onTap: () async {
            final pickedDate = await showModalBottomSheet<DateTime?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const CustomDatePickerSheet(),
            );

            if (pickedDate != null) {
              ref
                  .read(dispatchFormProvider.notifier)
                  .setDispatchDate(pickedDate);
            }
          },
        ),
        const SizedBox(height: 12),
        SelectField(
          label: "Lokasi peternakan",
          hint: form.farmLocation?.name ?? "Pilih lokasi",
          icon: AppImages.icHomeHashTag,
          onTap: () async {
            final result = await showModalBottomSheet<FarmLocation?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => FarmLocationPaginatedBottomSheet(
                initialSelectedId: form.farmLocation?.id,
              ),
            );

            if (result != null) {
              ref.read(dispatchFormProvider.notifier).setFarmLocation(result);
            }
          },
        ),
        const SizedBox(height: 12),
        TextFields(
          label: "Nomor Mobil",
          hint: "Masukkan nomor mobil",
          prefixIcon: AppImages.icCar,
          controller: vehicleController,
          onChanged: (val) {
            ref.read(dispatchFormProvider.notifier).setVehicle(val);
          },
        ),
        TextFields(
          label: "Nama Supir",
          hint: "Masukkan nama supir",
          prefixIcon: AppImages.icUser,
          controller: driverController,
          onChanged: (val) {
            ref.read(dispatchFormProvider.notifier).setDriver(val);
          },
        ),
      ],
    );
  }
}

class _NextButton extends ConsumerWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(dispatchFormProvider);
    final isValid =
        form.driverName?.isNotEmpty == true &&
        form.vehicleNumber?.isNotEmpty == true &&
        form.dispatchDate != null &&
        form.farmLocation != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isValid ? AppColors.primary : AppColors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isValid
                ? () {
                    context.push('/dispatch/add/step-2');
                  }
                : null,
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
