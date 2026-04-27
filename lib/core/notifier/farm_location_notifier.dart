import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../data/model/base_response.dart';
import '../data/model/farm_location_model.dart';

class FarmLocationNotifier
    extends AutoDisposeAsyncNotifier<BaseResponse<FarmLocation>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<FarmLocation>> build() async {
    _page = 1;
    final search = ref.watch(farmLocationSearchProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);
    return await useCase.callFarmLocationsPaginated(
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

    final search = ref.read(farmLocationSearchProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);
    final result = await useCase.callFarmLocationsPaginated(
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
