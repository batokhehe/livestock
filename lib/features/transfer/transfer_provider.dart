import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/app/providers.dart';
import 'package:livestock/core/constant/enum.dart';
import 'package:livestock/core/data/model/base_response.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'data/api/transfer_api.dart';
import 'data/model/transfer_list_model.dart';
import 'data/model/transfer_detail_model.dart';

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

// Providers for Tambah Pemindahan Hewan Step 1 & 2
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

final selectedTransferToLocationProvider = StateProvider<FarmLocation?>((ref) => null);
final selectedTransferToAreaProvider = StateProvider<FarmArea?>((ref) => null);
final transferDeliveryCostProvider = StateProvider<double?>((ref) => null);

class SubmitTransferNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit() async {
    state = const AsyncLoading();
    try {
      final api = ref.read(transferApiProvider);
      final date = ref.read(selectedTransferDateProvider);
      final animal = ref.read(selectedTransferAnimalProvider);
      final toLocation = ref.read(selectedTransferToLocationProvider);
      final toArea = ref.read(selectedTransferToAreaProvider);
      final shippingCost = ref.read(transferDeliveryCostProvider);

      if (animal == null) {
        throw Exception("Hewan harus dipilih");
      }
      if (toLocation == null) {
        throw Exception("Lokasi tujuan harus dipilih");
      }
      if (toArea == null) {
        throw Exception("Area tujuan harus dipilih");
      }
      if (animal.farmLocation == null) {
        throw Exception("Lokasi asal hewan tidak ditemukan");
      }
      if (animal.farmArea == null) {
        throw Exception("Area asal hewan tidak ditemukan");
      }

      // Format date to yyyy-MM-dd
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      await api.createAnimalTransfer(
        transferDate: formattedDate,
        fromFarmLocationId: animal.farmLocation!.id,
        toFarmLocationId: toLocation.id,
        fromFarmAreaId: animal.farmArea!.id,
        toFarmAreaId: toArea.id,
        animalProfileId: animal.id,
        shippingCost: shippingCost,
      );

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  void reset() {
    ref.invalidate(selectedTransferAnimalProvider);
    ref.invalidate(selectedTransferToLocationProvider);
    ref.invalidate(selectedTransferToAreaProvider);
    ref.invalidate(transferDeliveryCostProvider);
  }
}

final submitTransferProvider = AsyncNotifierProvider.autoDispose<
    SubmitTransferNotifier, void>(
  SubmitTransferNotifier.new,
);

final transferDetailProvider = FutureProvider.autoDispose.family<TransferDetail, int>((ref, id) async {
  final api = ref.read(transferApiProvider);
  return api.getTransferDetail(id);
});
