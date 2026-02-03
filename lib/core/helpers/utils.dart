int countPresent(List details) =>
    details.where((e) => e['status'] == 'present').length;

int countAbsent(List details) =>
    details.where((e) => e['status'] == 'absent').length;

String formatDate(String iso) {
  final date = DateTime.parse(iso);
  return "${date.day} ${monthName(date.month)} ${date.year}";
}

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

String formatPrice(int value) {
  return value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
}
