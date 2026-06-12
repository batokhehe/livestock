import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';
import 'package:livestock/features/monitoring/presentation/views/medicine/edit/edit_monitoring_medicine_provider.dart';

class UpdateHealthMonitoringNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> updateHealthMonitoring(int id) async {
    state = const AsyncLoading();
    try {
      final api = ref.read(monitoringApiProvider);
      final date = ref.read(editSelectedMedicineMonitoringDateProvider);
      final employee = ref.read(editSelectedMedicineMonitoringEmployeeProvider);
      final farm = ref.read(editSelectedMedicineMonitoringFarmProvider);
      final area = ref.read(editSelectedMedicineMonitoringAreaProvider);
      final items = ref.read(editAddedMonitoringMedicineItemsProvider);

      final payload = items.map((item) {
        return <String, dynamic>{
          'medicine_code': item.code ?? '',
          'quantity': item.quantity ?? 0.0,
          'uom': item.unit ?? 'Botol',
          'unit_price': item.price ?? 0,
        };
      }).toList();

      await api.updateHealthMonitoring(
        id: id,
        monitoringDate: date ?? DateTime.now(),
        employeeId: employee?.id ?? 0,
        farmLocationId: farm?.id ?? 0,
        farmAreaId: area?.id ?? 0,
        items: payload,
        status: 'draft',
        notes: 'Monitoring kesehatan',
      );

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final updateHealthMonitoringProvider = AsyncNotifierProvider.autoDispose<
    UpdateHealthMonitoringNotifier, void>(
  UpdateHealthMonitoringNotifier.new,
);
