import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/features/sales_order/data/model/sales_invoice_request_model.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_detail_model.dart';
import 'package:livestock/features/sales_order/sales_order_provider.dart';
import 'package:livestock/core/data/model/payment_type_model.dart';
import 'package:livestock/core/data/model/chart_of_account_model.dart';
import 'package:livestock/core/data/model/bank_account_model.dart';
import 'dart:io';

final salesBankAccountListProvider =
    FutureProvider.autoDispose<List<BankAccount>>((ref) async {
      return ref.read(salesOrderApiProvider).getBankAccounts();
    });

final chartOfAccountListProvider =
    FutureProvider.autoDispose<List<ChartOfAccount>>((ref) async {
      return ref.read(salesOrderApiProvider).getChartOfAccounts();
    });

final salesInvoiceFormProvider =
    StateNotifierProvider.autoDispose<
      SalesInvoiceFormNotifier,
      SalesInvoiceRequest
    >((ref) {
      return SalesInvoiceFormNotifier(ref);
    });

class SalesInvoiceFormNotifier extends StateNotifier<SalesInvoiceRequest> {
  final Ref ref;

  SalesInvoiceFormNotifier(this.ref)
    : super(SalesInvoiceRequest(date: DateTime.now()));

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

  Future<void> submitInvoice(SalesOrderDetail orderDetail) async {
    final api = ref.read(salesOrderApiProvider);

    final payload = {
      "sales_order_id": orderDetail.id,
      "customer_id": orderDetail.customerId,
      "invoice_date": formatterJson.format(state.date ?? DateTime.now()),
      "payment_status": state.paymentStatus,
      "payment_type": state.paymentType?.name.toString(),
      "amount_paid": state.amount,
      "amount_total": orderDetail.amountTotal,
      "discount_total": orderDetail.discountTotal,
      "bank_account_id": state.bankAccount?.id,
      "chart_of_account_id": state.chartOfAccount?.id,
      "notes": state.notes ?? "",
      "setoran_status": state.setoranStatus ? 1 : 0,
      "items": orderDetail.items.map((item) {
        return {
          "sales_order_detail_id": item.id,
          "animal_profile_id": item.animalProfileId,
          "feed_medicine_id": item.feedMedicineId,
          "qty": item.qty,
          "unit_price": item.unitPrice,
          "subtotal": item.subtotal,
        };
      }).toList(),
    };

    if (state.imageFile != null) {
      // payload["attachment"] = await MultipartFile.fromFile(state.imageFile!.path);
    }

    try {
      await api.submitSalesInvoice(payload);
    } catch (e) {
      rethrow;
    }
  }
}
