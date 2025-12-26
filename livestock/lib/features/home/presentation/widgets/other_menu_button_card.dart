import 'package:flutter/material.dart';

import '../../../../core/theme/AppColors.dart';

class OtherMenuButton extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback? onTap; // 🔥 tambah ini

  const OtherMenuButton(this.image, this.label, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // 🔥 handle tap
      borderRadius: BorderRadius.circular(8),
      child: Container(
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
      ),
    );
  }
}
