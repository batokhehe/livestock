import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/model/base_response.dart';
import '../../../../app/providers.dart';
import '../../data/model/receiving_po_model.dart';
import '../../receiving_provider.dart';

class ReceivingPoNotifier extends AutoDisposeAsyncNotifier<BaseResponse<ReceivingPo>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<ReceivingPo>> build() async {
    _page = 1;
    final api = ref.read(receivingApiProvider);
    final tab = ref.watch(receivingTabProvider);
    final farmLocationId = ref.watch(animalFarmLocationIdProvider);
    final farmAreaId = ref.watch(animalFarmAreaIdProvider);
    final search = ref.watch(receivingPoSearchProvider);

    return await api.getReceivingPo(
      type: tab.apiValue,
      farmLocationId: farmLocationId,
      farmAreaId: farmAreaId,
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
    final farmLocationId = ref.read(animalFarmLocationIdProvider);
    final farmAreaId = ref.read(animalFarmAreaIdProvider);
    final search = ref.read(receivingPoSearchProvider);

    final result = await api.getReceivingPo(
      type: tab.apiValue,
      farmLocationId: farmLocationId,
      farmAreaId: farmAreaId,
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

    _loadingMore = false;
  }
}

final paginatedReceivingPoProvider = AsyncNotifierProvider.autoDispose<
    ReceivingPoNotifier, BaseResponse<ReceivingPo>>(
  ReceivingPoNotifier.new,
);
