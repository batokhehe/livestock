import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../data/model/base_response.dart';
import '../data/model/feed_medicine_model.dart';

class FeedMedicineNotifier
    extends AutoDisposeAsyncNotifier<BaseResponse<FeedMedicine>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<FeedMedicine>> build() async {
    _page = 1;
    final search = ref.watch(feedMedicineSearchProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);
    return await useCase.callFeedMedicinesPaginated(
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

    final search = ref.read(feedMedicineSearchProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);
    final result = await useCase.callFeedMedicinesPaginated(
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
