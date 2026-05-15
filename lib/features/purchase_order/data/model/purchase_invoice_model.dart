class PurchaseInvoice {
  final int id;
  final String invoiceId;
  final int purchOrderId;
  final String invoiceDate;
  final String paymentStatus;
  final String? paymentType;
  final String? supplierName;
  final String? orderId;
  final String? coaName;
  final int totalItem;
  final double subtotal;
  final double discountTotal;
  final double amountTotal;
  final double amountPaid;
  final double amountTotalPaid;
  final double sisaTagihan;
  final String? notes;

  PurchaseInvoice({
    required this.id,
    required this.invoiceId,
    required this.purchOrderId,
    required this.invoiceDate,
    required this.paymentStatus,
    this.paymentType,
    this.supplierName,
    this.orderId,
    this.coaName,
    this.totalItem = 0,
    required this.subtotal,
    required this.discountTotal,
    required this.amountTotal,
    required this.amountPaid,
    required this.amountTotalPaid,
    required this.sisaTagihan,
    this.notes,
  });

  factory PurchaseInvoice.fromJson(Map<String, dynamic> json) {
    return PurchaseInvoice(
      id: json['id'] ?? 0,
      invoiceId: json['invoice_id'] ?? '',
      purchOrderId: json['purch_order_id'] ?? 0,
      invoiceDate: json['invoice_date'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentType: json['payment_type']?.toString(),
      supplierName: json['supplier']?['name'],
      orderId: json['purch_order']?['purch_order_no'],
      coaName: json['chart_of_account']?['name'],
      totalItem: (json['items'] as List?)?.length ?? 0,
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
