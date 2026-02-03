import 'package:flutter/material.dart';
import 'package:livestock/features/product/presentation/widgets/product_card.dart';

import '../../../../core/theme/AppColors.dart';

class ProductGroupBottomSheet extends StatelessWidget {
  const ProductGroupBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),

              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              const SizedBox(height: 12),

              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Grup hewan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // SEARCH
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Cari Hewan",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // FILTER CHIP
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    _StatusChip(text: "Semua Status", selected: true),
                    SizedBox(width: 8),
                    _StatusChip(text: "Tersedia"),
                    SizedBox(width: 8),
                    _StatusChip(text: "Terjual"),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // LIST
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 5,
                  itemBuilder: (_, i) {
                    return ProductCard(
                      code: "0001",
                      name: "Black Mamba",
                      gender: "Jantan",
                      grade: "Kelas A",
                      age: "14 Bulan",
                      weight: "315 kg",
                      price: "Rp 23.000.000",
                      location: "Sapi Agri Banten",
                      status: "Aktif",
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final bool selected;

  const _StatusChip({required this.text, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryShade : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.black,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: selected ? AppColors.primary : AppColors.black,

        ),
      ),
    );
  }
}
