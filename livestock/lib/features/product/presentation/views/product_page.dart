import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/product/data/product_tab.dart';
import 'package:livestock/features/product/presentation/views/product_grade_view.dart';
import 'package:livestock/features/product/presentation/widgets/product_card.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../data/product_provider_tab.dart';
import '../widgets/filter_dropdown.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(productTabProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text("Hewan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _searchBar(),
            const SizedBox(height: 12),
            _tabMenu(ref, tab),
            const SizedBox(height: 12),
            if (tab == ProductTab.product) ...[
              _filterRow(),
              const SizedBox(height: 16),
              ...List.generate(
                5,
                (index) => InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    context.push('/product/0001');
                  },
                  child: const ProductCard(
                    code: "0001",
                    name: "Black Mamba",
                    gender: "Jantan",
                    grade: "Kelas A",
                    age: "14 Bulan",
                    weight: "315 kg",
                    price: "Rp 23.000.000",
                    location: "Sapi Agri Banter",
                    status: "Aktif",
                  ),
                ),
              ),
            ] else ...[
              const ProductGradeView(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
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
