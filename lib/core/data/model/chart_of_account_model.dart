class ChartOfAccount {
  final int id;
  final String code;
  final String name;
  final String? type;

  ChartOfAccount({
    required this.id,
    required this.code,
    required this.name,
    this.type,
  });

  factory ChartOfAccount.fromJson(Map<String, dynamic> json) {
    return ChartOfAccount(
      id: json['id'],
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      type: json['type'],
    );
  }
}
