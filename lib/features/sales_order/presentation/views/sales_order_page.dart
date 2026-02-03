import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/bottom_button.dart';
import '../../../../core/widgets/search_bar_card.dart';
import '../../data/model/sales_order_list_model.dart';
import '../../sales_order_provider.dart';
import '../widgets/sales_order_date_group_card.dart';

class SalesOrderPage extends ConsumerWidget {
  const SalesOrderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(salesOrderListProvider);
    final searchCtrl = TextEditingController();
    final activeTab = ref.watch(salesOrderTabProvider);

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
          SearchBarCard(hint: 'Cari Apapun', controller: searchCtrl),

          /// 🔥 TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _tabItem(ref, SalesOrderTab.all, activeTab),
                const SizedBox(width: 8),
                _tabItem(ref, SalesOrderTab.sell, activeTab),
                const SizedBox(width: 8),
                _tabItem(ref, SalesOrderTab.confirmed, activeTab),
                const SizedBox(width: 8),
                _tabItem(ref, SalesOrderTab.closed, activeTab),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(salesOrderListProvider);
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
          BottomButton(
            text: 'Tambah Penjualan',
            onPressed: () {
              showSalesTypeBottomSheet(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _tabItem(WidgetRef ref, SalesOrderTab value, SalesOrderTab active) {
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
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
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
                title: 'Pakan/Obat',
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
      return const Center(child: Text("Data kosong"));
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
        child: Center(
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
