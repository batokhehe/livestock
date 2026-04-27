import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/sales_order/sales_order_provider.dart';
import '../../app/providers.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';
import 'dart:async';

class CustomerPaginatedBottomSheet extends ConsumerStatefulWidget {
  final String? status;
  const CustomerPaginatedBottomSheet({super.key, this.status});

  @override
  ConsumerState<CustomerPaginatedBottomSheet> createState() =>
      _CustomerPaginatedBottomSheetState();
}

class _CustomerPaginatedBottomSheetState
    extends ConsumerState<CustomerPaginatedBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customerStatusProvider.notifier).state = widget.status ?? '';
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(paginatedCustomerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(paginatedCustomerProvider);
    final form = ref.watch(salesOrderFormProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text("Pilih Pelanggan", style: AppTypography.largeBoldBlack),
          const SizedBox(height: 8),
          const Text(
            "Silakan cari dan pilih pelanggan untuk pesanan penjualan ini.",
            style: AppTypography.smallNormalGrey,
          ),
          const SizedBox(height: 20),

          // SEARCH BAR
          TextField(
            onChanged: (val) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                ref.read(customerSearchProvider.notifier).state = val;
              });
            },
            decoration: InputDecoration(
              hintText: "Cari nama atau nomor telepon...",
              hintStyle: AppTypography.smallNormalGrey,
              prefixIcon: const Icon(Icons.search, color: AppColors.grey),
              filled: true,
              fillColor: AppColors.greyBg,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: asyncData.when(
              data: (res) {
                final items = res.data;
                final total = res.total ?? 0;
                final hasMore = items.length < total;

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Pelanggan tidak ditemukan",
                      style: AppTypography.smallNormalGrey,
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: items.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final customer = items[index];
                    final isSelected = form.customer?.id == customer.id;

                    return GestureDetector(
                      onTap: () => Navigator.pop(context, customer),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.fieldBorder,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(
                                0.1,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer.name,
                                    style: AppTypography.smallBoldBlack,
                                  ),
                                  Text(
                                    customer.contactPhone ?? "-",
                                    style: AppTypography.xSmallNormalGrey,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
