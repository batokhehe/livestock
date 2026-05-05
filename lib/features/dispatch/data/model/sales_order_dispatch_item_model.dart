class SalesOrderDispatchItem {
  final int id;
  final int salesOrderId;

  final String dlvDate;
  final String formattedDlvDate;

  final int salesOrderDetailId;
  final String salesOrderIdCode;

  final int no;

  final String item;
  final String itemName;
  final String itemCode;

  final int animalProfileId;
  final int animalGroupId;

  final String animalProfileIdCode;
  final String animalProfileName;

  final int qty;
  final int remainingQty;
  final int qtyInvoiced;

  final int unitPrice;
  final int amountRemainder;
  final int subtotal;

  final String stateId;
  final String state;

  final String cityId;
  final String city;

  final String districtId;
  final String district;

  final String villageId;
  final String village;

  final String deliveryAddress;

  final int shippingCost;
  final int amountPaid;
  final int amountTotal;

  SalesOrderDispatchItem({
    required this.id,
    required this.salesOrderId,
    required this.dlvDate,
    required this.formattedDlvDate,
    required this.salesOrderDetailId,
    required this.salesOrderIdCode,
    required this.no,
    required this.item,
    required this.itemName,
    required this.itemCode,
    required this.animalProfileId,
    required this.animalGroupId,
    required this.animalProfileIdCode,
    required this.animalProfileName,
    required this.qty,
    required this.remainingQty,
    required this.qtyInvoiced,
    required this.unitPrice,
    required this.amountRemainder,
    required this.subtotal,
    required this.stateId,
    required this.state,
    required this.cityId,
    required this.city,
    required this.districtId,
    required this.district,
    required this.villageId,
    required this.village,
    required this.deliveryAddress,
    required this.shippingCost,
    required this.amountPaid,
    required this.amountTotal,
  });

  factory SalesOrderDispatchItem.fromJson(Map<String, dynamic> json) {
    return SalesOrderDispatchItem(
      id: json['id'] ?? 0,
      salesOrderId: json['sales_order_id'] ?? 0,
      dlvDate: json['dlv_date'] ?? '',
      formattedDlvDate: json['formatted_dlv_date'] ?? '',
      salesOrderDetailId: json['sales_order_detail_id'] ?? 0,
      salesOrderIdCode: json['sales_order_id_code'] ?? '',
      no: json['no'] ?? 0,
      item: json['item'] ?? '',
      itemName: json['item_name'] ?? '',
      itemCode: json['item_code'] ?? '',
      animalProfileId: json['animal_profile_id'] ?? 0,
      animalGroupId: json['animal_group_id'] ?? 0,
      animalProfileIdCode: json['animal_profile_id_code'] ?? '',
      animalProfileName: json['animal_profile_name'] ?? '',
      qty: json['qty'] ?? 0,
      remainingQty: json['remaining_qty'] ?? 0,
      qtyInvoiced: json['qty_invoiced'] ?? 0,
      unitPrice: json['unit_price'] ?? 0,
      amountRemainder:
          double.tryParse(json['amount_remainder'].toString())?.toInt() ?? 0,
      subtotal: double.tryParse(json['subtotal'].toString())?.toInt() ?? 0,
      stateId: json['state_id'] ?? '',
      state: json['state'] ?? '',
      cityId: json['city_id'] ?? '',
      city: json['city'] ?? '',
      districtId: json['district_id'] ?? '',
      district: json['district'] ?? '',
      villageId: json['village_id'] ?? '',
      village: json['village'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      shippingCost: double.tryParse(json['shipping_cost'].toString())?.toInt() ?? 0,
      amountPaid: double.tryParse(json['amount_paid'].toString())?.toInt() ?? 0,
      amountTotal:
          double.tryParse(json['amount_total'].toString())?.toInt() ?? 0,
    );
  }
}
