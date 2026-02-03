import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/features/home/presentation/widgets/header_card.dart';
import 'package:livestock/features/home/presentation/widgets/product_card.dart';
import 'package:livestock/features/home/presentation/widgets/swipe_indicator.dart';

import '../widgets/other_menu_card.dart';
import '../widgets/quick_menu_card.dart';
import '../widgets/stock_card.dart';
import '../widgets/summary_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HeaderCard(),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Column(
                  children: [
                    SummaryCard(),
                    SizedBox(height: 16),
                    ProductCard(),
                    SizedBox(height: 8),
                    SwipeIndicator(),
                    SizedBox(height: 16),
                    StockCard(),
                    SizedBox(height: 20),
                    QuickMenu(),
                    SizedBox(height: 20),
                    OtherMenu(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
