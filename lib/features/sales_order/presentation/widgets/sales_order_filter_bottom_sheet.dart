import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import '../../sales_order_provider.dart';

class SalesOrderFilterBottomSheet extends ConsumerStatefulWidget {
  const SalesOrderFilterBottomSheet({super.key});

  @override
  ConsumerState<SalesOrderFilterBottomSheet> createState() =>
      _SalesOrderFilterBottomSheetState();
}

class _SalesOrderFilterBottomSheetState
    extends ConsumerState<SalesOrderFilterBottomSheet> {
  SalesOrderTab? _tempSalesOrderTab;
  SalesInvoiceFilter? _tempSalesInvoiceFilter;

  @override
  void initState() {
    super.initState();
    _tempSalesOrderTab = ref.read(salesOrderTabProvider);
    _tempSalesInvoiceFilter = ref.read(salesInvoiceFilterProvider);
  }

  @override
  Widget build(BuildContext context) {
    final mainTab = ref.watch(salesOrderMainTabProvider);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 22,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(mainTab),
          const SizedBox(height: 24),
          if (mainTab == SalesOrderMainTab.penjualan)
            _salesOrderFilters()
          else
            _salesInvoiceFilters(),
          const SizedBox(height: 32),
          _actions(mainTab),
        ],
      ),
    );
  }

  Widget _header(SalesOrderMainTab mainTab) {
    final title = mainTab == SalesOrderMainTab.penjualan ? "Filter Penjualan" : "Filter Nota";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.mediumBoldBlack),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _salesOrderFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: SalesOrderTab.values.map((tab) {
        final isSelected = _tempSalesOrderTab == tab;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _tempSalesOrderTab = tab;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.fieldBorder,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected ? AppColors.primaryShade : Colors.white,
              ),
              child: Text(
                tab.label,
                style: isSelected
                    ? AppTypography.smallBoldPrimary
                    : AppTypography.smallNormalBlack,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _salesInvoiceFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: SalesInvoiceFilter.values.map((filter) {
        final isSelected = _tempSalesInvoiceFilter == filter;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _tempSalesInvoiceFilter = filter;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.fieldBorder,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected ? AppColors.primaryShade : Colors.white,
              ),
              child: Text(
                filter.label,
                style: isSelected
                    ? AppTypography.smallBoldPrimary
                    : AppTypography.smallNormalBlack,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _actions(SalesOrderMainTab mainTab) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              if (mainTab == SalesOrderMainTab.penjualan) {
                ref.read(salesOrderTabProvider.notifier).state = SalesOrderTab.all;
                ref.invalidate(salesOrderListProvider);
              } else {
                ref.read(salesInvoiceFilterProvider.notifier).state = SalesInvoiceFilter.all;
                ref.invalidate(salesInvoiceListAllProvider);
              }
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: AppColors.primary),
            ),
            child: const Text("Reset", style: AppTypography.smallBoldPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (mainTab == SalesOrderMainTab.penjualan) {
                if (_tempSalesOrderTab != null) {
                  ref.read(salesOrderTabProvider.notifier).state = _tempSalesOrderTab!;
                  ref.invalidate(salesOrderListProvider);
                }
              } else {
                if (_tempSalesInvoiceFilter != null) {
                  ref.read(salesInvoiceFilterProvider.notifier).state = _tempSalesInvoiceFilter!;
                  ref.invalidate(salesInvoiceListAllProvider);
                }
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text("Terapkan", style: AppTypography.smallBoldWhite),
          ),
        ),
      ],
    );
  }
}
