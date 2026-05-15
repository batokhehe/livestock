import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_list_model.dart';

import '../../../../../core/theme/AppColors.dart';
import '../../../../../core/theme/AppTypography.dart';
import '../../../../../core/widgets/step_info_card.dart';
import '../../../data/model/purchase_order_request_model.dart';
import '../../../purchase_order_provider.dart';
import 'widgets/edit_customer_info_section.dart';
import 'widgets/edit_next_button.dart';
import 'widgets/edit_purchase_order_info_section.dart';

class EditPurchaseOrderPage extends ConsumerStatefulWidget {
  final PurchaseOrderList data;

  const EditPurchaseOrderPage({super.key, required this.data});

  @override
  ConsumerState<EditPurchaseOrderPage> createState() =>
      _EditPurchaseOrderPageState();
}

class _EditPurchaseOrderPageState extends ConsumerState<EditPurchaseOrderPage> {
  late TextEditingController nameController;
  late TextEditingController supplierAddressController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.data.supplierName ?? '',
    );
    supplierAddressController = TextEditingController(
      text: widget.data.supplierAddress ?? '',
    );

    Future.microtask(() {
      final notifier = ref.read(purchaseOrderFormProvider.notifier);

      // Determine type from data
      String? type;
      if (widget.data.animalGroup != null) {
        type = 'animal';
      } else if (widget.data.feedType != null) {
        type = 'feed';
      } else {
        type = 'equipment';
      }

      notifier.state = PurchaseOrderRequest(
        purchaseItemType: type,
        purchDate: widget.data.purchDate,
        animalGroup: widget.data.animalGroup,
        supplier: widget.data.supplier,
        supplierAddress: widget.data.supplierAddress,
        farmLocation: widget.data.farmLocation,
        shippingCost: widget.data.shippingCost,
        additionalCost: widget.data.additionalCost,
        // Items diisi di step 2
        items: widget.data.details
            .map((d) => d.toPurchaseOrderItemRequest())
            .toList(),
      );
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    supplierAddressController.dispose();
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
          "Edit Pembelian",
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
                EditPurchaseOrderInfoSection(
                  form: form,
                  supplierNameController: nameController,
                  supplierAddressController: supplierAddressController,
                ),
                if (form.purchaseItemType == 'animal') ...[
                  const SizedBox(height: 12),
                  EditCustomerInfoSection(form: form),
                ],
              ],
            ),
          ),
          EditNextButton(data: widget.data),
        ],
      ),
    );
  }
}
