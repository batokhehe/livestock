import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/app/providers.dart';
import 'package:livestock/features/attendance/data/model/employee_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/features/monitoring/data/monitoring_item_model.dart';
import 'package:livestock/features/monitoring/data/medicine_monitoring_model.dart';
import 'package:livestock/features/monitoring/data/total_animal_model.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';

final editSelectedMedicineMonitoringEmployeeProvider = StateProvider.autoDispose<Employee?>((ref) => null);
final editSelectedMedicineMonitoringDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final editSelectedMedicineMonitoringFarmProvider = StateProvider.autoDispose<FarmLocation?>((ref) => null);
final editSelectedMedicineMonitoringAreaProvider = StateProvider.autoDispose<FarmArea?>((ref) => null);
final editAddedMonitoringMedicineItemsProvider = StateProvider.autoDispose<List<MonitoringItem>>((ref) => []);

final editMonitoringAnimalAvailableCountProvider = FutureProvider.autoDispose<int>((
  ref,
) async {
  final farmId = ref.watch(editSelectedMedicineMonitoringFarmProvider)?.id;
  final areaId = ref.watch(editSelectedMedicineMonitoringAreaProvider)?.id;

  if (farmId == null || areaId == null) return 0;

  final dio = ref.watch(dioProvider);
  try {
    final res = await dio.get(
      '/monitoring/health-monitoring/total-animal',
      queryParameters: {'farm_location_id': farmId, 'farm_area_id': areaId}
        ..removeWhere((k, v) => v == null),
    );

    final responseData = res.data;
    if (responseData is Map) {
      final dataField = responseData['data'];
      if (dataField is Map) {
        return TotalAnimal.fromJson(
          dataField as Map<String, dynamic>,
        ).totalAnimal;
      }
      return TotalAnimal.fromJson(
        responseData as Map<String, dynamic>,
      ).totalAnimal;
    }

    return 0;
  } catch (e) {
    return 0;
  }
});

class EditMonitoringMedicineInitializer {
  static void init(WidgetRef ref, MedicineMonitoring data) {
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
      ref.read(editSelectedMedicineMonitoringEmployeeProvider.notifier).state = employee;
    } else {
      ref.read(editSelectedMedicineMonitoringEmployeeProvider.notifier).state = null;
    }

    // 2. Map Date
    ref.read(editSelectedMedicineMonitoringDateProvider.notifier).state = data.monitoringDate;
    ref.read(selectedMonitoringDateProvider.notifier).state = data.monitoringDate;

    // 3. Map Farm Location
    ref.read(editSelectedMedicineMonitoringFarmProvider.notifier).state = FarmLocation(
      id: data.farmLocationId,
      name: data.farmLocationName,
    );

    // 4. Map Farm Area
    ref.read(editSelectedMedicineMonitoringAreaProvider.notifier).state = FarmArea(
      id: data.farmAreaId,
      name: data.farmAreaName,
    );

    // 5. Map Items
    final items = data.details.map((detail) {
      return MonitoringItem(
        id: detail.feedMedicineId.toString(),
        code: detail.feedMedicineCode,
        name: detail.feedMedicine?.name ?? '',
        unit: detail.uom.isNotEmpty ? detail.uom : 'Botol',
        quantity: detail.quantity,
        stock: (detail.quantity + 100).toInt().toString(), // Default stock allocated
        price: detail.unitPrice.toInt(),
      );
    }).toList();

    ref.read(editAddedMonitoringMedicineItemsProvider.notifier).state = items;
  }
}
