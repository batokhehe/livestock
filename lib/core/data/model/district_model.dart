class District {
  final String code;
  final String name;

  District({required this.code, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(code: json['code'], name: json['name']);
  }
}
