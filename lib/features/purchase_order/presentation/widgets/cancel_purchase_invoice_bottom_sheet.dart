import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/chart_of_account_model.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/features/purchase_order/presentation/views/create_invoice/purchase_invoice_provider.dart';

class CancelPurchaseInvoiceBottomSheet extends ConsumerStatefulWidget {
  final Function(ChartOfAccount?) onConfirm;

  const CancelPurchaseInvoiceBottomSheet({super.key, required this.onConfirm});

  @override
  ConsumerState<CancelPurchaseInvoiceBottomSheet> createState() =>
      _CancelPurchaseInvoiceBottomSheetState();
}

class _CancelPurchaseInvoiceBottomSheetState
    extends ConsumerState<CancelPurchaseInvoiceBottomSheet> {
  String _searchQuery = '';
  ChartOfAccount? _selectedAccount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tandai Nota Pembelian Sebagai Dibatalkan",
                style: AppTypography.mediumBoldBlack,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Apakah Anda yakin ingin menandai Nota Pembelian ini sebagai dibatalkan? Tindakan ini tidak dapat dibatalkan.",
                style: AppTypography.smallNormalBlack,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 24),
              const Text(
                "Pilih Akun Keuangan Pembalik",
                style: AppTypography.mediumBoldBlack,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Cari akun...",
                  prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.fieldBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.fieldBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ref
                    .watch(purchaseChartOfAccountListProvider)
                    .when(
                      data: (accounts) {
                        final filtered = accounts
                            .where(
                              (acc) =>
                                  acc.name.toLowerCase().contains(
                                    _searchQuery.toLowerCase(),
                                  ) ||
                                  acc.code.toLowerCase().contains(
                                    _searchQuery.toLowerCase(),
                                  ),
                            )
                            .toList();

                        if (filtered.isEmpty) {
                          return const Center(
                            child: Text(
                              "Tidak ada akun ditemukan",
                              style: AppTypography.smallNormalGrey,
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final account = filtered[index];
                            final isSelected =
                                _selectedAccount?.id == account.id;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedAccount = account;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.fieldBorder.withValues(
                                            alpha: 0.5,
                                          ),
                                    width: isSelected ? 1.5 : 1.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${account.code} - ${account.name}",
                                        style: AppTypography.smallBoldBlack
                                            .copyWith(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : null,
                                            ),
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Center(child: Text("Error: $e")),
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.fieldBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Batal",
                        style: AppTypography.smallBoldBlack,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedAccount != null
                          ? () {
                              Navigator.pop(context);
                              widget.onConfirm(_selectedAccount);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        disabledBackgroundColor: AppColors.fieldBorder,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Batalkan Nota",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
