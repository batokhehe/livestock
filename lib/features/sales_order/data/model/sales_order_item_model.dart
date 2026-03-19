import '../../../../core/data/model/animal_profile_model.dart';

class SalesOrderItem {
  final int id;
  final int salesOrderId;
  final int? animalProfileId;

  final String feedMedicineCode;

  final String salesStatus;
  final double qty;
  final double priceUnit;
  final double discount;
  final double priceSubtotal;
  final double priceTotal;

  final int unitPrice;
  final int subTotal;

  final String? deliveryAddress;
  final String? dlvDate;

  final String? state;
  final String? city;
  final String? district;
  final String? village;

  final AnimalProfile? animalProfile;

  SalesOrderItem({
    required this.id,
    required this.salesOrderId,
    this.animalProfileId,
    required this.feedMedicineCode,
    required this.salesStatus,
    required this.qty,
    required this.priceUnit,
    required this.subTotal,
    required this.discount,
    required this.priceSubtotal,
    required this.priceTotal,
    required this.unitPrice,
    this.deliveryAddress,
    this.dlvDate,
    this.animalProfile,
    this.state,
    this.city,
    this.district,
    this.village,
  });

  factory SalesOrderItem.fromJson(Map<String, dynamic> json) {
    return SalesOrderItem(
      id: json['id'] ?? 0,

      salesOrderId: json['sales_order_id'] ?? 0,

      animalProfileId: json['animal_profile_id'],

      feedMedicineCode: json['feed_medicine_code'] ?? '-',

      salesStatus: json['sales_status'] ?? '',

      qty: double.parse((json['qty'] ?? 0).toString()),

      /// tidak ada di API → default
      priceUnit: double.parse((json['price_unit'] ?? 0).toString()),

      discount: double.parse((json['discount'] ?? 0).toString()),

      /// tidak ada di API → default
      priceSubtotal: double.parse((json['price_subtotal'] ?? 0).toString()),
      priceTotal: double.parse((json['price_total'] ?? 0).toString()),

      unitPrice: int.parse((json['unit_price'] ?? 0).toString()),
      subTotal: int.parse((json['subtotal'] ?? 0).toString()),

      deliveryAddress: json['delivery_address'],
      dlvDate: json['dlv_date'],

      state: json['state'],
      city: json['city'],
      district: json['district'],
      village: json['village'],

      animalProfile: json['animal_profile'] != null
          ? AnimalProfile.fromJson(json['animal_profile'])
          : null,
    );
  }
}
