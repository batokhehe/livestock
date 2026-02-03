import 'package:flutter/material.dart';

import '../../../../core/theme/AppTypography.dart';

class OperationalItemCard extends StatelessWidget {
  final String label;
  final String value;

  const OperationalItemCard(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.smallNormalGrey),
          Text(value, style: AppTypography.smallBoldBlack),
        ],
      ),
    );
  }
}
