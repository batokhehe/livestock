class SalesInvoice {
  final int id;
  final String invoiceId;
  final int salesOrderId;
  final String invoiceDate;
  final String paymentStatus;
  final String? paymentType;
  final double subtotal;
  final double discountTotal;
  final double amountTotal;
  final double amountPaid;
  final double amountTotalPaid;
  final double sisaTagihan;
  final String? notes;

  SalesInvoice({
    required this.id,
    required this.invoiceId,
    required this.salesOrderId,
    required this.invoiceDate,
    required this.paymentStatus,
    this.paymentType,
    required this.subtotal,
    required this.discountTotal,
    required this.amountTotal,
    required this.amountPaid,
    required this.amountTotalPaid,
    required this.sisaTagihan,
    this.notes,
  });

  factory SalesInvoice.fromJson(Map<String, dynamic> json) {
    return SalesInvoice(
      id: json['id'] ?? 0,
      invoiceId: json['invoice_id'] ?? '',
      salesOrderId: json['sales_order_id'] ?? 0,
      invoiceDate: json['invoice_date'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentType: json['payment_type']?.toString(),
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0,
      discountTotal: double.tryParse(json['discount_total']?.toString() ?? '0') ?? 0,
      amountTotal: double.tryParse(json['amount_total']?.toString() ?? '0') ?? 0,
      amountPaid: double.tryParse(json['amount_paid']?.toString() ?? '0') ?? 0,
      amountTotalPaid: double.tryParse(json['amount_total_paid']?.toString() ?? '0') ?? 0,
      sisaTagihan: double.tryParse(json['sisa_tagihan']?.toString() ?? '0') ?? 0,
      notes: json['notes'],
    );
  }
}
