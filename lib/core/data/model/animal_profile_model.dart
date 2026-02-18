import 'animal_group_model.dart';
import 'farm_area_model.dart';
import 'farm_location_model.dart';

class AnimalProfile {
  final int id;
  final String animalCode;
  final String name;
  final String salesOrderCustomerName;
  final String? poel;
  final String? notes;

  final AnimalGroup? animalGroup;
  final FarmLocation? farmLocation;
  final FarmArea? farmArea;

  final String gender;
  final String status;
  final String available;

  final int age;
  final double weight;

  final double purchPrice;
  final double salesPrice;
  final double refSalesPrice;
  final double refSalesPriceTotal;

  final String? currentClassName;
  final double currentClassPrice;

  final String? dispatchStatus;
  final String? vehicleNumber;
  final String? settlementStatus;

  AnimalProfile({
    required this.id,
    required this.animalCode,
    required this.name,
    required this.salesOrderCustomerName,
    this.notes,
    this.poel,
    this.animalGroup,
    this.farmLocation,
    this.farmArea,
    required this.gender,
    required this.status,
    required this.available,
    required this.age,
    required this.weight,
    required this.purchPrice,
    required this.salesPrice,
    required this.refSalesPrice,
    required this.refSalesPriceTotal,
    this.currentClassName,
    required this.currentClassPrice,
    this.dispatchStatus,
    this.vehicleNumber,
    this.settlementStatus,
  });

  factory AnimalProfile.fromJson(Map<String, dynamic> json) {
    return AnimalProfile(
      id: json['id'],
      animalCode: json['animal_code'] ?? '',
      name: json['name'] ?? '',
      salesOrderCustomerName: json['sales_order_customer_names'] ?? '',
      poel: json['poel'] ?? '',
      notes: json['notes'] ?? '',

      animalGroup: json['animal_group'] != null
          ? AnimalGroup.fromJson(json['animal_group'])
          : null,

      farmLocation: json['farm_location'] != null
          ? FarmLocation.fromJson(json['farm_location'])
          : null,

      farmArea: json['farm_area'] != null
          ? FarmArea.fromJson(json['farm_area'])
          : null,

      gender: json['gender'] ?? '',
      status: json['status'] ?? '',
      available: json['available'] ?? '',

      age: json['age'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),

      purchPrice: (json['purch_price'] ?? 0).toDouble(),
      salesPrice: (json['sales_price'] ?? 0).toDouble(),
      refSalesPrice: (json['ref_sales_price'] ?? 0).toDouble(),
      refSalesPriceTotal: (json['ref_sales_price_total'] ?? 0).toDouble(),

      currentClassName: json['current_class_name'],
      currentClassPrice: (json['current_class_price'] ?? 0).toDouble(),

      dispatchStatus: json['dispatch_status'],
      vehicleNumber: json['vehicle_number'],
      settlementStatus: json['settlement_status'],
    );
  }
}
