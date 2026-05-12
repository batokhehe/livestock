import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/receiving/presentation/widgets/poh_item_card.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

import 'package:livestock/features/receiving/presentation/notifier/receiving_po_notifier.dart';

class SelectReceivingItemSheet extends ConsumerStatefulWidget {
  final ReceivingTab tab;

  const SelectReceivingItemSheet({super.key, required this.tab});

  @override
  ConsumerState<SelectReceivingItemSheet> createState() =>
      _SelectReceivingItemSheetState();
}

class _SelectReceivingItemSheetState
    extends ConsumerState<SelectReceivingItemSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(paginatedReceivingPoProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(paginatedReceivingPoProvider);

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pilih Item Penerimaan",
                style: AppTypography.mediumBoldBlack,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),

          /// SEARCH
          TextField(
            onChanged: (val) {
              ref.read(receivingPoSearchProvider.notifier).state = val;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Cari item penerimaan",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// LIST
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: itemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: ${e.toString()}")),
              data: (res) {
                final items = res.data;
                final total = res.total ?? 0;
                final hasMore = items.length < total;

                if (items.isEmpty) {
                  return const Center(child: Text("Tidak ada item"));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: items.length + (hasMore ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = items[i];
                    return PohItemCard(item: item, tab: widget.tab);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
