import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/features/product/data/product_tab.dart';
import 'package:livestock/features/product/presentation/widgets/product_card.dart';
import 'package:livestock/features/product/presentation/widgets/product_grade_card.dart';

import '../../../../app/providers.dart';
import '../../../../core/data/model/animal_class_model.dart';
import '../../../../core/data/model/animal_profile_model.dart';
import '../../../../core/helpers/utils.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../data/product_provider_tab.dart';
import '../widgets/product_group_bottom_sheet.dart';
import '../widgets/farm_area_bottom_sheet.dart';
import '../../../../core/widgets/farm_location_paginated_bottom_sheet.dart';
import '../../../../core/helpers/snackbar_helper.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ProductPage> createState() => _ProductPage();
}

class _ProductPage extends ConsumerState<ProductPage> {
  late final TextEditingController searchCtrl;
  Timer? _debounce;
  late final ScrollController _scrollController;

  final availableItems = [
    {'value': '', 'label': 'Ketersediaan'},
    {'value': 'available', 'label': 'Tersedia'},
    {'value': 'sold', 'label': 'Terjual'},
    {'value': 'booked', 'label': 'Dipesan'},
  ];

  final classItems = [
    {'value': '', 'label': 'Semua Kelas'},
    {'value': 'active', 'label': 'Aktif'},
    {'value': 'inactive', 'label': 'Nonaktif'},
  ];

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();
    _scrollController = ScrollController();

    ref.read(animalSearchProvider.notifier).state = '';

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(productDataProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _resetFilters();
    ref.invalidate(productDataProvider);
    await ref.read(productDataProvider.future);
  }

  void _resetFilters() {
    searchCtrl.clear();
    ref.read(animalSearchProvider.notifier).state = '';
    ref.read(animalAvailableProvider.notifier).state = '';
    ref.read(animalFarmLocationIdProvider.notifier).state = null;
    ref.read(animalFarmAreaIdProvider.notifier).state = null;
    ref.read(animalClassStatusProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(productTabProvider);
    final dataAsync = ref.watch(productDataProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Hewan", style: AppTypography.largeBoldBlack),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
            Future.microtask(() {
              mainPageKey.currentState?.changeTab(0);
            });
          },
        ),
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Error: $error", textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(productDataProvider),
                icon: const Icon(Icons.refresh),
                label: const Text("Coba Lagi"),
              ),
            ],
          ),
        ),
        data: (data) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _searchBar(),
                  const SizedBox(height: 12),
                  _tabMenu(ref, tab),
                  const SizedBox(height: 12),
                  Expanded(
                    child: tab == ProductTab.product
                        ? _buildAnimalList(
                            data.data.cast<AnimalProfile>(),
                            data.total ?? 0,
                          )
                        : _buildAnimalClassList(
                            data.data.cast<AnimalClass>(),
                            data.total ?? 0,
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    if (value.length < 2 && value.isNotEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(animalSearchProvider.notifier).state = value;
    });
  }

  void _clearSearch() {
    searchCtrl.clear();
    _debounce?.cancel();
    ref.read(animalSearchProvider.notifier).state = '';
  }

  Widget _searchBar() {
    final keyword = ref.watch(animalSearchProvider);
    return TextField(
      controller: searchCtrl,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: "Cari Hewan",
        hintStyle: TextStyle(
          color: AppColors.grey,
          fontSize: 13.0,
          fontWeight: FontWeight.w600,
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: SvgPicture.asset(AppImages.icSearch, fit: BoxFit.fitWidth),
        ),
        suffixIcon: keyword.isNotEmpty
            ? IconButton(icon: Icon(Icons.close), onPressed: _clearSearch)
            : null,
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.fieldBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryDark, width: 2.0),
        ),
      ),
    );
  }

  Widget _tabMenu(WidgetRef ref, ProductTab tab) {
    return Row(
      children: [
        _TabChip(
          label: "Data Sapi",
          selected: tab == ProductTab.product,
          onTap: () =>
              ref.read(productTabProvider.notifier).state = ProductTab.product,
        ),
        const SizedBox(width: 8),
        _TabChip(
          label: "Data Sapi Qurban",
          selected: tab == ProductTab.grade,
          onTap: () =>
              ref.read(productTabProvider.notifier).state = ProductTab.grade,
        ),
      ],
    );
  }

  Widget _filterRow() {
    final selectedAvailable = ref.watch(animalAvailableProvider);
    final selectedLabel = availableItems.firstWhere(
      (e) => e['value'] == selectedAvailable,
    )['label']!;

    final farmLocationsAsync = ref.watch(farmLocationListProvider);
    final selectedFarmLocationId = ref.watch(animalFarmLocationIdProvider);

    final farmAreasAsync = ref.watch(farmAreaListProvider);
    final selectedFarmAreaId = ref.watch(animalFarmAreaIdProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: DropdownButtonFormField2<String>(
              isExpanded: true,
              hint: Text(
                selectedLabel,
                style: AppTypography.smallNormalBlack,
                overflow: TextOverflow.ellipsis,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.fieldBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primaryDark,
                    width: 2.0,
                  ),
                ),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down),
              ),
              style: AppTypography.smallNormalBlack,
              items: availableItems
                  .map(
                    (item) => DropdownItem<String>(
                      value: item['value']!,
                      child: Text(
                        item['label']!,
                        style: AppTypography.smallNormalBlack,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                ref.read(animalAvailableProvider.notifier).state = value ?? '';
              },
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) FocusScope.of(context).unfocus();
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 170,
            child: Consumer(
              builder: (context, ref, child) {
                final selectedFarmLocationId = ref.watch(
                  animalFarmLocationIdProvider,
                );
                final farmLocationsAsync = ref.watch(farmLocationListProvider);

                String label = "Semua Lokasi";
                if (selectedFarmLocationId != null) {
                  label = farmLocationsAsync.when(
                    data: (list) => list
                        .firstWhere(
                          (e) => e.id == selectedFarmLocationId,
                          orElse: () => FarmLocation(id: 0, name: "Lokasi"),
                        )
                        .name,
                    loading: () => "Memuat...",
                    error: (_, __) => "Error",
                  );
                }

                return GestureDetector(
                  onTap: () async {
                    final result = await showModalBottomSheet<FarmLocation>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => FarmLocationPaginatedBottomSheet(
                        initialSelectedId: selectedFarmLocationId,
                        showAllOption: true,
                        showSearch: false,
                      ),
                    );

                    if (result != null) {
                      ref.read(animalFarmLocationIdProvider.notifier).state =
                          result.id == -1 ? null : result.id;
                      ref.read(animalFarmAreaIdProvider.notifier).state = null;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.fieldBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: AppTypography.smallNormalBlack,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 170,
            child: Consumer(
              builder: (context, ref, child) {
                final selectedFarmAreaId = ref.watch(animalFarmAreaIdProvider);
                final farmAreasAsync = ref.watch(farmAreaListProvider);
                final selectedFarmLocationId = ref.watch(
                  animalFarmLocationIdProvider,
                );
                final isLocationSelected = selectedFarmLocationId != null;

                String label = "Semua Area";
                if (selectedFarmAreaId != null) {
                  label = farmAreasAsync.when(
                    data: (list) => list
                        .firstWhere(
                          (e) => e.id == selectedFarmAreaId,
                          orElse: () => FarmArea(id: 0, name: "Area"),
                        )
                        .name,
                    loading: () => "Memuat...",
                    error: (_, __) => "Error",
                  );
                }

                return GestureDetector(
                  onTap: () {
                    if (!isLocationSelected) {
                      SnackBarHelper.showInfo(
                        context,
                        "Pilih lokasi peternakan terlebih dahulu",
                      );
                      return;
                    }
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const FarmAreaBottomSheet(),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isLocationSelected
                          ? Colors.white
                          : AppColors.greyBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isLocationSelected
                            ? AppColors.fieldBorder
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: AppTypography.smallNormalBlack.copyWith(
                              color: isLocationSelected
                                  ? Colors.black
                                  : AppColors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: isLocationSelected
                              ? AppColors.grey
                              : AppColors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalList(List<AnimalProfile> animals, int total) {
    final hasMore = animals.length < total;

    return Column(
      children: [
        _filterRow(),
        const SizedBox(height: 12),

        Expanded(
          child: animals.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8.0,
                    children: [
                      Image.asset(
                        AppImages.icNoItem,
                        width: 250,
                        height: 250,
                        fit: BoxFit.fitWidth,
                      ),
                      Text(
                        "Belum Ada Data yang Tersedia",
                        style: AppTypography.mediumBoldBlack,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Belum ada sapi yang terdaftar pada kelas ini,\ntambahkan data atau ubah filter",
                          textAlign: TextAlign.center,
                          style: AppTypography.smallNormalWhite.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: animals.length + (hasMore ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == animals.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final e = animals[i];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => context.push('/product/${e.id}'),
                        child: ProductCard(
                          code: e.animalCode,
                          name: e.name,
                          gender: e.gender,
                          grade: e.animalGroup?.name ?? "-",
                          age: '${e.age} bulan',
                          weight: '${e.weight} kg',
                          price: 'Rp ${e.salesPrice}',
                          refSalesPriceTotal:
                              "Rp ${formatPrice(e.refSalesPriceTotal)}",
                          location: e.farmLocation?.name ?? "-",
                          status: e.available,
                          farmArea: e.farmArea,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAnimalClassList(List<AnimalClass> classes, int total) {
    final hasMore = classes.length < total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: classes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8.0,
                    children: [
                      Image.asset(
                        AppImages.icNoItem,
                        width: 250,
                        height: 250,
                        fit: BoxFit.fitWidth,
                      ),
                      Text(
                        "Belum Ada Data yang Tersedia",
                        style: AppTypography.mediumBoldBlack,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Belum ada sapi yang terdaftar pada kelas ini,\ntambahkan data atau ubah filter",
                          textAlign: TextAlign.center,
                          style: AppTypography.smallNormalWhite.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (_, i) {
                    final e = classes[i];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          _openProductGroupSheet(context, e.id);
                        },
                        child: ProductGradeCard(
                          grade: e.animalGroup.name,
                          weightRange: e.className,
                          total: '${e.total}',
                          available: '${e.available}',
                          sold: '${e.sold}',
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _filterGrade() {
    final selectedStatus = ref.watch(animalClassStatusProvider);
    final selectedLabel = classItems.firstWhere(
      (e) => e['value'] == selectedStatus,
    )['label']!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: DropdownButtonFormField2<String>(
              isExpanded: true,
              hint: Text(
                selectedLabel,
                style: AppTypography.smallNormalBlack,
                overflow: TextOverflow.ellipsis,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.fieldBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primaryDark,
                    width: 2.0,
                  ),
                ),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down),
              ),
              style: AppTypography.smallNormalBlack,
              items: classItems
                  .map(
                    (item) => DropdownItem<String>(
                      value: item['value']!,
                      child: Text(
                        item['label']!,
                        style: AppTypography.smallNormalBlack,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                ref.read(animalClassStatusProvider.notifier).state =
                    value ?? '';
              },
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openProductGroupSheet(BuildContext context, int id) {
    ref.read(selectedAnimalClassPriceIdProvider.notifier).state = id;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductGroupBottomSheet(),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryShade : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.smallNormalBlack.copyWith(
            color: selected ? AppColors.primary : AppColors.black,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
