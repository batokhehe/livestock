import 'package:livestock/core/helpers/utils.dart';

import 'dispatch_item_request_model.dart';

class DispatchLine {
  final int id;
  final int animalId;
  final String animalCode;
  final String animalName;
  final String quantity;
  final String state;
  final String city;
  final String district;
  final String village;
  final String recipientName;
  final String recipientNumber;
  final String deliveryAddress;
  final String dlvDate;
  final String animalProfileName;
  final String salesOrderCode;
  final String shippingCost;
  final String shippingCostTotal;

  DispatchLine({
    required this.id,
    required this.animalId,
    required this.animalCode,
    required this.animalName,
    required this.quantity,
    required this.state,
    required this.city,
    required this.district,
    required this.village,
    required this.recipientName,
    required this.recipientNumber,
    required this.deliveryAddress,
    required this.dlvDate,
    required this.animalProfileName,
    required this.salesOrderCode,
    required this.shippingCost,
    required this.shippingCostTotal,
  });

  factory DispatchLine.fromJson(Map<String, dynamic> json) {
    return DispatchLine(
      id: json['id'] ?? 0,

      /// beda key (list vs detail)
      animalId: (json['animal_id'] ?? json['animal_profile_id'] ?? 0),

      animalCode:
          (json['animal_code'] ?? json['animal_profile_id_code'])?.toString() ??
          '',

      animalName: (json['animal_name'] ?? json['item'])?.toString() ?? '',

      quantity: (json['quantity'] ?? json['qty'])?.toString() ?? '0',

      state: json['state']?.toString() ?? "",
      city: json['city']?.toString() ?? "",
      district: json['district']?.toString() ?? "",
      village: json['village']?.toString() ?? "",

      recipientName: json['recipient_name']?.toString() ?? "",
      recipientNumber: json['recipient_number']?.toString() ?? "",

      deliveryAddress: json['delivery_address']?.toString() ?? "",
      dlvDate: json['dlv_date']?.toString() ?? "",

      animalProfileName: json['animal_profile_name']?.toString() ?? "",

      /// beda key lagi
      salesOrderCode:
          (json['sales_order_code'] ?? json['sales_order_id_code'])
              ?.toString() ??
          '',

      shippingCost: json['shipping_cost']?.toString() ?? "0",
      shippingCostTotal: json['shipping_cost_total']?.toString() ?? "0",
    );
  }
}

extension DispatchLineMapper on DispatchLine {
  DispatchItemRequest toRequest({int downPayment = 0, int additionalCost = 0}) {
    print(shippingCost);
    return DispatchItemRequest(
      animalProfileId: animalId,
      animalProfileCode: animalCode,
      animalProfileName: animalProfileName,
      qty: int.tryParse(quantity) ?? 0,
      dlvDate: dlvDate,
      deliveryAddress: deliveryAddress,
      state: state,
      stateId: "",
      city: city,
      cityId: "",
      district: district,
      districtId: "",
      village: village,
      villageId: "",
      recipientName: recipientName,
      recipientNumber: recipientNumber,
      shippingCost: parseToInt(shippingCost),
      orderId: salesOrderCode,
      downPayment: downPayment,
      additionalCost: additionalCost,
      totalShippingCost: int.tryParse(shippingCostTotal) ?? 0,
      salesOrderId: 0,
      salesOrderDetailId: id,
    );
  }
}
