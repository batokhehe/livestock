import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/app/providers.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/widgets/search_bar_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/product_header_card.dart';
import '../../../../core/widgets/two_column_row_card.dart';
import '../../data/model/sales_order_dispatch_model.dart';
import '../../dispatch_provider.dart';

class AddItemBottomSheet extends ConsumerStatefulWidget {
  const AddItemBottomSheet({super.key});

  @override
  ConsumerState<AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends ConsumerState<AddItemBottomSheet> {
  late final TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(soListProvider);
    final selectedItem = ref.watch(selectedSoProvider);
    final activeTab = ref.watch(dispatchSoTabProvider);

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          "Gagal memuat data penjualan\n$error",
          textAlign: TextAlign.center,
          style: AppTypography.smallNormalGrey,
        ),
      ),
      data: (d) {
        final list = d;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ===== HEADER =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pilih Hewan", style: AppTypography.mediumBoldBlack),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              // ===== SEARCH =====
              SearchBarCard(
                hint: "Cari hewan",
                controller: searchCtrl,
                onChanged: (value) {
                  ref.read(soSearchProvider.notifier).onSearchChanged(value);
                },
                onClear: () {
                  ref.read(soSearchProvider.notifier).onSearchChanged('');
                },
                resetPadding: true,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _tabItem(ref, DispatchSOTab.all, activeTab),
                  const SizedBox(width: 8),
                  _tabItem(ref, DispatchSOTab.paid, activeTab),
                  const SizedBox(width: 8),
                  _tabItem(ref, DispatchSOTab.unpaid, activeTab),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Text(
                          "Hewan tidak ditemukan",
                          style: AppTypography.smallNormalGrey,
                        ),
                      )
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final e = list[i];
                          final isSelected = selectedItem?.id == e.id;

                          return GestureDetector(
                            onTap: () {
                              ref.read(selectedSoProvider.notifier).state = e;
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.fieldBorder,
                                ),
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.08)
                                    : Colors.white,
                              ),
                              child: Column(
                                children: [
                                  ProductHeaderCard(
                                    title: e.items.first.itemName,
                                    subtitle: e.orderId,
                                    image: AppImages.icProduct,
                                    isActive: e.state == "active",
                                  ),
                                  const SizedBox(height: 12),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: AppColors.fieldBorder,
                                  ),
                                  TwoColumnRowCard(
                                    leftValue: e.items.first.city,
                                    leftLabel: "Kota Tujuan",
                                    rightValue: e.items.first.dlvDate,
                                    rightLabel: "Tanggal Kirim",
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: AppColors.fieldBorder,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsGeometry.fromLTRB(
                                      0,
                                      16,
                                      0,
                                      0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Biaya Kirim",
                                          style: AppTypography.smallNormalGrey,
                                        ),
                                        Text(
                                          "Rp ${formatPrice(e.items.first.shippingCost as num)}",
                                          style:
                                              AppTypography.mediumBoldPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 24),

              // ===== BUTTON =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedItem != null
                        ? AppColors.primary
                        : AppColors.greyBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: selectedItem == null
                      ? null
                      : () => Navigator.pop(
                          context,
                          selectedItem.items.first.toDispatchRequest(
                            recipientName: selectedItem.recipientName,
                            recipientNumber: selectedItem.recipientNumber,
                            orderId: selectedItem.orderId,
                          ),
                        ),
                  child: const Text(
                    "Simpan",
                    style: AppTypography.mediumBoldWhite,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tabItem(WidgetRef ref, DispatchSOTab value, DispatchSOTab active) {
    final isActive = value == active;

    return GestureDetector(
      onTap: () {
        ref.read(dispatchSoTabProvider.notifier).state = value;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryShade : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        child: Text(
          value.label,
          style: AppTypography.smallNormalPrimary.copyWith(
            color: isActive ? AppColors.primary : AppColors.black,
          ),
        ),
      ),
    );
  }
}
