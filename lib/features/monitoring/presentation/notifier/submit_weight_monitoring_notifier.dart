import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';

class SubmitWeightMonitoringNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit() async {
    state = const AsyncLoading();
    try {
      final api = ref.read(monitoringApiProvider);
      final date = ref.read(selectedMonitoringDateProvider);
      final employee = ref.read(selectedMonitoringEmployeeProvider);
      final items = ref.read(addedMonitoringWeightItemsProvider);

      final payload = items.map((item) {
        return <String, dynamic>{
          'animal_profile_id': int.tryParse(item.id ?? '') ?? 0,
          'initial_weight': double.tryParse(item.stock ?? '') ?? 0.0,
          'final_weight': double.tryParse(item.weight ?? '') ?? 0.0,
          'adg_value': double.tryParse(item.unit ?? '') ?? 0.0,
          'different_days': int.tryParse(item.vaccine ?? '') ?? 0,
          'notes': item.note ?? '',
        };
      }).toList();

      await api.submitWeightMonitoring(
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

final submitWeightMonitoringProvider = AsyncNotifierProvider.autoDispose<
    SubmitWeightMonitoringNotifier, void>(
  SubmitWeightMonitoringNotifier.new,
);
