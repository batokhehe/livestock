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
import 'data/model/stock_transfer_item_model.dart';
import 'data/model/stock_transfer_detail_model.dart';

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
      itemType: null,
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
        itemType: null,
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

final stockTransferDetailProvider = FutureProvider.autoDispose.family<StockTransferDetail, int>((ref, id) async {
  final api = ref.read(transferApiProvider);
  return api.getStockTransferDetail(id);
});

final selectedStockTransferDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedStockTransferTypeProvider = StateProvider<String?>((ref) => null);
final selectedStockTransferItemProvider = StateProvider<StockTransferItem?>((ref) => null);
final stockTransferQuantityProvider = StateProvider<double?>((ref) => null);
final stockTransferSearchProvider = StateProvider.autoDispose<String>((ref) => '');

class StockTransferItemsNotifier extends AutoDisposeAsyncNotifier<BaseResponse<StockTransferItem>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<StockTransferItem>> build() async {
    _page = 1;
    final search = ref.watch(stockTransferSearchProvider);
    final type = ref.watch(selectedStockTransferTypeProvider);
    final api = ref.read(transferApiProvider);

    if (type == null) {
      return BaseResponse<StockTransferItem>(
        status: 200,
        message: 'Silakan pilih tipe stock terlebih dahulu',
        data: [],
      );
    }

    if (type == 'Alat') {
      return await api.getEquipmentAndSupplies(
        search: search.isEmpty ? null : search,
        page: _page,
        perPage: 15,
      );
    } else {
      final apiType = type == 'Pakan' ? 'feed' : 'medicine';
      return await api.getFeedMedicines(
        search: search.isEmpty ? null : search,
        type: apiType,
        page: _page,
        perPage: 15,
      );
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _loadingMore) return;

    final total = current.total ?? current.totalRows ?? 0;
    if (current.data.length >= total) return;

    _loadingMore = true;
    _page++;

    final search = ref.read(stockTransferSearchProvider);
    final type = ref.read(selectedStockTransferTypeProvider);
    final api = ref.read(transferApiProvider);

    if (type == null) {
      _loadingMore = false;
      return;
    }

    try {
      final BaseResponse<StockTransferItem> result;
      if (type == 'Alat') {
        result = await api.getEquipmentAndSupplies(
          search: search.isEmpty ? null : search,
          page: _page,
          perPage: 15,
        );
      } else {
        final apiType = type == 'Pakan' ? 'feed' : 'medicine';
        result = await api.getFeedMedicines(
          search: search.isEmpty ? null : search,
          type: apiType,
          page: _page,
          perPage: 15,
        );
      }

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

final paginatedStockTransferItemsProvider = AsyncNotifierProvider.autoDispose<
    StockTransferItemsNotifier, BaseResponse<StockTransferItem>>(
  StockTransferItemsNotifier.new,
);

final selectedStockTransferToLocationProvider = StateProvider<FarmLocation?>((ref) => null);
final stockTransferDeliveryCostProvider = StateProvider<double?>((ref) => null);
final stockTransferLocationSearchProvider = StateProvider.autoDispose<String>((ref) => '');

class StockTransferFarmLocationsNotifier extends AutoDisposeAsyncNotifier<BaseResponse<FarmLocation>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<FarmLocation>> build() async {
    _page = 1;
    final search = ref.watch(stockTransferLocationSearchProvider);
    final api = ref.read(transferApiProvider);
    return await api.getStockTransferFarmLocations(
      search: search.isEmpty ? null : search,
      page: _page,
      perPage: 15,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _loadingMore) return;

    final total = current.total ?? current.totalRows ?? 0;
    if (current.data.length >= total) return;

    _loadingMore = true;
    _page++;

    final search = ref.read(stockTransferLocationSearchProvider);
    final api = ref.read(transferApiProvider);

    try {
      final result = await api.getStockTransferFarmLocations(
        search: search.isEmpty ? null : search,
        page: _page,
        perPage: 15,
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

final paginatedStockTransferFarmLocationsProvider = AsyncNotifierProvider.autoDispose<
    StockTransferFarmLocationsNotifier, BaseResponse<FarmLocation>>(
  StockTransferFarmLocationsNotifier.new,
);

class SubmitStockTransferNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit() async {
    state = const AsyncLoading();
    try {
      final api = ref.read(transferApiProvider);
      final date = ref.read(selectedStockTransferDateProvider);
      final item = ref.read(selectedStockTransferItemProvider);
      final toLocation = ref.read(selectedStockTransferToLocationProvider);
      final qty = ref.read(stockTransferQuantityProvider);
      final shippingCost = ref.read(stockTransferDeliveryCostProvider);

      if (item == null) {
        throw Exception("Item stock harus dipilih");
      }
      if (toLocation == null) {
        throw Exception("Lokasi tujuan harus dipilih");
      }
      if (qty == null || qty <= 0) {
        throw Exception("Kuantitas harus diisi");
      }

      // Format date to yyyy-MM-dd
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      // Map itemType: Pakan -> feed, Obat -> medicine, Alat -> equipment or supply
      String itemType = 'feed';
      final typeText = ref.read(selectedStockTransferTypeProvider);
      if (typeText == 'Obat') {
        itemType = 'medicine';
      } else if (typeText == 'Alat') {
        itemType = item.itemCode.startsWith('SUP') ? 'supply' : 'equipment';
      }

      final notes = "Transfer $itemType ke lokasi ${toLocation.name}";

      await api.createStockTransfer(
        transferDate: formattedDate,
        fromFarmLocationId: item.farmLocationId,
        toFarmLocationId: toLocation.id,
        itemType: itemType,
        itemId: item.id,
        itemCode: item.itemCode,
        itemName: item.itemName,
        qty: qty,
        notes: notes,
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
    ref.invalidate(selectedStockTransferItemProvider);
    ref.invalidate(selectedStockTransferToLocationProvider);
    ref.invalidate(stockTransferQuantityProvider);
    ref.invalidate(stockTransferDeliveryCostProvider);
  }
}

final submitStockTransferProvider = AsyncNotifierProvider.autoDispose<
    SubmitStockTransferNotifier, void>(
  SubmitStockTransferNotifier.new,
);
