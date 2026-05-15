import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/animal_group_bottom_sheet.dart';
import 'package:livestock/core/widgets/custom_date_picker_sheet.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/core/widgets/supplier_paginated_bottom_sheet.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_request_model.dart';
import 'package:livestock/features/purchase_order/purchase_order_provider.dart';

class EditPurchaseOrderInfoSection extends ConsumerWidget {
  final TextEditingController supplierNameController;
  final TextEditingController supplierAddressController;
  final PurchaseOrderRequest form;

  const EditPurchaseOrderInfoSection({
    super.key,
    required this.form,
    required this.supplierNameController,
    required this.supplierAddressController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (supplierNameController.text != (form.supplier?.name ?? "")) {
      supplierNameController.text = form.supplier?.name ?? "";
    }

    if (supplierAddressController.text != (form.supplierAddress ?? "")) {
      supplierAddressController.text = form.supplierAddress ?? "";
    }

    return SectionCard(
      title: "Informasi Pembelian",
      children: [
        SelectField(
          label: "Tanggal Pembelian",
          hint: formatDateTime(form.purchDate),
          icon: AppImages.icCalendarSearch,
          isMandatoryField: true,
          onTap: () async {
            final pickedDate = await showModalBottomSheet<DateTime?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) =>
                  const CustomDatePickerSheet(title: "Pilih Tanggal Pembelian"),
            );

            if (pickedDate != null) {
              ref
                  .read(purchaseOrderFormProvider.notifier)
                  .setPurchaseOrderDate(pickedDate);
            }
          },
        ),
        if (form.purchaseItemType == 'animal') ...[
          SelectField(
            label: "Grup Hewan",
            hint: form.animalGroup?.name ?? "Pilih Grup Hewan",
            icon: AppImages.icProduct,
            isMandatoryField: true,
            onTap: () async {
              final animalGroup = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const AnimalGroupBottomSheet(),
              );
              if (animalGroup != null) {
                ref
                    .read(purchaseOrderFormProvider.notifier)
                    .setAnimalGroup(animalGroup);
              }
            },
          ),
          const SizedBox(height: 12),
        ],
        SelectField(
          label: "Pemasok",
          hint: form.supplier?.name ?? "Pilih Pemasok",
          icon: AppImages.icUserTag,
          isMandatoryField: true,
          onTap: () async {
            final supplier = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) =>
                  SupplierPaginatedBottomSheet(type: form.purchaseItemType),
            );
            if (supplier != null) {
              ref
                  .read(purchaseOrderFormProvider.notifier)
                  .setSupplier(supplier);
            }
          },
        ),
        const SizedBox(height: 12),
        TextFields(
          label: "Nama Pemasok",
          hint: "Masukkan nama Pemasok",
          prefixIcon: AppImages.icUser,
          controller: supplierNameController,
          enabled: false,
        ),
        TextFieldWithInnerCounter(
          label: "Alamat Pemasok",
          subLabel: "",
          hint: "Masukkan lokasi pemasok",
          maxLength: 150,
          controller: supplierAddressController,
          onChanged: (value) {
            ref
                .read(purchaseOrderFormProvider.notifier)
                .setSupplierAddress(value);
          },
        ),
      ],
    );
  }
}
