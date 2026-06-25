import 'purchase_order_item_model.dart';

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
  final List<PurchaseOrderDetail> details;

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
    this.details = const [],
  });

  factory PurchaseInvoice.fromJson(Map<String, dynamic> json) {
    final rawList =
        (json['details'] ??
                json['purch_order']?['details'] ??
                json['items'] ??
                json['purch_order']?['items'])
            as List? ??
        [];

    final detailsList = <PurchaseOrderDetail>[];
    for (final item in rawList) {
      if (item is Map) {
        final map = Map<String, dynamic>.from(item);
        final qty =
            int.tryParse(map['quantity']?.toString() ?? '') ??
            int.tryParse(map['qty']?.toString() ?? '') ??
            0;
        final price =
            double.tryParse(map['purch_price']?.toString() ?? '') ??
            double.tryParse(map['unit_price']?.toString() ?? '') ??
            0.0;
        final computedSubtotal = qty > 0 ? (price * qty) : price;
        final subtotal =
            double.tryParse(map['subtotal']?.toString() ?? '') ??
            computedSubtotal;

        detailsList.add(
          PurchaseOrderDetail(
            id: map['id'] as int? ?? 0,
            animalCode: map['animal_code']?.toString(),
            animalName: map['animal_name']?.toString(),
            feedMedicineCode: map['feed_medicine_code']?.toString(),
            feedMedicineName: map['feed_medicine_name']?.toString(),
            equipmentCode: map['equipment_code']?.toString(),
            equipmentName: map['equipment_name']?.toString(),
            quantity: qty,
            initialWeight:
                double.tryParse(map['initial_weight']?.toString() ?? '') ?? 0.0,
            purchPrice: price,
            subtotal: subtotal,
            total: double.tryParse(map['total']?.toString() ?? '') ?? subtotal,
          ),
        );
      }
    }

    final totalItem = detailsList.isNotEmpty
        ? detailsList.length
        : (json['total_item'] as int? ??
              json['purch_order']?['total_item'] as int? ??
              0);

    final subtotal = detailsList.isNotEmpty
        ? detailsList.fold<double>(0.0, (sum, item) => sum + item.subtotal)
        : (double.tryParse(
                json['subtotal']?.toString() ??
                    json['purch_order']?['subtotal']?.toString() ??
                    json['amount_purchased']?.toString() ??
                    json['purch_order']?['amount_purchased']?.toString() ??
                    '0',
              ) ??
              0.0);

    return PurchaseInvoice(
      id: json['id'] ?? 0,
      invoiceId: json['invoice_id'] ?? '',
      purchOrderId: json['purch_order_id'] ?? 0,
      invoiceDate: json['invoice_date'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentType: json['payment_type']?.toString(),
      supplierName:
          json['supplier']?['name'] ??
          json['purch_order']?['supplier']?['name'],
      orderId: json['purch_order']?['purch_order_no'],
      coaName: json['chart_of_account']?['name'],
      totalItem: totalItem,
      subtotal: subtotal,
      discountTotal:
          double.tryParse(
            json['discount_total']?.toString() ??
                json['purch_order']?['discount_total']?.toString() ??
                '0',
          ) ??
          0,
      amountTotal:
          double.tryParse(json['amount_total']?.toString() ?? '0') ?? 0,
      amountPaid: double.tryParse(json['amount_paid']?.toString() ?? '0') ?? 0,
      amountTotalPaid:
          double.tryParse(json['amount_total_paid']?.toString() ?? '0') ?? 0,
      sisaTagihan:
          double.tryParse(
            json['amount_remainder']?.toString() ??
                json['purch_order']?['amount_remainder']?.toString() ??
                json['sisa_tagihan']?.toString() ??
                '0',
          ) ??
          0,
      notes: json['notes'],
      details: detailsList,
    );
  }
}
