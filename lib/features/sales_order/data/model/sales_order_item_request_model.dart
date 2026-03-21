import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'package:livestock/core/data/model/feed_medicine_model.dart';

import '../../../../core/helpers/utils.dart';

class SalesOrderItemRequest {
  final AnimalProfile? animalProfile;
  final FeedMedicine? feedMedicine;
  final int? qty;
  final String? uom;
  final double? unitPrice;
  final double? subtotal;
  final double? discount;
  final DateTime? dlvDate;
  final double? weight;
  final double? shippingCost;
  final double? forecastWeight;

  final String? stateId;
  final String? state;
  final String? cityId;
  final String? city;
  final String? districtId;
  final String? district;
  final String? villageId;
  final String? village;
  final String? deliveryAddress;
  final String? isForecast;

  SalesOrderItemRequest({
    this.animalProfile,
    this.feedMedicine,
    this.qty,
    this.uom,
    this.unitPrice,
    this.subtotal,
    this.discount,
    this.dlvDate,
    this.weight,
    this.shippingCost,
    this.forecastWeight,
    this.stateId,
    this.state,
    this.cityId,
    this.city,
    this.districtId,
    this.district,
    this.villageId,
    this.village,
    this.deliveryAddress,
    this.isForecast,
  });

  factory SalesOrderItemRequest.fromJson(Map<String, dynamic> json) {
    return SalesOrderItemRequest(
      animalProfile: json['animal_profile'],
      feedMedicine: json['feed_medicine'],
      qty: json['qty'],
      uom: json['uom'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      dlvDate: json['dlv_date'],
      weight: (json['weight'] as num).toDouble(),
      shippingCost: (json['shipping_cost'] as num).toDouble(),
      forecastWeight: (json['forecast_weight'] as num?)?.toDouble(),
      stateId: json['state_id'],
      state: json['state'],
      cityId: json['city_id'],
      city: json['city'],
      districtId: json['district_id'],
      district: json['district'],
      villageId: json['village_id'],
      village: json['village'],
      deliveryAddress: json['delivery_address'],
      isForecast: json['is_forecast'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "animal_profile_id": animalProfile?.id,
      "feed_medicine_id": feedMedicine?.id,
      "qty": qty,
      "uom": uom,
      "unit_price": unitPrice,
      "subtotal": subtotal,
      "discount": discount,
      if (dlvDate != null) "dlv_date": formatterJson.format(dlvDate!),
      "weight": weight,
      "shipping_cost": shippingCost,
      "forecast_weight": forecastWeight,
      "state_id": stateId,
      "state": state,
      "city_id": cityId,
      "city": city,
      "district_id": districtId,
      "district": district,
      "village_id": villageId,
      "village": village,
      "delivery_address": deliveryAddress,
      "is_forecast": isForecast,
    };
  }
}
