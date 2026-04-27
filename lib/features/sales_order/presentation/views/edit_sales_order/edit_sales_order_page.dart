import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_request_model.dart';

import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/custom_date_picker_sheet.dart';
import 'package:livestock/core/widgets/customer_paginated_bottom_sheet.dart';
import 'package:livestock/core/widgets/farm_location_paginated_bottom_sheet.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/select_field.dart';
import '../../../../../core/widgets/step_info_card.dart';
import '../../../data/model/sales_order_detail_model.dart';
import '../../../sales_order_provider.dart';

class EditSalesOrderPage extends ConsumerStatefulWidget {
  final SalesOrderDetail detail;

  const EditSalesOrderPage({super.key, required this.detail});

  @override
  ConsumerState<EditSalesOrderPage> createState() => _EditSalesOrderPageState();
}

class _EditSalesOrderPageState extends ConsumerState<EditSalesOrderPage> {
  late final TextEditingController _phoneController;
  late final TextEditingController _recipientNameController;
  late final TextEditingController _recipientNumberController;

  @override
  void initState() {
    super.initState();
    final d = widget.detail;

    _phoneController = TextEditingController(
      text: d.customer.contactPhone ?? '',
    );
    _recipientNameController = TextEditingController(text: d.recipientName);
    _recipientNumberController = TextEditingController(text: d.recipientNumber);

    Future.microtask(() {
      final notifier = ref.read(editSalesOrderFormProvider.notifier);
      notifier.initFromDetail(d);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _recipientNameController.dispose();
    _recipientNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(editSalesOrderFormProvider);
    print("hmmm ${form.toJson()}");

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Edit Penjualan",
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
                _buildSalesInfoSection(form),
                const SizedBox(height: 12),
                _buildShippingInfoSection(form),
              ],
            ),
          ),
          _buildNextButton(form),
        ],
      ),
    );
  }

  Widget _buildSalesInfoSection(SalesOrderRequest form) {
    return SectionCard(
      title: "Informasi Penjualan",
      children: [
        SelectField(
          label: "Tanggal Penjualan",
          isMandatoryField: true,
          hint: formatDateTime(form.orderDate),
          icon: AppImages.icCalendarSearch,
          onTap: () async {
            final picked = await showModalBottomSheet<DateTime?>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const CustomDatePickerSheet(),
            );
            if (picked != null) {
              ref
                  .read(editSalesOrderFormProvider.notifier)
                  .setSalesOrderDate(picked);
            }
          },
        ),
        if (form.salesItemType == 'animal') ...[
          const SizedBox(height: 12),
          SelectField(
            label: "Tanggal Jatuh Tempo",
            isMandatoryField: true,
            hint: formatDateTime(form.dueDate),
            icon: AppImages.icCalendarSearch,
            onTap: () async {
              final picked = await showModalBottomSheet<DateTime?>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const CustomDatePickerSheet(),
              );
              if (picked != null) {
                ref
                    .read(editSalesOrderFormProvider.notifier)
                    .setDueDate(picked);
              }
            },
          ),
        ],
        const SizedBox(height: 12),
        SelectField(
          label: "Nama Pelanggan",
          hint: form.customer?.name ?? "Pilih Pelanggan",
          icon: AppImages.icUserTag,
          isMandatoryField: true,
          onTap: () async {
            final customer = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const CustomerPaginatedBottomSheet(),
            );
            if (customer != null) {
              _phoneController.text = customer.contactPhone ?? '';
              _recipientNameController.text = customer.name;
              _recipientNumberController.text = customer.contactPhone ?? '';

              final notifier = ref.read(editSalesOrderFormProvider.notifier);
              notifier.setCustomer(customer);
              notifier.setRecipientName(customer.name);
              notifier.setRecipientNumber(customer.contactPhone ?? '');
            }
          },
        ),
        const SizedBox(height: 12),
        TextFields(
          label: "Nomor Pelanggan",
          hint: "Masukkan nomor pelanggan",
          isMandatoryField: true,
          prefixIcon: AppImages.icCalling,
          controller: _phoneController,
        ),
        if (form.salesItemType == 'animal') ...[
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppRadioGroup<String>(
                  title: 'Kategori penjualan',
                  value: form.category ?? "kg",
                  options: const ['kg', 'Kelas'],
                  labelBuilder: (v) => v,
                  onChanged: (v) => ref
                      .read(editSalesOrderFormProvider.notifier)
                      .setCategory(v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppRadioGroup<bool>(
                  title: 'Gunakan Forecast',
                  value: form.useForecast ?? true,
                  options: const [true, false],
                  labelBuilder: (v) => v ? 'Ya' : 'Tidak',
                  onChanged: (v) {
                    ref
                        .read(editSalesOrderFormProvider.notifier)
                        .setUseForecast(v);
                    if (!v) {
                      ref
                          .read(editSalesOrderFormProvider.notifier)
                          .clearForecastDate();
                    }
                  },
                ),
              ),
            ],
          ),
          if (form.useForecast ?? true) ...[
            const SizedBox(height: 12),
            SelectField(
              label: "Tanggal Forecast",
              isMandatoryField: true,
              hint: formatDateTime(form.forecastDate),
              icon: AppImages.icCalendarSearch,
              onTap: () async {
                final picked = await showModalBottomSheet<DateTime?>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const CustomDatePickerSheet(),
                );
                if (picked != null) {
                  ref
                      .read(editSalesOrderFormProvider.notifier)
                      .setForecastDate(picked);
                }
              },
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildShippingInfoSection(dynamic form) {
    return SectionCard(
      title: "Informasi Pengiriman",
      actionLabel: form.salesItemType == 'animal'
          ? "Salin Data Penerima"
          : null,
      onActionTap: form.salesItemType == 'animal' ? _copyFromCustomer : null,
      children: [
        SelectField(
          label: "Lokasi peternakan",
          isMandatoryField: true,
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
              ref
                  .read(editSalesOrderFormProvider.notifier)
                  .setFarmLocation(result);
            }
          },
        ),
        if (form.salesItemType == 'animal') ...[
          const SizedBox(height: 12),
          TextFields(
            label: "Nama penerima",
            hint: "Masukkan nama penerima",
            isMandatoryField: true,
            prefixIcon: AppImages.icUser,
            controller: _recipientNameController,
            onChanged: (value) {
              ref
                  .read(editSalesOrderFormProvider.notifier)
                  .setRecipientName(value);
            },
          ),
          const SizedBox(height: 12),
          TextFields(
            label: "Nomor penerima",
            hint: "Masukkan nomor penerima",
            isMandatoryField: true,
            prefixIcon: AppImages.icCalling,
            controller: _recipientNumberController,
            onChanged: (value) {
              ref
                  .read(editSalesOrderFormProvider.notifier)
                  .setRecipientNumber(value);
            },
          ),
        ],
      ],
    );
  }

  void _copyFromCustomer() {
    final form = ref.read(editSalesOrderFormProvider);
    final customer = form.customer;
    if (customer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum pilih nama pelanggan')),
      );
      return;
    }

    _recipientNameController.text = customer.name;
    _recipientNumberController.text = customer.contactPhone ?? '';

    ref
        .read(editSalesOrderFormProvider.notifier)
        .setRecipientName(customer.name);
    ref
        .read(editSalesOrderFormProvider.notifier)
        .setRecipientNumber(customer.contactPhone ?? '');
  }

  Widget _buildNextButton(dynamic form) {
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
                    context.push(
                      '/sales-order/edit/step-2',
                      extra: widget.detail,
                    );
                  }
                : null,
            child: const Text(
              "Selanjutnya",
              style: AppTypography.mediumBoldWhite,
            ),
          ),
        ),
      ),
    );
  }
}
