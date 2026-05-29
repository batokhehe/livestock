import 'dart:ui';

import 'package:livestock/core/theme/AppColors.dart';

enum MonitoringItemStatus { pending, checked, received }

class MonitoringItem {
  final String? id;
  final String? code;
  final String? stock;
  final String? subtitle;
  final String? age;
  final String? weight;
  final String? cutWeight;
  final int? price;
  final String? vaccine;
  final String? note;
  final MonitoringItemStatus? status;

  final String? name;
  final String? unit;
  final num? quantity;

  const MonitoringItem({
    this.id,
    this.code,
    this.subtitle,
    this.age,
    this.weight,
    this.cutWeight,
    this.price,
    this.vaccine,
    this.note,
    this.status,

    this.name,
    this.unit,
    this.quantity,
    this.stock,
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
      case null:
        throw UnimplementedError();
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
      case null:
        throw UnimplementedError();
    }
  }
}
