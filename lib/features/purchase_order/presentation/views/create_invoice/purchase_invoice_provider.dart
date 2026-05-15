import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_invoice_request_model.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_list_model.dart';
import 'package:livestock/features/purchase_order/purchase_order_provider.dart';
import 'package:livestock/core/data/model/payment_type_model.dart';
import 'package:livestock/core/data/model/chart_of_account_model.dart';
import 'package:livestock/core/data/model/bank_account_model.dart';
import 'dart:io';

final purchasePaymentTypeListProvider =
    FutureProvider.autoDispose<List<PaymentType>>((ref) async {
      return ref.read(purchaseOrderApiProvider).getPaymentTypes();
    });

final purchaseChartOfAccountListProvider =
    FutureProvider.autoDispose<List<ChartOfAccount>>((ref) async {
      return ref.read(purchaseOrderApiProvider).getChartOfAccounts();
    });

final purchaseBankAccountListProvider =
    FutureProvider.autoDispose<List<BankAccount>>((ref) async {
      return ref.read(purchaseOrderApiProvider).getBankAccounts();
    });

final purchaseInvoiceFormProvider =
    StateNotifierProvider.autoDispose<
      PurchaseInvoiceFormNotifier,
      PurchaseInvoiceRequest
    >((ref) {
      return PurchaseInvoiceFormNotifier(ref);
    });

class PurchaseInvoiceFormNotifier
    extends StateNotifier<PurchaseInvoiceRequest> {
  final Ref ref;

  PurchaseInvoiceFormNotifier(this.ref)
    : super(PurchaseInvoiceRequest(date: DateTime.now()));

  void setDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void setPaymentStatus(String status, String label) {
    state = state.copyWith(paymentStatus: status, paymentStatusLabel: label);
  }

  void setBankAccount(BankAccount? account) {
    state = state.copyWith(bankAccount: account);
  }

  void setPaymentType(PaymentType type) {
    if (type.name != "Bank Transfer") {
      state = state.copyWith(paymentType: type, bankAccount: null);
    } else {
      state = state.copyWith(paymentType: type);
    }
  }

  void setChartOfAccount(ChartOfAccount account) {
    state = state.copyWith(chartOfAccount: account);
  }

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void setImageFile(File? file) {
    state = state.copyWith(imageFile: file);
  }

  void setSetoranStatus(bool status) {
    state = state.copyWith(setoranStatus: status);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  Future<void> submitInvoice(PurchaseOrderList orderDetail) async {
    state = state.copyWith(isLoading: true);
    final api = ref.read(purchaseOrderApiProvider);

    final payload = {
      "purch_orders_id": orderDetail.id,
      "supplier_id": orderDetail.supplier?.id,
      "invoice_date": formatterJson.format(state.date ?? DateTime.now()),
      "payment_status": state.paymentStatus,
      "payment_type": state.paymentType?.name.toString(),
      "amount_paid": state.amount,
      "amount_total": orderDetail.amountTotal,
      "discount_total": 0,
      "bank_account_id": state.bankAccount?.id,
      "chart_of_account_id": state.chartOfAccount?.id,
      "notes": state.notes ?? "",
      "setoran_status": state.setoranStatus ? 1 : 0,
      "items": orderDetail.details.map((item) {
        return {
          "purch_order_detail_id": item.id,
          "qty": item.quantity,
          "unit_price": item.purchPrice,
          "subtotal": item.purchPrice * (item.quantity > 0 ? item.quantity : 1),
        };
      }).toList(),
    };

    if (state.imageFile != null) {
      // payload["attachment"] = await MultipartFile.fromFile(state.imageFile!.path);
    }

    try {
      await api.submitPurchaseInvoice(payload);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}
