import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/features/home/presentation/providers/home_provider.dart';
import 'package:livestock/features/home/presentation/widgets/product_item_card.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestSOAsync = ref.watch(latestSalesOrderProvider);

    return SizedBox(
      height: 150,
      child: latestSOAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Gagal memuat data: $err")),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("Belum ada transaksi"));
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = list[index];

              final Color statusColor;
              final Color backgroundColor;
              final String statusText;
              switch (item.salesStatus) {
                case 'draft':
                  statusColor = AppColors.primaryDark;
                  backgroundColor = AppColors.bgColorShadeAwareness;
                  statusText = 'Draft';
                  break;
                case 'confirmed':
                  statusColor = AppColors.emerald700;
                  backgroundColor = AppColors.bgColorShadeSuccessFull;
                  statusText = 'Terkonfirmasi';
                  break;
                case 'closed':
                  statusColor = AppColors.emerald700;
                  backgroundColor = AppColors.emerald200;
                  statusText = 'Selesai';
                  break;
                default:
                  statusColor = AppColors.danger;
                  backgroundColor = AppColors.bgColorShadeError;
                  statusText = 'Batal';
              }

              return ProductCardItem(
                title: item.orderId, //Nomer Sales Order
                status: statusText, // Status Sales Order
                weight: "${item.items.length} Hewan", // Jumlah Hewan
                grade: item.customerName, // Nama Pembeli
                price: "Rp ${formatPrice(item.amountTotal)}", // Total Harga
                statusColor: statusColor,
                statusBgColor: backgroundColor,
              );
            },
          );
        },
      ),
    );
  }
}
