import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/features/user/providers/user_provider.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/bottom_button.dart';
import '../../../../core/widgets/search_bar_card.dart';
import '../../data/model/sales_order_list_model.dart';
import '../../sales_order_provider.dart';
import '../widgets/sales_order_date_group_card.dart';

class SalesOrderPage extends ConsumerStatefulWidget {
  const SalesOrderPage({super.key});

  @override
  ConsumerState<SalesOrderPage> createState() => _SalesOrderPageState();
}

class _SalesOrderPageState extends ConsumerState<SalesOrderPage> {
  late final TextEditingController searchCtrl;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();
    Future.microtask(() {
      ref.read(salesOrderSearchProvider.notifier).state = '';
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    if (value.length < 2 && value.isNotEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(salesOrderSearchProvider.notifier).state = value;
    });
  }

  void _clearSearch() {
    searchCtrl.clear();
    _debounce?.cancel();
    ref.read(salesOrderSearchProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(salesOrderListProvider);
    final activeTab = ref.watch(salesOrderTabProvider);
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Penjualan", style: AppTypography.largeBoldBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Column(
        children: [
          SearchBarCard(
            hint: 'Cari Penjualan',
            controller: searchCtrl,
            onChanged: _onSearchChanged,
            onClear: _clearSearch,
          ),

          /// 🔥 TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _tabItem(SalesOrderTab.all, activeTab),
                  const SizedBox(width: 8),
                  _tabItem(SalesOrderTab.draft, activeTab),
                  const SizedBox(width: 8),
                  _tabItem(SalesOrderTab.confirmed, activeTab),
                  const SizedBox(width: 8),
                  _tabItem(SalesOrderTab.closed, activeTab),
                  const SizedBox(width: 8),
                  _tabItem(SalesOrderTab.canceled, activeTab),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.refresh(salesOrderListProvider.future);
              },
              child: dataAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Terjadi Error:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(err.toString()),
                        const SizedBox(height: 16),
                        const Text(
                          "Stacktrace:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(stack.toString()),
                      ],
                    ),
                  );
                },
                data: (list) => _SalesOrderList(list),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          userAsync.value?.hasPermission('salesorder-create') ?? false
          ? BottomButton(
              text: 'Tambah Penjualan',
              onPressed: () {
                showSalesTypeBottomSheet(context);
              },
            )
          : null,
    );
  }

  Widget _tabItem(SalesOrderTab value, SalesOrderTab active) {
    final isActive = value == active;

    return GestureDetector(
      onTap: () {
        ref.read(salesOrderTabProvider.notifier).state = value;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryShade : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        child: Text(
          value.label,
          style: AppTypography.smallNormalPrimary.copyWith(
            color: isActive ? AppColors.primary : AppColors.black,
          ),
        ),
      ),
    );
  }

  void showSalesTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pilih Penjualan',
                    style: AppTypography.largeBoldBlack,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.iconColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.close_rounded, size: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Hewan
              _SalesTypeItem(
                title: 'Hewan',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/sales-order/add?type=animal');
                },
              ),

              const SizedBox(height: 12),

              /// Pakan / Obat
              _SalesTypeItem(
                title: 'Pakan',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/sales-order/add?type=feed');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SalesOrderList extends StatelessWidget {
  final List<SalesOrderList> list;

  const _SalesOrderList(this.list);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
          children: [
            Image.asset(
              AppImages.icEmptyDefault,
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
                "Tambahkan data baru atau sesuaikan filter untuk\nmelihat informasi di kategori ini",
                textAlign: TextAlign.center,
                style: AppTypography.smallNormalWhite.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final Map<String, List<SalesOrderList>> grouped = {};

    for (final item in list) {
      grouped.putIfAbsent(item.orderDate, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) {
        return SalesOrderDateGroupCard(
          dateLabel: entry.key,
          items: entry.value,
        );
      }).toList(),
    );
  }
}

class _SalesTypeItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SalesTypeItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: AppTypography.mediumBoldBlack.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
