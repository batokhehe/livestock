import 'monitoring_item_model.dart';

enum MonitoringStatus { received, confirmed, waiting }

enum MonitoringFilter { product, feed, tools }

class Monitoring {
  final String code;
  final String? title;
  final String? location;
  final String? description;
  final String subtitle;
  final MonitoringStatus status;
  final int total;
  final int? count;
  final DateTime? date;
  final List<MonitoringItem> items;

  String get dateLabel =>
      date != null ? '${date!.day} ${_month(date!.month)} ${date!.year}' : '';

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

  Monitoring({
    required this.code,
    required this.subtitle,
    required this.status,
    this.count,
    this.title,
    this.location,
    required this.total,
    this.date,
    required this.items,
    this.description,
  });
}
