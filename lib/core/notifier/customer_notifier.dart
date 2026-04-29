import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../data/model/base_response.dart';
import '../data/model/customer_model.dart';

class CustomerNotifier
    extends AutoDisposeAsyncNotifier<BaseResponse<Customer>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<Customer>> build() async {
    _page = 1;
    final search = ref.watch(customerSearchProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);
    final status = ref.watch(customerStatusProvider);

    return await useCase.callCustomerPaginated(
      page: _page,
      perPage: 10,
      search: search.isEmpty ? null : search,
      status: status.isEmpty ? null : status,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _loadingMore) return;

    final total = current.total ?? 0;
    if (current.data.length >= total) return;

    _loadingMore = true;
    _page++;

    final search = ref.read(customerSearchProvider);
    final status = ref.read(customerStatusProvider);
    final useCase = ref.read(getMasterDataListUseCaseProvider);

    final result = await useCase.callCustomerPaginated(
      page: _page,
      perPage: 10,
      search: search.isEmpty ? null : search,
      status: status.isEmpty ? null : status,
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
