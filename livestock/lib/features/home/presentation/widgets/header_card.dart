import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/theme/AppColors.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
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
              children: const [
                Text(
                  "Halo, Ari Wibowo 👋",
                  style: AppTypography.largeBoldBlack,
                ),
                SizedBox(height: 4),
                Text(
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
