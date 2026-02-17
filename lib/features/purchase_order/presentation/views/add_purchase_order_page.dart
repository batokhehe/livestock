import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/animal_group_bottom_sheet.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/core/widgets/supplier_bottom_sheet.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/custom_date_picker_sheet.dart';
import '../../../../core/widgets/farm_location_bottom_sheet.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../data/model/purchase_order_request_model.dart';
import '../../purchase_order_provider.dart';

class AddPurchaseOrderPage extends ConsumerStatefulWidget {
  final String? type;

  const AddPurchaseOrderPage({super.key, this.type});

  @override
  ConsumerState<AddPurchaseOrderPage> createState() =>
      _AddPurchaseOrderPageState();
}

class _AddPurchaseOrderPageState extends ConsumerState<AddPurchaseOrderPage> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController supplierAddressController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(purchaseOrderFormProvider.notifier)
          .setPurchaseItemType(widget.type);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(purchaseOrderFormProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Pembelian",
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
                  title: "Informasi Pesanan Pembelian",
                  step: 1,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                _PurchaseOrderInfoSection(
                  form: form,
                  nameController: nameController,
                  supplierAddressController: supplierAddressController,
                ),
                if (form.purchaseItemType == 'animal') ...[
                  const SizedBox(height: 12),
                  _CustomerInfoSection(form: form),
                ],
              ],
            ),
          ),
          const _NextButton(),
        ],
      ),
    );
  }
}

class _PurchaseOrderInfoSection extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController supplierAddressController;
  final PurchaseOrderRequest form;

  const _PurchaseOrderInfoSection({
    required this.form,
    required this.nameController,
    required this.supplierAddressController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (nameController.text != (form.supplier?.name ?? "")) {
      nameController.text = form.supplier?.name ?? "";
    }

    return SectionCard(
      title: "Informasi Pembelian",
      children: [
        SelectField(
          label: "Tanggal Pembelian",
          hint: formatDateTime(form.purchDate),
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
                  .read(purchaseOrderFormProvider.notifier)
                  .setPurchaseOrderDate(pickedDate);
            }
          },
        ),
        SizedBox(height: 12),
        SelectField(
          label: "Grup Hewan",
          hint: form.animalGroup?.name ?? "Pilih Grup Hewan",
          icon: AppImages.icProduct,
          onTap: () async {
            final animalGroup = await showModalBottomSheet(
              context: context,
              isScrollControlled: false,
              backgroundColor: AppColors.greyBg,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const AnimalGroupBottomSheet(),
            );
            if (animalGroup != null) {
              ref
                  .read(purchaseOrderFormProvider.notifier)
                  .setAnimalGroup(animalGroup);
            }
          },
        ),
        SizedBox(height: 12),
        SelectField(
          label: "Nama Pemasok",
          hint: form.supplier?.name ?? "Pilih Pemasok",
          icon: AppImages.icUserTag,
          onTap: () async {
            final supplier = await showModalBottomSheet(
              context: context,
              isScrollControlled: false,
              backgroundColor: AppColors.greyBg,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const SupplierBottomSheet(),
            );
            if (supplier != null) {
              ref
                  .read(purchaseOrderFormProvider.notifier)
                  .setSupplier(supplier);
            }
          },
        ),
        SizedBox(height: 12),
        TextFields(
          label: "Nama Pemasok",
          hint: "Masukkan nama Pemasok",
          prefixIcon: AppImages.icUser,
          controller: nameController,
        ),
        TextFieldWithInnerCounter(
          label: "Alamat Pemasok",
          subLabel: "",
          hint: "Masukkan lokasi pemasok",
          maxLength: 150,
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

class _CustomerInfoSection extends ConsumerWidget {
  final PurchaseOrderRequest form;

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
              ref
                  .read(purchaseOrderFormProvider.notifier)
                  .setFarmLocation(result);
            }
          },
        ),
        if (form.purchaseItemType == 'animal') ...[
          SizedBox(height: 12),
          TextFields(
            label: "Biaya Pengiriman",
            hint: "Masukkan biaya",
            prefixIcon: AppImages.icMoneys,
            onChanged: (value) {
              ref
                  .read(purchaseOrderFormProvider.notifier)
                  .setShippingCost(value);
            },
          ),
          SizedBox(height: 12),
          TextFields(
            label: "Biaya Lainnya",
            hint: "Masukkan biaya lainnya",
            prefixIcon: AppImages.icMoneyTick,
            onChanged: (value) {
              ref
                  .read(purchaseOrderFormProvider.notifier)
                  .setAdditionalCost(value);
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
    final form = ref.watch(purchaseOrderFormProvider);
    final isValid = true; // form.isValid;

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
                    context.push('/purchase-order/add/step-2');
                  }
                : null,
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
