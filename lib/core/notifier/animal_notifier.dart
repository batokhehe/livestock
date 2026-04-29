import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../data/model/base_response.dart';
import '../data/model/animal_profile_model.dart';

class AnimalNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<
          BaseResponse<AnimalProfile>,
          ({String? available, int? farmLocationId})
        > {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<AnimalProfile>> build(
    ({String? available, int? farmLocationId}) arg,
  ) async {
    _page = 1;
    final search = ref.watch(animalSearchProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);

    return await useCase.callAnimals(
      available: (arg.available?.isEmpty ?? true) ? null : arg.available,
      search: (search.length >= 2) ? search : null,
      farmLocationId: arg.farmLocationId,
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

    final search = ref.read(animalSearchProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);

    final result = await useCase.callAnimals(
      available: (arg.available?.isEmpty ?? true) ? null : arg.available,
      search: (search.length >= 2) ? search : null,
      farmLocationId: arg.farmLocationId,
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
