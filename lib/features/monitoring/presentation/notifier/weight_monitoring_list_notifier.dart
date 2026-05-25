import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/base_response.dart';
import 'package:livestock/features/monitoring/data/weight_monitoring_model.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';

class WeightMonitoringListNotifier
    extends AutoDisposeAsyncNotifier<BaseResponse<WeightMonitoring>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<WeightMonitoring>> build() async {
    _page = 1;
    final api = ref.read(monitoringApiProvider);
    final search = ref.watch(weightMonitoringSearchProvider);
    final type = ref.watch(weightMonitoringTypeProvider);

    return api.getWeightMonitoring(
      page: _page,
      perPage: 10,
      search: search.isEmpty ? null : search,
      type: type.isEmpty ? null : type,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _loadingMore) return;

    final total = current.total ?? 0;
    if (current.data.length >= total) return;

    _loadingMore = true;
    _page++;

    final api = ref.read(monitoringApiProvider);
    final search = ref.read(weightMonitoringSearchProvider);
    final type = ref.read(weightMonitoringTypeProvider);

    try {
      final result = await api.getWeightMonitoring(
        page: _page,
        perPage: 10,
        search: search.isEmpty ? null : search,
        type: type.isEmpty ? null : type,
      );

      state = AsyncData(
        BaseResponse(
          status: result.status,
          message: result.message,
          total: result.total,
          data: [...current.data, ...result.data],
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _loadingMore = false;
    }
  }
}

final weightMonitoringListProvider = AsyncNotifierProvider.autoDispose<
    WeightMonitoringListNotifier, BaseResponse<WeightMonitoring>>(
  WeightMonitoringListNotifier.new,
);
