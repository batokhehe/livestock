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
  final int refSalesPrice;
  final int refSalesPriceTotal;

  final String? currentClassName;
  final int? currentClassPrice;
  final int? currentClassPriceId;
  final double? currentClassMinWeight;
  final double? currentClassMaxWeight;

  final String? dispatchStatus;
  final String? vehicleNumber;
  final String? settlementStatus;

  final String? lastAdgDate;

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
    this.currentClassPrice,
    this.currentClassPriceId,
    this.currentClassMinWeight,
    this.currentClassMaxWeight,
    this.dispatchStatus,
    this.vehicleNumber,
    this.settlementStatus,
    this.lastAdgDate,
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
      weight: (json['weight'] is num)
          ? (json['weight'] as num).toDouble()
          : double.tryParse(json['weight']?.toString() ?? '0') ?? 0.0,

      purchPrice: (json['purch_price'] is num)
          ? (json['purch_price'] as num).toDouble()
          : double.tryParse(json['purch_price']?.toString() ?? '0') ?? 0.0,
      salesPrice: (json['sales_price'] is num)
          ? (json['sales_price'] as num).toDouble()
          : double.tryParse(json['sales_price']?.toString() ?? '0') ?? 0.0,
      refSalesPrice: json['ref_sales_price'] ?? 0,
      refSalesPriceTotal: json['ref_sales_price_total'] ?? 0,

      currentClassName: json['current_class_name'],
      currentClassPrice: json['current_class_price'] ?? 0,
      currentClassPriceId: json['current_class_price_id'] ?? 0,
      currentClassMinWeight: (json['current_class_min_weight'] is num)
          ? (json['current_class_min_weight'] as num).toDouble()
          : double.tryParse(json['current_class_min_weight']?.toString() ?? ''),
      currentClassMaxWeight: (json['current_class_max_weight'] is num)
          ? (json['current_class_max_weight'] as num).toDouble()
          : double.tryParse(json['current_class_max_weight']?.toString() ?? ''),

      dispatchStatus: json['dispatch_status'],
      vehicleNumber: json['vehicle_number'],
      settlementStatus: json['settlement_status'],
      lastAdgDate: json['last_adg_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animal_code': animalCode,
      'name': name,
      'sales_order_customer_names': salesOrderCustomerName,
      'poel': poel,
      'notes': notes,

      'animal_group': animalGroup?.toJson(),
      'farm_location': farmLocation?.toJson(),
      'farm_area': farmArea?.toJson(),

      'gender': gender,
      'status': status,
      'available': available,

      'age': age,
      'weight': weight,

      'purch_price': purchPrice,
      'sales_price': salesPrice,
      'ref_sales_price': refSalesPrice,
      'ref_sales_price_total': refSalesPriceTotal,

      'current_class_name': currentClassName,
      'current_class_price': currentClassPrice,
      'current_class_price_id': currentClassPriceId,
      'current_class_min_weight': currentClassMinWeight,
      'current_class_max_weight': currentClassMaxWeight,

      'dispatch_status': dispatchStatus,
      'vehicle_number': vehicleNumber,
      'settlement_status': settlementStatus,
      "last_adg_date": lastAdgDate,
    };
  }
}
