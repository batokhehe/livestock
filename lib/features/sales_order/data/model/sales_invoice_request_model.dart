import 'dart:io';
import 'package:livestock/core/data/model/payment_type_model.dart';
import 'package:livestock/core/data/model/chart_of_account_model.dart';
import 'package:livestock/core/data/model/bank_account_model.dart';

class SalesInvoiceRequest {
  final DateTime? date;
  final String? paymentStatus;
  final String? paymentStatusLabel;
  final PaymentType? paymentType;
  final ChartOfAccount? chartOfAccount;
  final BankAccount? bankAccount;
  final double? amount;
  final File? imageFile;
  final bool setoranStatus;

  final String? notes;

  SalesInvoiceRequest({
    this.date,
    this.paymentStatus,
    this.paymentStatusLabel,
    this.paymentType,
    this.chartOfAccount,
    this.bankAccount,
    this.amount,
    this.imageFile,
    this.notes,
    this.setoranStatus = false,
  });

  SalesInvoiceRequest copyWith({
    DateTime? date,
    String? paymentStatus,
    String? paymentStatusLabel,
    PaymentType? paymentType,
    ChartOfAccount? chartOfAccount,
    BankAccount? bankAccount,
    double? amount,
    File? imageFile,
    String? notes,
    bool? setoranStatus,
  }) {
    return SalesInvoiceRequest(
      date: date ?? this.date,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentStatusLabel: paymentStatusLabel ?? this.paymentStatusLabel,
      paymentType: paymentType ?? this.paymentType,
      chartOfAccount: chartOfAccount ?? this.chartOfAccount,
      bankAccount: bankAccount ?? this.bankAccount,
      amount: amount ?? this.amount,
      imageFile: imageFile ?? this.imageFile,
      notes: notes ?? this.notes,
      setoranStatus: setoranStatus ?? this.setoranStatus,
    );
  }

  bool get isValid =>
      paymentStatus != null &&
      paymentType != null &&
      (paymentType?.name != "Bank Transfer" || bankAccount != null) &&
      chartOfAccount != null &&
      amount != null &&
      amount! > 0;
}
