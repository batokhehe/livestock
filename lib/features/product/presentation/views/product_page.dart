import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/product/data/product_tab.dart';
import 'package:livestock/features/product/presentation/views/product_grade_view.dart';
import 'package:livestock/features/product/presentation/widgets/product_card.dart';

import '../../../../app/providers.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../data/product_provider_tab.dart';
import '../widgets/filter_dropdown.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ProductPage> createState() => _ProductPage();
}

class _ProductPage extends ConsumerState<ProductPage> {
  late final TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();
    ref.read(animalSearchProvider.notifier).state = '';
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(productTabProvider);
    final dataAsync = ref.watch(animalListProvider);
    final keyword = ref.watch(animalSearchProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Hewan", style: AppTypography.largeBoldBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            "Gagal memuat data hewan\n$error",
            textAlign: TextAlign.center,
            style: AppTypography.smallNormalGrey,
          ),
        ),
        data: (d) {
          final filtered = keyword.trim().isEmpty
              ? d
              : d.where((e) {
                  return e.name.toLowerCase().contains(keyword.toLowerCase()) ||
                      e.animalCode.toLowerCase().contains(
                        keyword.toLowerCase(),
                      );
                }).toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _searchBar(),
                const SizedBox(height: 12),
                _tabMenu(ref, tab),
                const SizedBox(height: 12),

                /// ============================
                /// PRODUCT TAB
                /// ============================
                if (tab == ProductTab.product) ...[
                  _filterRow(),
                  const SizedBox(height: 16),

                  if (filtered.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          "Data tidak ditemukan",
                          style: AppTypography.smallNormalGrey,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final e = filtered[i];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                context.push('/product/${e.id}');
                              },
                              child: ProductCard(
                                code: e.animalCode,
                                name: e.name,
                                gender: e.gender,
                                grade: e.animalGroup?.name ?? "-",
                                age: '${e.age.toString()} bulan',
                                weight: '${e.weight.toString()} kg',
                                price: 'Rp ${e.salesPrice.toString()}',
                                location: e.farmLocation?.name ?? "-",
                                status:
                                    e.status[0].toUpperCase() +
                                    e.status.substring(1),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ]
                /// ============================
                /// GRADE TAB
                /// ============================
                else ...[
                  const Expanded(child: ProductGradeView()),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      controller: searchCtrl,
      onChanged: (value) {
        ref.read(animalSearchProvider.notifier).state = value;
      },
      decoration: InputDecoration(
        hintText: "Cari Apapun",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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
    return Row(
      children: const [
        FilterDropdown(label: "Semua Status"),
        SizedBox(width: 8),
        FilterDropdown(label: "Lokasi"),
      ],
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
          ),
        ),
      ),
    );
  }
}
