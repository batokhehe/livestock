import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/model/base_response.dart';
import '../../data/model/receiving_list_model.dart';
import '../../receiving_provider.dart';

class ReceivingListNotifier extends AutoDisposeAsyncNotifier<BaseResponse<ReceivingList>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<ReceivingList>> build() async {
    _page = 1;
    final api = ref.read(receivingApiProvider);
    final tab = ref.watch(receivingTabProvider);
    final location = ref.watch(receivingLocationFilterProvider);
    final search = ref.watch(receivingSearchProvider);

    return await api.getReceiving(
      receiveType: tab.apiValue,
      farmLocationId: location?.id,
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

    final api = ref.read(receivingApiProvider);
    final tab = ref.read(receivingTabProvider);
    final location = ref.read(receivingLocationFilterProvider);
    final search = ref.read(receivingSearchProvider);

    try {
      final result = await api.getReceiving(
        receiveType: tab.apiValue,
        farmLocationId: location?.id,
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

final paginatedReceivingListProvider = AsyncNotifierProvider.autoDispose<
    ReceivingListNotifier, BaseResponse<ReceivingList>>(
  ReceivingListNotifier.new,
);
