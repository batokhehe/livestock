import 'package:flutter/material.dart';

import '../../../../core/theme/AppColors.dart';

class OtherMenuButton extends StatelessWidget {
  final String image;
  final String label;

  const OtherMenuButton(this.image, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        children: [
          Image.asset(image),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
