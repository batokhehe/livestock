import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/app/providers.dart';
import 'package:livestock/core/constant/enum.dart';
import 'package:livestock/core/data/model/base_response.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'data/api/transfer_api.dart';
import 'data/model/transfer_list_model.dart';

final transferSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final transferFromLocationFilterProvider = StateProvider.autoDispose<FarmLocation?>(
  (ref) => null,
);

final transferToLocationFilterProvider = StateProvider.autoDispose<FarmLocation?>(
  (ref) => null,
);

final transferApiProvider = Provider((ref) {
  return TransferApi(ref.read(dioProvider));
});

class TransferListNotifier extends AutoDisposeAsyncNotifier<BaseResponse<TransferList>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<TransferList>> build() async {
    _page = 1;
    final api = ref.read(transferApiProvider);
    final search = ref.watch(transferSearchProvider);
    final fromLocation = ref.watch(transferFromLocationFilterProvider);
    final toLocation = ref.watch(transferToLocationFilterProvider);
    final filter = ref.watch(itemFilterProvider);

    final isStock = filter == ItemFilter.feed;

    return await api.getTransfer(
      isStock: isStock,
      page: _page,
      perPage: 10,
      search: search.isEmpty ? null : search,
      itemType: isStock ? 'feed' : null,
      fromFarmLocationId: fromLocation?.id,
      toFarmLocationId: toLocation?.id,
      sortBy: 'transfer_date',
      sortDir: 'desc',
      all: false,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _loadingMore) return;

    final total = current.total ?? current.totalRows ?? 0;
    if (current.data.length >= total) return;

    _loadingMore = true;
    _page++;

    final api = ref.read(transferApiProvider);
    final search = ref.read(transferSearchProvider);
    final fromLocation = ref.read(transferFromLocationFilterProvider);
    final toLocation = ref.read(transferToLocationFilterProvider);
    final filter = ref.read(itemFilterProvider);

    final isStock = filter == ItemFilter.feed;

    try {
      final result = await api.getTransfer(
        isStock: isStock,
        page: _page,
        perPage: 10,
        search: search.isEmpty ? null : search,
        itemType: isStock ? 'feed' : null,
        fromFarmLocationId: fromLocation?.id,
        toFarmLocationId: toLocation?.id,
        sortBy: 'transfer_date',
        sortDir: 'desc',
        all: false,
      );

      state = AsyncData(
        BaseResponse(
          status: result.status,
          message: result.message,
          total: result.total ?? result.totalRows,
          totalRows: result.totalRows ?? result.total,
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

final paginatedTransferListProvider = AsyncNotifierProvider.autoDispose<
    TransferListNotifier, BaseResponse<TransferList>>(
  TransferListNotifier.new,
);

// Providers for Tambah Pemindahan Hewan Step 1
final transferAnimalSearchProvider = StateProvider.autoDispose<String>((ref) => '');

class TransferAnimalProfilesNotifier extends AutoDisposeAsyncNotifier<BaseResponse<AnimalProfile>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<AnimalProfile>> build() async {
    _page = 1;
    final search = ref.watch(transferAnimalSearchProvider);
    final api = ref.read(transferApiProvider);

    return await api.getAnimalProfilesForTransfer(
      search: search.isEmpty ? null : search,
      page: _page,
      perPage: 10,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _loadingMore) return;

    final total = current.total ?? current.totalRows ?? 0;
    if (current.data.length >= total) return;

    _loadingMore = true;
    _page++;

    final search = ref.read(transferAnimalSearchProvider);
    final api = ref.read(transferApiProvider);

    try {
      final result = await api.getAnimalProfilesForTransfer(
        search: search.isEmpty ? null : search,
        page: _page,
        perPage: 10,
      );

      state = AsyncData(
        BaseResponse(
          status: result.status,
          message: result.message,
          total: result.total ?? result.totalRows,
          totalRows: result.totalRows ?? result.total,
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

final transferAnimalProfilesProvider = AsyncNotifierProvider.autoDispose<
    TransferAnimalProfilesNotifier, BaseResponse<AnimalProfile>>(
  TransferAnimalProfilesNotifier.new,
);

final selectedTransferDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedTransferAnimalProvider = StateProvider<AnimalProfile?>((ref) => null);
