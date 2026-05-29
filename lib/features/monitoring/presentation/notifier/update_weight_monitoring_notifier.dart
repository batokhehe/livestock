import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';
import 'package:livestock/features/monitoring/presentation/views/weight/edit/edit_monitoring_weight_provider.dart';

class UpdateWeightMonitoringNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> updateWeightMonitoring(int id) async {
    state = const AsyncLoading();
    try {
      final api = ref.read(monitoringApiProvider);
      final date = ref.read(editSelectedMonitoringDateProvider);
      final employee = ref.read(editSelectedMonitoringEmployeeProvider);
      final items = ref.read(editAddedMonitoringWeightItemsProvider);

      final payload = items.map((item) {
        return <String, dynamic>{
          'animal_profile_id': int.tryParse(item.id ?? '') ?? 0,
          'initial_weight': double.tryParse(item.stock ?? '') ?? 0.0,
          'final_weight': double.tryParse(item.weight ?? '') ?? 0.0,
          'adg': double.tryParse(item.unit ?? '') ?? 0.0,
          'different_days': int.tryParse(item.vaccine ?? '') ?? 0,
          'notes': item.note ?? '',
        };
      }).toList();

      await api.updateWeightMonitoring(
        id: id,
        monitoringDate: date ?? DateTime.now(),
        employeeId: employee?.id ?? 0,
        items: payload,
      );

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final updateWeightMonitoringProvider = AsyncNotifierProvider.autoDispose<
    UpdateWeightMonitoringNotifier, void>(
  UpdateWeightMonitoringNotifier.new,
);
