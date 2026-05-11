import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../data/model/base_response.dart';
import '../data/model/animal_group_model.dart';

class AnimalGroupNotifier
    extends AutoDisposeAsyncNotifier<BaseResponse<AnimalGroup>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<AnimalGroup>> build() async {
    _page = 1;
    final search = ref.watch(animalGroupSearchProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);

    return await useCase.callAnimalGroupsPaginated(
      search: (search.length >= 2) ? search : null,
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

    final search = ref.read(animalGroupSearchProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);

    final result = await useCase.callAnimalGroupsPaginated(
      search: (search.length >= 2) ? search : null,
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
