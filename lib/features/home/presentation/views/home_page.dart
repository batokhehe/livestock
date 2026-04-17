import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/features/home/presentation/widgets/header_card.dart';
import 'package:livestock/features/home/presentation/widgets/product_card.dart';
import 'package:livestock/features/home/presentation/widgets/swipe_indicator.dart';
import 'package:livestock/features/user/providers/user_provider.dart';

import '../widgets/other_menu_card.dart';
import '../widgets/quick_menu_card.dart';
import '../widgets/stock_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final hasProductRead =
        userAsync.value?.hasPermission('animalprofile-read') ?? false;
    final hasStockRead =
        userAsync.value?.hasPermission('equipmentandsupplies-read') ?? false;

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderCard(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SummaryCard(),
                    // SizedBox(height: 16),
                    if (hasProductRead) ...[
                      const SizedBox(height: 16),
                      const ProductCard(),
                    ],
                    const SizedBox(height: 8),
                    const SwipeIndicator(),
                    if (hasStockRead) ...[
                      const SizedBox(height: 16),
                      const StockCard(),
                    ],
                    const SizedBox(height: 20),
                    const QuickMenu(),
                    const SizedBox(height: 20),
                    const OtherMenu(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
