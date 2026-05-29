import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/attendance/data/model/employee_model.dart';
import 'package:livestock/features/monitoring/data/monitoring_item_model.dart';
import 'package:livestock/features/monitoring/data/weight_monitoring_model.dart';

import 'package:livestock/features/monitoring/monitoring_provider.dart';

final editSelectedMonitoringEmployeeProvider = StateProvider.autoDispose<Employee?>((ref) => null);
final editSelectedMonitoringDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final editAddedMonitoringWeightItemsProvider = StateProvider.autoDispose<List<MonitoringItem>>((ref) => []);

class EditMonitoringWeightInitializer {
  static void init(WidgetRef ref, WeightMonitoring data) {
    // 1. Map Employee
    if (data.employee != null) {
      final employee = Employee(
        id: data.employee!.id,
        name: data.employee!.name,
        email: data.employee!.email ?? '',
        phone: data.employee!.phone,
        position: data.employee!.position,
        status: data.employee!.status,
        formattedHireDate: '',
        farmLocation: null,
      );
      ref.read(editSelectedMonitoringEmployeeProvider.notifier).state = employee;
    } else {
      ref.read(editSelectedMonitoringEmployeeProvider.notifier).state = null;
    }

    // 2. Map Date
    final parsedDate = DateTime.tryParse(data.monitoringDate);
    final finalDate = parsedDate ?? DateTime.now();
    ref.read(editSelectedMonitoringDateProvider.notifier).state = finalDate;
    ref.read(selectedMonitoringDateProvider.notifier).state = finalDate;

    // 3. Map Items
    final items = data.details.map((detail) {
      return MonitoringItem(
        id: detail.animalProfileId.toString(),
        name: detail.animalName,
        code: detail.animalCode,
        age: detail.animalProfile?.lastAdgDate ?? '',
        stock: detail.initialWeight.toString(),
        subtitle: detail.inventoryDate,
        weight: detail.finalWeight.toString(),
        cutWeight: detail.diffWeight.toString(),
        vaccine: detail.differentDays.toString(),
        unit: detail.adg.toString(),
        note: detail.notes ?? '',
        quantity: detail.finalWeight.toInt(),
      );
    }).toList();

    ref.read(editAddedMonitoringWeightItemsProvider.notifier).state = items;
  }
}
