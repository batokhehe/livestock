import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/customer_bottom_sheet.dart';
import 'package:livestock/core/widgets/input_field_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/custom_date_picker_sheet.dart';
import '../../../../core/widgets/farm_location_bottom_sheet.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../data/model/dispatch_request_model.dart';
import '../../dispatch_provider.dart';

class AddDispatchPage extends ConsumerStatefulWidget {
  final String? type;

  const AddDispatchPage({super.key, this.type});

  @override
  ConsumerState<AddDispatchPage> createState() => _AddDispatchPageState();
}

class _AddDispatchPageState extends ConsumerState<AddDispatchPage> {
  late TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(dispatchFormProvider.notifier).setDispatchItemType(widget.type);
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
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
                  phoneController: phoneController,
                ),
                const SizedBox(height: 12),
                _CustomerInfoSection(form: form),
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
  final TextEditingController phoneController;
  final DispatchRequest form;

  const _DispatchInfoSection({
    required this.form,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (phoneController.text != (form.customer?.contactPhone ?? "")) {
      phoneController.text = form.customer?.contactPhone ?? "";
    }

    return SectionCard(
      title: "Informasi Pengiriman",
      children: [
        SelectField(
          label: "Tanggal Pengiriman",
          hint: formatDateTime(form.orderDate),
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
        if (form.dispatchItemType == 'animal') ...[
          SizedBox(height: 12),
          SelectField(
            label: "Tanggal Pelunasan",
            hint: formatDateTime(form.dueDate),
            icon: AppImages.icCalendarSearch,
            onTap: () async {
              final pickedDate = await showModalBottomSheet<DateTime?>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const CustomDatePickerSheet(),
              );

              if (pickedDate != null) {
                ref.read(dispatchFormProvider.notifier).setDueDate(pickedDate);
              }
            },
          ),
        ],
        SizedBox(height: 12),
        SelectField(
          label: "Nama Pelanggan",
          hint: form.customer?.name ?? "Pilih Pelanggan",
          icon: AppImages.icUserTag,
          onTap: () async {
            final customer = await showModalBottomSheet(
              context: context,
              isScrollControlled: false,
              backgroundColor: AppColors.greyBg,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const CustomerBottomSheet(),
            );
            if (customer != null) {
              ref.read(dispatchFormProvider.notifier).setCustomer(customer);
            }
          },
        ),
        SizedBox(height: 12),
        TextFields(
          label: "Nomor Pelanggan",
          hint: "Masukkan nomor pelanggan",
          prefixIcon: AppImages.icCalling,
          controller: phoneController,
        ),
        if (form.dispatchItemType == 'animal') ...[
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppRadioGroup<String>(
                  title: 'Kategori Pengiriman',
                  value: form.category ?? "kg",
                  options: const ['kg', 'Kelas'],
                  labelBuilder: (v) => v,
                  onChanged: (v) =>
                      ref.read(dispatchFormProvider.notifier).setCategory(v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppRadioGroup<bool>(
                  title: 'Gunakan Forecast',
                  value: form.useForecast ?? true,
                  options: const [true, false],
                  labelBuilder: (v) => v ? 'Ya' : 'Tidak',
                  onChanged: (v) =>
                      ref.read(dispatchFormProvider.notifier).setUseForecast(v),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SelectField(
            label: "Tanggal Forecast",
            hint: formatDateTime(form.forecastDate),
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
                    .setForecastDate(pickedDate);
              }
            },
          ),
        ],
      ],
    );
  }
}

class _CustomerInfoSection extends ConsumerWidget {
  final DispatchRequest form;

  const _CustomerInfoSection({required this.form});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: "Informasi Pengiriman",
      children: [
        SelectField(
          label: "Lokasi peternakan",
          hint: form.farmLocation?.name ?? "Pilih lokasi",
          icon: AppImages.icHomeHashTag,
          onTap: () async {
            final result = await showModalBottomSheet<FarmLocation?>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const FarmLocationBottomSheet(),
            );

            if (result != null) {
              ref.read(dispatchFormProvider.notifier).setFarmLocation(result);
            }
          },
        ),
        if (form.dispatchItemType == 'animal') ...[
          SizedBox(height: 12),
          TextFields(
            label: "Nama penerima",
            hint: "Masukkan nama penerima",
            prefixIcon: AppImages.icUser,
            onChanged: (value) {
              ref.read(dispatchFormProvider.notifier).setRecipientName(value);
            },
          ),
          SizedBox(height: 12),
          TextFields(
            label: "Nomor penerima",
            hint: "Masukkan nomor penerima",
            prefixIcon: AppImages.icCalling,
            onChanged: (value) {
              ref.read(dispatchFormProvider.notifier).setRecipientNumber(value);
            },
          ),
        ],
      ],
    );
  }
}

class _NextButton extends ConsumerWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(dispatchFormProvider);
    final isValid = form.isValid;

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
                    context.push('/dispatch-order/add/step-2');
                  }
                : null,
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
