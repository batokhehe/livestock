class DashboardSalesModel {
  final int salesOrderDraft;
  final int salesOrderConfirmed;
  final int salesOrderClosed;
  final int salesOrderCanceled;
  final int salesInvoiceDownPayment;
  final int salesInvoicePartial;
  final int salesInvoiceFullPayment;

  DashboardSalesModel({
    required this.salesOrderDraft,
    required this.salesOrderConfirmed,
    required this.salesOrderClosed,
    required this.salesOrderCanceled,
    required this.salesInvoiceDownPayment,
    required this.salesInvoicePartial,
    required this.salesInvoiceFullPayment,
  });

  factory DashboardSalesModel.fromJson(Map<String, dynamic> json) {
    return DashboardSalesModel(
      salesOrderDraft: json['salesOrderDraft'] ?? 0,
      salesOrderConfirmed: json['salesOrderConfirmed'] ?? 0,
      salesOrderClosed: json['salesOrderClosed'] ?? 0,
      salesOrderCanceled: json['salesOrderCanceled'] ?? 0,
      salesInvoiceDownPayment: json['salesInvoiceDownPayment'] ?? 0,
      salesInvoicePartial: json['salesInvoicePartial'] ?? 0,
      salesInvoiceFullPayment: json['salesInvoiceFullPayment'] ?? 0,
    );
  }
}
