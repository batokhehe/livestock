class ReceivingDetailItem {
  final int id;
  final String purchOrderNo;
  final String supplierName;
  final String itemName;
  final String itemCode;
  final String quantity;
  final String weight;
  final String? initialWeight;
  final int? ageCategory;
  final bool isVaccinated;
  final String? vaccineDate;
  final String? gender;
  final String? poel;
  final String? codeRef;
  final String? uom;
  final String? notes;
  final String? proofImage;

  ReceivingDetailItem({
    required this.id,
    required this.purchOrderNo,
    required this.supplierName,
    required this.itemName,
    required this.itemCode,
    required this.quantity,
    required this.weight,
    this.initialWeight,
    this.ageCategory,
    required this.isVaccinated,
    this.vaccineDate,
    this.gender,
    this.poel,
    this.codeRef,
    this.uom,
    this.notes,
    this.proofImage,
  });

  factory ReceivingDetailItem.fromJson(Map<String, dynamic> json) {
    return ReceivingDetailItem(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      purchOrderNo: json['purch_order_no'] ?? '-',
      supplierName: json['supplier_name'] ?? '-',
      itemName:
          json['animal_name'] ??
          json['feed_medicine_name'] ??
          json['equipment_name'] ??
          '-',
      itemCode:
          json['animal_code'] ??
          json['feed_medicine_code'] ??
          json['equipment_code'] ??
          '-',
      quantity: json['quantity']?.toString() ?? '0',
      weight: json['weight']?.toString() ?? '0',
      initialWeight: json['initial_weight']?.toString(),
      ageCategory: int.tryParse(json['age_category']?.toString() ?? ''),
      isVaccinated: json['is_vaccinated'] ?? false,
      vaccineDate: json['vaccine_date']?.toString(),
      gender: json['gender']?.toString(),
      poel: json['poel']?.toString(),
      codeRef: json['code_ref']?.toString(),
      uom: json['uom']?.toString(),
      notes: json['notes']?.toString(),
      proofImage: json['proof_image']?.toString(),
    );
  }
}
