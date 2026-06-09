import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';

class SubmitAnimalHealthCheckNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit() async {
    state = const AsyncLoading();
    try {
      final api = ref.read(monitoringApiProvider);
      final date = ref.read(selectedHealthMonitoringDateProvider);
      final employee = ref.read(selectedMonitoringEmployeeProvider);
      final farm = ref.read(selectedMonitoringFarmProvider);
      final area = ref.read(selectedMonitoringAreaProvider);
      final animal = ref.read(selectedHealthCheckAnimalProvider);
      final items = ref.read(addedMonitoringHealthItemsProvider);

      if (animal == null) {
        throw Exception("Hewan harus dipilih");
      }

      final payload = items.map((item) {
        return <String, dynamic>{
          'feed_medicine_code': item.code ?? '',
          'quantity': item.quantity ?? 0.0,
          'uom': item.unit ?? 'Botol',
        };
      }).toList();

      await api.submitAnimalHealthCheck(
        monitoringDate: date ?? DateTime.now(),
        employeeId: employee?.id ?? 0,
        farmLocationId: farm?.id ?? 0,
        farmAreaId: area?.id ?? 0,
        animalId: animal.id,
        items: payload,
        status: 'confirmed',
        notes: 'Pemeriksaan Kesehatan',
      );

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final submitAnimalHealthCheckProvider = AsyncNotifierProvider.autoDispose<
    SubmitAnimalHealthCheckNotifier, void>(
  SubmitAnimalHealthCheckNotifier.new,
);
