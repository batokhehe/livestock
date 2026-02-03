import 'package:flutter/material.dart';
import 'package:livestock/features/home/presentation/widgets/product_item_card.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return const ProductCardItem(
            title: "Black 001 - Sapi Besar",
            status: "Berhasil dijual",
            weight: "250.00kg",
            grade: "Kelas A",
            price: "Rp 38.000.000",
          );
        },
      ),
    );
  }
}
