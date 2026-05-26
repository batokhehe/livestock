import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/base_response.dart';
import 'package:livestock/features/monitoring/data/feed_monitoring_model.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';

class FeedMonitoringListNotifier
    extends AutoDisposeAsyncNotifier<BaseResponse<FeedMonitoring>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<FeedMonitoring>> build() async {
    _page = 1;
    final api = ref.read(monitoringApiProvider);
    final search = ref.watch(feedMonitoringSearchProvider);

    return api.getFeedMonitoring(
      page: _page,
      perPage: 10,
      search: search.isEmpty ? null : search,
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
    final search = ref.read(feedMonitoringSearchProvider);

    try {
      final result = await api.getFeedMonitoring(
        page: _page,
        perPage: 10,
        search: search.isEmpty ? null : search,
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

final feedMonitoringListProvider = AsyncNotifierProvider.autoDispose<
    FeedMonitoringListNotifier, BaseResponse<FeedMonitoring>>(
  FeedMonitoringListNotifier.new,
);
