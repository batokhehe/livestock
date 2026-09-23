import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../features/purchase_order/purchase_order_provider.dart';
import '../../features/supplier/presentation/views/add_supplier_page.dart';
import '../data/model/supplier_model.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';
import 'dart:async';

class SupplierPaginatedBottomSheet extends ConsumerStatefulWidget {
  final String? type;
  const SupplierPaginatedBottomSheet({super.key, this.type});

  @override
  ConsumerState<SupplierPaginatedBottomSheet> createState() =>
      _SupplierPaginatedBottomSheetState();
}

class _SupplierPaginatedBottomSheetState
    extends ConsumerState<SupplierPaginatedBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String? _selectedType;

  static String? _mapType(String? type) {
    if (type == null || type.isEmpty) return null;
    final t = type.toLowerCase();
    if (t.contains('hewan') || t.contains('animal')) return 'Hewan';
    if (t.contains('pakan') || t.contains('feed')) return 'Pakan';
    if (t.contains('obat') || t.contains('med')) return 'Obat';
    if (t.contains('lain') ||
        t.contains('equip') ||
        t.contains('peralatan') ||
        t.contains('other')) {
      return 'Lainnya';
    }
    return type;
  }

  @override
  void initState() {
    super.initState();
    _selectedType = _mapType(widget.type);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(supplierSearchProvider.notifier).state = '';
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(paginatedSupplierProvider(_selectedType).notifier).loadMore();
      }
    });
  }

  @override
  void didUpdateWidget(covariant SupplierPaginatedBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type) {
      setState(() {
        _selectedType = _mapType(widget.type);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _navigateToAddSupplier() async {
    final newSupplier = await Navigator.push<Supplier>(
      context,
      MaterialPageRoute(
        builder: (_) => AddSupplierPage(initialType: _selectedType),
      ),
    );

    if (newSupplier != null && mounted) {
      ref.invalidate(paginatedSupplierProvider(_selectedType));
      Navigator.pop(context, newSupplier);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(paginatedSupplierProvider(_selectedType));
    final form = ref.watch(purchaseOrderFormProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Pilih Pemasok", style: AppTypography.largeBoldBlack),
              OutlinedButton.icon(
                onPressed: _navigateToAddSupplier,
                icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                label: const Text(
                  "Tambah",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Silakan cari dan pilih pemasok untuk pesanan pembelian ini.",
            style: AppTypography.smallNormalGrey,
          ),
          const SizedBox(height: 20),

          // SEARCH BAR
          TextField(
            controller: _searchController,
            onChanged: (val) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                ref.read(supplierSearchProvider.notifier).state = val;
              });
            },
            decoration: InputDecoration(
              hintText: "Cari nama pemasok...",
              hintStyle: AppTypography.smallNormalGrey,
              prefixIcon: const Icon(Icons.search, color: AppColors.grey),
              filled: true,
              fillColor: AppColors.greyBg,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: asyncData.when(
              data: (res) {
                final items = res.data;
                final total = res.total ?? 0;
                final hasMore = items.length < total;

                if (items.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.business_outlined,
                            size: 48,
                            color: AppColors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _selectedType != null && _selectedType!.isNotEmpty
                                ? "Pemasok $_selectedType tidak ditemukan"
                                : "Pemasok tidak ditemukan",
                            style: AppTypography.smallNormalGrey,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _navigateToAddSupplier,
                            icon: const Icon(Icons.add, size: 16, color: Colors.white),
                            label: const Text(
                              "Tambah Pemasok Baru",
                              style: AppTypography.smallBoldWhite,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: items.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final supplier = items[index];
                    final isSelected = form.supplier?.id == supplier.id;

                    return GestureDetector(
                      onTap: () => Navigator.pop(context, supplier),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.fieldBorder,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(
                                0.1,
                              ),
                              child: const Icon(
                                Icons.business,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          supplier.name,
                                          style: AppTypography.smallBoldBlack,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (supplier.tipePemasok.isNotEmpty &&
                                          supplier.tipePemasok != '-') ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryShade,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            supplier.tipePemasok,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    supplier.contactPhone,
                                    style: AppTypography.xSmallNormalGrey,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
