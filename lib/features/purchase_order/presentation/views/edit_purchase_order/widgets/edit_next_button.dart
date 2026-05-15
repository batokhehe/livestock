import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_list_model.dart';
import 'package:livestock/features/purchase_order/purchase_order_provider.dart';

class EditNextButton extends ConsumerWidget {
  final PurchaseOrderList data;

  const EditNextButton({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(purchaseOrderFormProvider);
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
                    context.push('/purchase-order/edit/step-2', extra: data);
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
