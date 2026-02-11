class Village {
  final String code;
  final String name;

  Village({required this.code, required this.name});

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(code: json['code'], name: json['name']);
  }
}
