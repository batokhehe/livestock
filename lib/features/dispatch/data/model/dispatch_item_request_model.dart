class DispatchItemRequest {
  final int animalProfileId;
  final String animalProfileCode;
  final String animalProfileName;
  final int qty;
  final String dlvDate;
  final String deliveryAddress;
  final String state;
  final String stateId;
  final String city;
  final String cityId;
  final String district;
  final String districtId;
  final String village;
  final String villageId;
  final String recipientName;
  final String recipientNumber;
  final int shippingCost;
  final String orderId;
  final int downPayment;
  final int additionalCost;
  final int totalShippingCost;
  final int salesOrderId;
  final int salesOrderDetailId;
  final int amountRemainder;
  final int amountPaid;
  final int amountTotal;

  DispatchItemRequest({
    required this.animalProfileId,
    required this.animalProfileCode,
    required this.animalProfileName,
    required this.qty,
    required this.dlvDate,
    required this.deliveryAddress,
    required this.state,
    required this.stateId,
    required this.city,
    required this.cityId,
    required this.district,
    required this.districtId,
    required this.village,
    required this.villageId,
    required this.recipientName,
    required this.recipientNumber,
    required this.shippingCost,
    required this.orderId,
    required this.downPayment,
    required this.additionalCost,
    required this.totalShippingCost,
    required this.salesOrderId,
    required this.salesOrderDetailId,
    required this.amountRemainder,
    required this.amountPaid,
    required this.amountTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      "animal_profile_id": animalProfileId,
      "qty": qty,
      "dlv_date": dlvDate,
      "delivery_address": deliveryAddress,
      "state": state,
      "state_id": stateId,
      "city": city,
      "city_id": cityId,
      "district": district,
      "district_id": districtId,
      "village": village,
      "village_id": villageId,
      "recipient_name": recipientName,
      "recipient_number": recipientNumber,
      "down_payment": downPayment,
      "additional_cost": additionalCost,
      "shipping_cost": shippingCost,
      "total_shipping_cost": totalShippingCost,
      "sales_order_id": salesOrderId,
      "sales_order_detail_id": salesOrderDetailId,
      "amount_remainder": amountRemainder,
      "amount_paid": amountPaid,
      "amount_total": amountTotal,
    };
  }
}
