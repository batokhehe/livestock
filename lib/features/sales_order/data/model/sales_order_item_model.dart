import '../../../../core/data/model/animal_profile_model.dart';

class SalesOrderItem {
  final int id;
  final int salesOrderId;
  final int? animalProfileId;

  final String? animalCode;
  final String? animalProfileCode;
  final String? salesOrderIdCode;
  final int? no;
  final String item;
  final int? feedMedicineId;
  final String feedMedicineCode;

  final String salesStatus;
  final String? salesItemType;
  final double qty;
  final String? uom;
  final int? qtyRemainder;

  final double unitPrice;
  final double subtotal;
  final double discount;
  final double shippingCost;
  final double weight;

  final String? deliveryAddress;
  final String? dlvDate;

  final String? stateId;
  final String? state;
  final String? cityId;
  final String? city;
  final String? districtId;
  final String? district;
  final String? villageId;
  final String? village;

  final String? forecastDate;
  final double forecastWeight;
  final double forecastPrice;
  final String? priceClass;
  final String? isForecast;

  final double priceUnit;
  final double priceSubtotal;
  final double priceTotal;

  final AnimalProfile? animalProfile;

  SalesOrderItem({
    required this.id,
    required this.salesOrderId,
    this.animalProfileId,
    this.animalCode,
    this.animalProfileCode,
    this.salesOrderIdCode,
    this.no,
    required this.item,
    this.feedMedicineId,
    required this.feedMedicineCode,
    required this.salesStatus,
    this.salesItemType,
    required this.qty,
    this.uom,
    this.qtyRemainder,
    required this.unitPrice,
    required this.subtotal,
    required this.discount,
    required this.shippingCost,
    required this.weight,
    this.deliveryAddress,
    this.dlvDate,
    this.stateId,
    this.state,
    this.cityId,
    this.city,
    this.districtId,
    this.district,
    this.villageId,
    this.village,
    this.forecastDate,
    required this.forecastWeight,
    required this.forecastPrice,
    this.priceClass,
    this.isForecast,
    required this.priceUnit,
    required this.priceSubtotal,
    required this.priceTotal,
    this.animalProfile,
  });

  factory SalesOrderItem.fromJson(Map<String, dynamic> json) {
    return SalesOrderItem(
      id: json['id'] ?? 0,
      salesOrderId: json['sales_order_id'] ?? 0,
      animalProfileId: json['animal_profile_id'],
      animalCode: json['animal_code'],
      animalProfileCode: json['animal_profile_code'],
      salesOrderIdCode: json['sales_order_id_code'],
      no: json['no'],
      item: json['item'] ?? '',
      feedMedicineId: json['feed_medicine_id'],
      feedMedicineCode: json['feed_medicine_code'] ?? '-',
      salesStatus: json['sales_status'] ?? '',
      salesItemType: json['sales_item_type'],
      qty: double.tryParse((json['qty'] ?? 0).toString()) ?? 0,
      uom: json['uom'],
      qtyRemainder: json['qty_remainder'],
      unitPrice: double.tryParse((json['unit_price'] ?? 0).toString()) ?? 0,
      subtotal: double.tryParse((json['subtotal'] ?? 0).toString()) ?? 0,
      discount: double.tryParse((json['discount'] ?? 0).toString()) ?? 0,
      shippingCost: double.tryParse((json['shipping_cost'] ?? 0).toString()) ?? 0,
      weight: double.tryParse((json['weight'] ?? 0).toString()) ?? 0,
      deliveryAddress: json['delivery_address'],
      dlvDate: json['dlv_date'],
      stateId: json['state_id']?.toString(),
      state: json['state'],
      cityId: json['city_id']?.toString(),
      city: json['city'],
      districtId: json['district_id']?.toString(),
      district: json['district'],
      villageId: json['village_id']?.toString(),
      village: json['village'],
      forecastDate: json['forecast_date'],
      forecastWeight:
          double.tryParse((json['forecast_weight'] ?? 0).toString()) ?? 0,
      forecastPrice:
          double.tryParse((json['forecast_price'] ?? 0).toString()) ?? 0,
      priceClass: json['price_class'],
      isForecast: json['is_forecast']?.toString(),
      priceUnit: double.tryParse((json['price_unit'] ?? 0).toString()) ?? 0,
      priceSubtotal: double.tryParse((json['price_subtotal'] ?? 0).toString()) ?? 0,
      priceTotal: double.tryParse((json['price_total'] ?? 0).toString()) ?? 0,
      animalProfile: json['animal_profile'] != null
          ? AnimalProfile.fromJson(json['animal_profile'])
          : null,
    );
  }

  /// helper UI
  double get subTotal => subtotal;
}
