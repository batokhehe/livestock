import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/bottom_button.dart';
import '../../../../core/widgets/search_bar_card.dart';
import '../../data/model/purchase_order_list_model.dart';
import '../../purchase_order_provider.dart';
import '../widgets/purchase_order_date_group_card.dart';

class PurchaseOrderPage extends ConsumerStatefulWidget {
  const PurchaseOrderPage({super.key});

  @override
  ConsumerState<PurchaseOrderPage> createState() => _PurchaseOrderPageState();
}

class _PurchaseOrderPageState extends ConsumerState<PurchaseOrderPage> {
  final searchCtrl = TextEditingController();
  final scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    searchCtrl.addListener(() {
      final value = searchCtrl.text;
      // Hit API only if empty (clear) or >= 2 chars
      if (value.isEmpty || value.length >= 2) {
        ref.read(purchaseOrderSearchProvider.notifier).state = value;
      }
    });

    scrollCtrl.addListener(() {
      if (scrollCtrl.position.pixels >=
          scrollCtrl.position.maxScrollExtent - 200) {
        ref.read(purchaseOrderListProvider.notifier).fetch();
      }
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(purchaseOrderListProvider);
    final activeTab = ref.watch(purchaseOrderTabProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Pembelian", style: AppTypography.largeBoldBlack),
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
          SearchBarCard(hint: 'Cari Pembelian', controller: searchCtrl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _tabItem(PurchaseOrderTab.animal, activeTab),
                const SizedBox(width: 8),
                _tabItem(PurchaseOrderTab.feed, activeTab),
                const SizedBox(width: 8),
                _tabItem(PurchaseOrderTab.equipment, activeTab),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(purchaseOrderListProvider.notifier).refresh();
              },
              child: dataAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                data: (list) => _PurchaseOrderList(list, scrollCtrl: scrollCtrl),
              ),
            ),
          ),
          BottomButton(
            text: 'Tambah Pembelian',
            onPressed: () {
              context.push('/purchase-order/add?type=${activeTab.apiValue}');
            },
          ),
        ],
      ),
    );
  }

  Widget _tabItem(PurchaseOrderTab value, PurchaseOrderTab active) {
    final isActive = value == active;

    return GestureDetector(
      onTap: () {
        ref.read(purchaseOrderTabProvider.notifier).state = value;
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
}

class _PurchaseOrderList extends ConsumerWidget {
  final List<PurchaseOrderList> list;
  final ScrollController scrollCtrl;

  const _PurchaseOrderList(this.list, {required this.scrollCtrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (list.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
        ),
      );
    }

    final Map<String, List<PurchaseOrderList>> grouped = {};

    for (final item in list) {
      grouped.putIfAbsent(item.purchDate.toString(), () => []).add(item);
    }

    final isLoadingMore =
        ref.watch(purchaseOrderListProvider.notifier).isLoadingMore;

    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        ...grouped.entries.map((entry) {
          return PurchaseOrderDateGroupCard(
            dateLabel: entry.key,
            items: entry.value,
          );
        }),
        if (isLoadingMore)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
