import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../data/model/base_response.dart';
import '../data/model/farm_area_model.dart';

class FarmAreaNotifier
    extends AutoDisposeFamilyAsyncNotifier<BaseResponse<FarmArea>, int?> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<FarmArea>> build(int? arg) async {
    _page = 1;
    final search = ref.watch(farmAreaSearchProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);

    return await useCase.callFarmAreasPaginated(
      farmLocationId: arg,
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

    final search = ref.read(farmAreaSearchProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);

    try {
      final result = await useCase.callFarmAreasPaginated(
        farmLocationId: arg,
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
      _page--;
      state = AsyncError(e, st);
    } finally {
      _loadingMore = false;
    }
  }
}
