import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../features/product/data/product_provider_tab.dart';
import '../../features/product/data/product_tab.dart';
import '../data/model/base_response.dart';

class ProductNotifier extends AsyncNotifier<BaseResponse<dynamic>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<dynamic>> build() async {
    _page = 1;

    final tab = ref.watch(productTabProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);

    final keyword = ref.watch(animalSearchProvider);
    final status = ref.watch(animalStatusProvider);
    final farmLocationId = ref.watch(animalFarmLocationIdProvider);
    final farmAreaId = ref.watch(animalFarmAreaIdProvider);

    final search = keyword.length >= 2 ? keyword : null;

    if (tab == ProductTab.product) {
      return await useCase.callAnimals(
        search: search,
        status: status.isNotEmpty ? status : null,
        farmLocationId: farmLocationId,
        farmAreaId: farmAreaId,
        page: _page,
        perPage: 10,
      );
    } else {
      return await useCase.callAnimalClass(
        search: search,
        status: ref.watch(animalClassStatusProvider),
        page: 1,
        perPage: 1000,
      );
    }
  }

  Future<void> loadMore() async {
    final current = state.value;

    if (current == null || _loadingMore) return;

    final total = current.total ?? 0;

    if (current.data.length >= total) return;

    _loadingMore = true;

    final tab = ref.read(productTabProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);

    _page++;

    if (tab == ProductTab.product) {
      final keyword = ref.read(animalSearchProvider);
      final status = ref.read(animalStatusProvider);
      final farmLocationId = ref.read(animalFarmLocationIdProvider);
      final farmAreaId = ref.read(animalFarmAreaIdProvider);

      final search = keyword.length >= 2 ? keyword : null;

      final result = await useCase.callAnimals(
        search: search,
        status: status.isNotEmpty ? status : null,
        farmLocationId: farmLocationId,
        farmAreaId: farmAreaId,
        page: _page,
        perPage: 10,
      );

      final merged = [...current.data, ...result.data];

      state = AsyncData(
        BaseResponse(
          status: result.status,
          message: result.message,
          total: result.total,
          data: merged,
        ),
      );
    } else {
      final keyword = ref.read(animalClassSearchProvider);
      final status = ref.read(animalClassStatusProvider);

      final search = keyword.length >= 2 ? keyword : null;

      final result = await useCase.callAnimalClass(
        search: search,
        status: status.isNotEmpty ? status : null,
        page: _page,
        perPage: 10,
      );

      final merged = [...current.data, ...result.data];

      state = AsyncData(
        BaseResponse(
          status: result.status,
          message: result.message,
          total: result.total,
          data: merged,
        ),
      );
    }

    _loadingMore = false;
  }
}
