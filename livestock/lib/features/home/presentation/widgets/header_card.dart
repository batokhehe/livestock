import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../user/providers/user_provider.dart';

class HeaderCard extends ConsumerWidget {
  const HeaderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Halo, $userName 👋", style: AppTypography.largeBoldBlack),
                const SizedBox(height: 4),
                const Text(
                  "Selamat datang kembali di Livestock.",
                  style: AppTypography.smallNormalGrey,
                ),
              ],
            ),
          ),
          Image.asset(AppImages.logo, width: 75),
        ],
      ),
    );
  }
}
