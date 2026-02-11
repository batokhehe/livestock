import '../../../../core/data/model/animal_profile_model.dart';

class SalesOrderItem {
  final int id;
  final int salesOrderId;
  final int? animalProfileId;

  final String salesStatus;
  final double qty;
  final double priceUnit;
  final double discount;
  final double priceSubtotal;
  final double priceTotal;

  final String? deliveryAddress;
  final String? dlvDate;

  final AnimalProfile? animalProfile;

  SalesOrderItem({
    required this.id,
    required this.salesOrderId,
    this.animalProfileId,
    required this.salesStatus,
    required this.qty,
    required this.priceUnit,
    required this.discount,
    required this.priceSubtotal,
    required this.priceTotal,
    this.deliveryAddress,
    this.dlvDate,
    this.animalProfile,
  });

  factory SalesOrderItem.fromJson(Map<String, dynamic> json) {
    return SalesOrderItem(
      id: json['id'],
      salesOrderId: json['sales_order_id'],
      animalProfileId: json['animal_profile_id'],
      salesStatus: json['sales_status'],
      qty: double.parse(json['qty'].toString()),
      priceUnit: double.parse(json['price_unit'].toString()),
      discount: double.parse(json['discount'].toString()),
      priceSubtotal: double.parse(json['price_subtotal'].toString()),
      priceTotal: double.parse(json['price_total'].toString()),
      deliveryAddress: json['delivery_address'],
      dlvDate: json['dlv_date'],
      animalProfile: json['animal_profile'] != null
          ? AnimalProfile.fromJson(json['animal_profile'])
          : null,
    );
  }
}
