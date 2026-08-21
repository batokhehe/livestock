class SalesInvoice {
  final int id;
  final String invoiceId;
  final int salesOrderId;
  final String invoiceDate;
  final String paymentStatus;
  final String? paymentType;
  final String? customerName;
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
  final int? setoranStatus;

  SalesInvoice({
    required this.id,
    required this.invoiceId,
    required this.salesOrderId,
    required this.invoiceDate,
    required this.paymentStatus,
    this.paymentType,
    this.customerName,
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
    this.setoranStatus,
  });

  factory SalesInvoice.fromJson(Map<String, dynamic> json) {
    return SalesInvoice(
      id: json['id'] ?? 0,
      invoiceId: json['invoice_id'] ?? '',
      salesOrderId: json['sales_order_id'] ?? 0,
      invoiceDate: json['invoice_date'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentType: json['payment_type']?.toString(),
      customerName: json['customer']?['name'],
      orderId: json['sales_order']?['order_id'],
      coaName: json['chart_of_account']?['name'],
      totalItem: (json['items'] as List?)?.length ?? 0,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0,
      discountTotal: double.tryParse(json['discount_total']?.toString() ?? '0') ?? 0,
      amountTotal: double.tryParse(json['amount_total']?.toString() ?? '0') ?? 0,
      amountPaid: double.tryParse(json['amount_paid']?.toString() ?? '0') ?? 0,
      amountTotalPaid: double.tryParse(json['amount_total_paid']?.toString() ?? '0') ?? 0,
      sisaTagihan: double.tryParse(json['sisa_tagihan']?.toString() ?? '0') ?? 0,
      notes: json['notes'],
      setoranStatus: json['setoran_status'] is bool
          ? (json['setoran_status'] as bool ? 1 : 0)
          : (json['setoran_status'] != null ? int.tryParse(json['setoran_status'].toString()) : null),
    );
  }
}
