import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/farm_location_paginated_bottom_sheet.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_request_model.dart';
import 'package:livestock/features/purchase_order/purchase_order_provider.dart';

class EditCustomerInfoSection extends ConsumerStatefulWidget {
  final PurchaseOrderRequest form;

  const EditCustomerInfoSection({super.key, required this.form});

  @override
  ConsumerState<EditCustomerInfoSection> createState() =>
      _EditCustomerInfoSectionState();
}

class _EditCustomerInfoSectionState extends ConsumerState<EditCustomerInfoSection> {
  late TextEditingController shippingCtrl;
  late TextEditingController additionalCtrl;

  @override
  void initState() {
    super.initState();
    shippingCtrl = TextEditingController(
      text: widget.form.shippingCost != null && widget.form.shippingCost! > 0
          ? formatPrice(widget.form.shippingCost!)
          : '',
    );
    additionalCtrl = TextEditingController(
      text:
          widget.form.additionalCost != null && widget.form.additionalCost! > 0
          ? formatPrice(widget.form.additionalCost!)
          : '',
    );
  }

  @override
  void dispose() {
    shippingCtrl.dispose();
    additionalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(purchaseOrderFormProvider);

    return SectionCard(
      title: "Informasi Pengiriman",
      children: [
        SelectField(
          label: "Lokasi peternakan",
          hint: form.farmLocation?.name ?? "Pilih lokasi",
          icon: AppImages.icHomeHashTag,
          isMandatoryField: true,
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
                  .read(purchaseOrderFormProvider.notifier)
                  .setFarmLocation(result);
            }
          },
        ),
        if (form.purchaseItemType == 'animal') ...[
          const SizedBox(height: 12),
          TextFields(
            label: "Biaya Pengiriman",
            hint: "Masukkan biaya",
            prefixIcon: AppImages.icMoneys,
            prefixText: 'Rp ',
            keyboardType: TextInputType.number,
            controller: shippingCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyInputFormatter(),
            ],
            onChanged: (value) {
              ref
                  .read(purchaseOrderFormProvider.notifier)
                  .setShippingCost(value.replaceAll('.', ''));
            },
          ),
          const SizedBox(height: 12),
          TextFields(
            label: "Biaya Lainnya",
            hint: "Masukkan biaya lainnya",
            prefixIcon: AppImages.icMoneyTick,
            prefixText: 'Rp ',
            keyboardType: TextInputType.number,
            controller: additionalCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyInputFormatter(),
            ],
            onChanged: (value) {
              ref
                  .read(purchaseOrderFormProvider.notifier)
                  .setAdditionalCost(value.replaceAll('.', ''));
            },
          ),
        ],
      ],
    );
  }
}
