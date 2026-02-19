import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/product/presentation/widgets/product_card.dart';

import '../../../../app/providers.dart';
import '../../../../core/theme/AppColors.dart';

class ProductGroupBottomSheet extends ConsumerWidget {
  const ProductGroupBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(animalListByClassProvider);

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
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              const SizedBox(height: 12),

              /// HEADER
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

              const SizedBox(height: 12),

              /// LIST DATA
              Expanded(
                child: dataAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Error: $e")),
                  data: (animals) {
                    if (animals.isEmpty) {
                      return const Center(child: Text("Data tidak ditemukan"));
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: animals.length,
                      itemBuilder: (_, i) {
                        final e = animals[i];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProductCard(
                            code: e.animalCode,
                            name: e.name,
                            gender: e.gender,
                            grade: e.animalGroup?.name ?? "-",
                            age: '${e.age} bulan',
                            weight: '${e.weight} kg',
                            price: 'Rp ${e.salesPrice}',
                            location: e.farmLocation?.name ?? "-",
                            status: e.status,
                          ),
                        );
                      },
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
