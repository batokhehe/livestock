import 'package:intl/intl.dart';

int countPresent(List details) =>
    details.where((e) => e['status'] == 'present').length;

int countAbsent(List details) =>
    details.where((e) => e['status'] == 'absent').length;

String formatDateString(String iso) {
  final date = DateTime.parse(iso);
  return "${date.day} ${monthName(date.month)} ${date.year}";
}

String formatDateTime(DateTime? d) =>
    d == null ? 'Pilih Tanggal' : DateFormat('dd MMM yyyy', 'id_ID').format(d);

final formatterJson = DateFormat('yyyy-MM-dd');

String monthName(int m) {
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "Mei",
    "Jun",
    "Jul",
    "Agu",
    "Sep",
    "Okt",
    "Nov",
    "Des",
  ];
  return months[m - 1];
}

String formatPrice(num value) {
  final str = value == value.toInt()
      ? value.toInt().toString()
      : value.toStringAsFixed(0);
  return str.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
}

bool equalsIgnoreCase(String? string1, String? string2) {
  return string1?.toLowerCase() == string2?.toLowerCase();
}
