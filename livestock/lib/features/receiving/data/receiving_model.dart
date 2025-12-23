import 'package:livestock/features/receiving/data/receiving_item_model.dart';

enum ReceivingStatus { received, waiting }

enum ReceivingFilter { product, feed, tools }

class Receiving {
  final String code;
  final String subtitle;
  final ReceivingStatus status;
  final int total;
  final DateTime date;
  final List<ReceivingItem> items;

  String get dateLabel => '${date.day} ${_month(date.month)} ${date.year}';

  static String _month(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[m - 1];
  }

  Receiving({
    required this.code,
    required this.subtitle,
    required this.status,
    required this.total,
    required this.date,
    required this.items,
  });
}
