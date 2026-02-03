import 'package:flutter/material.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class OperationalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final List<Widget> children;

  const OperationalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.smallNormalBlack),
                      Text(subtitle, style: AppTypography.smallNormalGrey),
                    ],
                  ),
                ),
                _badge(value),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          const SizedBox(height: 12),
          ...children,
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _badge(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(value, style: AppTypography.smallBoldBlack),
    );
  }
}
