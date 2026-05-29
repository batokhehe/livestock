import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';

class SubmitHealthMonitoringNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit() async {
    state = const AsyncLoading();
    try {
      final api = ref.read(monitoringApiProvider);
      final date = ref.read(selectedMedicineMonitoringDateProvider);
      final employee = ref.read(selectedMonitoringEmployeeProvider);
      final farm = ref.read(selectedMonitoringFarmProvider);
      final area = ref.read(selectedMonitoringAreaProvider);
      final items = ref.read(addedMonitoringMedicineItemsProvider);

      final payload = items.map((item) {
        return <String, dynamic>{
          'medicine_code': item.code ?? '',
          'quantity': item.quantity ?? 0.0,
          'uom': item.unit ?? 'Botol',
          'unit_price': item.price ?? 0,
        };
      }).toList();

      await api.submitHealthMonitoring(
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

final submitHealthMonitoringProvider = AsyncNotifierProvider.autoDispose<
    SubmitHealthMonitoringNotifier, void>(
  SubmitHealthMonitoringNotifier.new,
);
