import 'dart:ui';

import 'package:livestock/core/theme/AppColors.dart';

enum MonitoringItemStatus { pending, checked, received }

class MonitoringItem {
  final String id;
  final String code;
  final String subtitle;
  final String age;
  final String weight;
  final String cutWeight;
  final int price;
  final String? vaccine;
  final String? note;
  final MonitoringItemStatus status;

  const MonitoringItem({
    required this.id,
    required this.code,
    required this.subtitle,
    required this.age,
    required this.weight,
    required this.cutWeight,
    required this.price,
    this.vaccine,
    this.note,
    required this.status,
  });

  bool get isChecked => status == MonitoringItemStatus.checked;

  bool get isReceived => status == MonitoringItemStatus.received;

  String get statusText {
    switch (status) {
      case MonitoringItemStatus.checked:
        return 'Diperiksa';
      case MonitoringItemStatus.received:
        return 'Diterima';
      case MonitoringItemStatus.pending:
        return 'Menunggu';
    }
  }

  Color get statusColor {
    switch (status) {
      case MonitoringItemStatus.checked:
        return AppColors.success;
      case MonitoringItemStatus.received:
        return AppColors.success;
      case MonitoringItemStatus.pending:
        return AppColors.primaryShade;
    }
  }
}
