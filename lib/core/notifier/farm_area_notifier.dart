import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../data/model/base_response.dart';
import '../data/model/farm_area_model.dart';

class FarmAreaNotifier extends AutoDisposeAsyncNotifier<BaseResponse<FarmArea>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<FarmArea>> build() async {
    _page = 1;
    final farmLocationId = ref.watch(animalFarmLocationIdProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);
    
    return await useCase.callFarmAreasPaginated(
      farmLocationId: farmLocationId,
      page: _page, 
      perPage: 10,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _loadingMore) return;

    final total = current.total ?? 0;
    if (current.data.length >= total) return;

    _loadingMore = true;
    _page++;

    final farmLocationId = ref.read(animalFarmLocationIdProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);
    
    final result = await useCase.callFarmAreasPaginated(
      farmLocationId: farmLocationId,
      page: _page, 
      perPage: 10,
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
