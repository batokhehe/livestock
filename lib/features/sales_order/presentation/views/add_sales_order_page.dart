import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/customer_bottom_sheet.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_request_model.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/custom_date_picker_sheet.dart';
import '../../../../core/widgets/farm_location_bottom_sheet.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../sales_order_provider.dart';

class AddSalesOrderPage extends ConsumerStatefulWidget {
  final String? type;

  const AddSalesOrderPage({super.key, this.type});

  @override
  ConsumerState<AddSalesOrderPage> createState() => _AddSalesOrderPageState();
}

class _AddSalesOrderPageState extends ConsumerState<AddSalesOrderPage> {
  late TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(salesOrderFormProvider.notifier).setSalesItemType(widget.type);
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(salesOrderFormProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Penjualan",
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
                  title: "Informasi Pesanan Penjualan",
                  step: 1,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                _SalesOrderInfoSection(
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

class _SalesOrderInfoSection extends ConsumerWidget {
  final TextEditingController phoneController;
  final SalesOrderRequest form;

  const _SalesOrderInfoSection({
    required this.form,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (phoneController.text != (form.customer?.contactPhone ?? "")) {
      phoneController.text = form.customer?.contactPhone ?? "";
    }

    return SectionCard(
      title: "Informasi Penjualan",
      children: [
        SelectField(
          label: "Tanggal Penjualan",
          isMandatoryField: true,
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
                  .read(salesOrderFormProvider.notifier)
                  .setSalesOrderDate(pickedDate);
            }
          },
        ),
        if (form.salesItemType == 'animal') ...[
          SizedBox(height: 12),
          SelectField(
            label: "Tanggal Jatuh Tempo",
            isMandatoryField: true,
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
                ref
                    .read(salesOrderFormProvider.notifier)
                    .setDueDate(pickedDate);
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
              ref.read(salesOrderFormProvider.notifier).setCustomer(customer);
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
        if (form.salesItemType == 'animal') ...[
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppRadioGroup<String>(
                  title: 'Kategori penjualan',
                  value: form.category ?? "kg",
                  options: const ['kg', 'Kelas'],
                  labelBuilder: (v) => v,
                  onChanged: (v) =>
                      ref.read(salesOrderFormProvider.notifier).setCategory(v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppRadioGroup<bool>(
                  title: 'Gunakan Forecast',
                  value: form.useForecast ?? true,
                  options: const [true, false],
                  labelBuilder: (v) => v ? 'Ya' : 'Tidak',
                  onChanged: (v) => ref
                      .read(salesOrderFormProvider.notifier)
                      .setUseForecast(v),
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
                    .read(salesOrderFormProvider.notifier)
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
  final SalesOrderRequest form;

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
              ref.read(salesOrderFormProvider.notifier).setFarmLocation(result);
            }
          },
        ),
        if (form.salesItemType == 'animal') ...[
          SizedBox(height: 12),
          TextFields(
            label: "Nama penerima",
            hint: "Masukkan nama penerima",
            prefixIcon: AppImages.icUser,
            onChanged: (value) {
              ref.read(salesOrderFormProvider.notifier).setRecipientName(value);
            },
          ),
          SizedBox(height: 12),
          TextFields(
            label: "Nomor penerima",
            hint: "Masukkan nomor penerima",
            prefixIcon: AppImages.icCalling,
            onChanged: (value) {
              ref
                  .read(salesOrderFormProvider.notifier)
                  .setRecipientNumber(value);
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
    final form = ref.watch(salesOrderFormProvider);
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
                    context.push('/sales-order/add/step-2');
                  }
                : null,
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
