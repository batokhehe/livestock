import 'package:flutter/material.dart';
import 'package:livestock/core/helpers/maintenance_helper.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/features/home/presentation/widgets/header_card.dart';
import 'package:livestock/features/home/presentation/widgets/product_card.dart';
import 'package:livestock/features/home/presentation/widgets/swipe_indicator.dart';

import '../widgets/other_menu_card.dart';
import '../widgets/quick_menu_card.dart';
import '../widgets/stock_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderCard(),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          MaintenanceHelper.showMaintenanceSnackBar(context),
                      child: const Opacity(
                        opacity: 0.6,
                        child: IgnorePointer(child: ProductCard()),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Opacity(opacity: 0.5, child: SwipeIndicator()),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () =>
                          MaintenanceHelper.showMaintenanceSnackBar(context),
                      child: const Opacity(
                        opacity: 0.6,
                        child: IgnorePointer(child: StockCard()),
                      ),
                    ),
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

