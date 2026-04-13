import 'package:livestock/core/helpers/utils.dart';

import 'dispatch_item_request_model.dart';

class DispatchLine {
  final int id;
  final int animalId;
  final String animalCode;
  final String animalName;
  final String quantity;
  final String state;
  final String? stateId;
  final String city;
  final String? cityId;
  final String district;
  final String? districtId;
  final String village;
  final String? villageId;
  final String recipientName;
  final String recipientNumber;
  final String deliveryAddress;
  final String dlvDate;
  final String animalProfileName;
  final String salesOrderCode;
  final String shippingCost;
  final String shippingCostTotal;
  final int? salesOrderId;

  DispatchLine({
    required this.id,
    required this.animalId,
    required this.animalCode,
    required this.animalName,
    required this.quantity,
    required this.state,
    this.stateId,
    required this.city,
    this.cityId,
    required this.district,
    this.districtId,
    required this.village,
    this.villageId,
    required this.recipientName,
    required this.recipientNumber,
    required this.deliveryAddress,
    required this.dlvDate,
    required this.animalProfileName,
    required this.salesOrderCode,
    required this.shippingCost,
    required this.shippingCostTotal,
    this.salesOrderId,
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

      stateId: json['state_id']?.toString() ?? "0",
      cityId: json['city_id']?.toString() ?? "0",
      districtId: json['district_id']?.toString() ?? "0",
      villageId: json['village_id']?.toString() ?? "0",

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
      salesOrderId: json['sales_order_id'] ?? 0,
    );
  }
}

extension DispatchLineMapper on DispatchLine {
  DispatchItemRequest toRequest({int downPayment = 0, int additionalCost = 0}) {
    return DispatchItemRequest(
      animalProfileId: animalId,
      animalProfileCode: animalCode,
      animalProfileName: animalProfileName,
      qty: double.tryParse(quantity)?.toInt() ?? 0,
      dlvDate: dlvDate,
      deliveryAddress: deliveryAddress,
      state: state,
      stateId: stateId.toString(),
      city: city,
      cityId: cityId.toString(),
      district: district,
      districtId: districtId.toString(),
      village: village,
      villageId: villageId.toString(),
      recipientName: recipientName,
      recipientNumber: recipientNumber,
      shippingCost: parseToInt(shippingCost),
      orderId: salesOrderCode,
      downPayment: downPayment,
      additionalCost: additionalCost,
      totalShippingCost: int.tryParse(shippingCostTotal) ?? 0,
      salesOrderId: salesOrderId ?? 0,
      salesOrderDetailId: id,
    );
  }
}
