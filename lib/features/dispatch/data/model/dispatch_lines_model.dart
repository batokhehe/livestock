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
  });

  factory DispatchLine.fromJson(Map<String, dynamic> json) {
    return DispatchLine(
      id: json['id'],
      animalId: json['animal_id'],
      animalCode: json['animal_code'],
      animalName: json['animal_name'],
      quantity: json['quantity'],
      state: json['state'],
      city: json['city'],
      district: json['district'],
      village: json['village'],
      recipientName: json['recipient_name'],
      recipientNumber: json['recipient_number'],
      deliveryAddress: json['delivery_address'],
      dlvDate: json['dlv_date'],
    );
  }
}
