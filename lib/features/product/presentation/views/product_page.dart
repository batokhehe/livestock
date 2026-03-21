import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/features/product/data/product_tab.dart';
import 'package:livestock/core/data/model/farm_location_model.dart';
import 'package:livestock/core/data/model/farm_area_model.dart';
import 'package:livestock/features/product/presentation/widgets/product_card.dart';
import 'package:livestock/features/product/presentation/widgets/product_grade_card.dart';

import '../../../../app/providers.dart';
import '../../../../core/data/model/animal_class_model.dart';
import '../../../../core/data/model/animal_profile_model.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../data/product_provider_tab.dart';

import '../widgets/product_group_bottom_sheet.dart';
import '../../../../core/helpers/utils.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ProductPage> createState() => _ProductPage();
}

class _ProductPage extends ConsumerState<ProductPage> {
  late final TextEditingController searchCtrl;
  Timer? _debounce;

  final statusItems = [
    {'value': '', 'label': 'Semua Status'},
    {'value': 'active', 'label': 'Aktif'},
    {'value': 'inactive', 'label': 'Nonaktif'},
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
    ref.read(animalSearchProvider.notifier).state = '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    super.dispose();
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error $error")),
        data: (data) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _searchBar(),
                const SizedBox(height: 12),
                _tabMenu(ref, tab),
                const SizedBox(height: 12),

                Expanded(
                  child: tab == ProductTab.product
                      ? _buildAnimalList(data as List<AnimalProfile>)
                      : _buildAnimalClassList(data as List<AnimalClass>),
                ),
              ],
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
        hintText: "Cari Apapun",
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
          label: "Data Kelas",
          selected: tab == ProductTab.grade,
          onTap: () =>
              ref.read(productTabProvider.notifier).state = ProductTab.grade,
        ),
      ],
    );
  }

  Widget _filterRow() {
    final selectedStatus = ref.watch(animalStatusProvider);
    final selectedLabel = statusItems.firstWhere(
      (e) => e['value'] == selectedStatus,
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
              items: statusItems
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
                ref.read(animalStatusProvider.notifier).state = value ?? '';
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
            child: farmLocationsAsync.when(
              loading: () => const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, __) => const Text('Error'),
              data: (farmLocations) {
                final selectedLocationLabel = selectedFarmLocationId == null
                    ? 'Semua Lokasi'
                    : farmLocations
                          .firstWhere(
                            (e) => e.id == selectedFarmLocationId,
                            orElse: () =>
                                FarmLocation(id: 0, name: 'Semua Lokasi'),
                          )
                          .name;

                return DropdownButtonFormField2<String>(
                  isExpanded: true,
                  hint: Text(
                    selectedLocationLabel,
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
                  items: [
                    DropdownItem<String>(
                      value: '',
                      child: Text(
                        'Semua Lokasi',
                        style: AppTypography.smallNormalBlack,
                      ),
                    ),
                    ...farmLocations.map(
                      (loc) => DropdownItem<String>(
                        value: loc.id.toString(),
                        child: Text(
                          loc.name,
                          style: AppTypography.smallNormalBlack,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    ref
                        .read(animalFarmLocationIdProvider.notifier)
                        .state = (value == null || value.isEmpty)
                        ? null
                        : int.tryParse(value);
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
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 170,
            child: farmAreasAsync.when(
              loading: () => const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, __) => const Text('Error'),
              data: (farmAreas) {
                final selectedAreaLabel = selectedFarmAreaId == null
                    ? 'Semua Area'
                    : farmAreas
                          .firstWhere(
                            (e) => e.id == selectedFarmAreaId,
                            orElse: () => FarmArea(id: 0, name: 'Semua Area'),
                          )
                          .name;

                return DropdownButtonFormField2<String>(
                  isExpanded: true,
                  hint: Text(
                    selectedAreaLabel,
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
                  items: [
                    DropdownItem<String>(
                      value: '',
                      child: Text(
                        'Semua Area',
                        style: AppTypography.smallNormalBlack,
                      ),
                    ),
                    ...farmAreas.map(
                      (area) => DropdownItem<String>(
                        value: area.id.toString(),
                        child: Text(
                          area.name,
                          style: AppTypography.smallNormalBlack,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    ref
                        .read(animalFarmAreaIdProvider.notifier)
                        .state = (value == null || value.isEmpty)
                        ? null
                        : int.tryParse(value);
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalList(List<AnimalProfile> animals) {
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
                  itemCount: animals.length,
                  itemBuilder: (_, i) {
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
                          status: e.status,
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

  Widget _buildAnimalClassList(List<AnimalClass> classes) {
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
