import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/step_info_card.dart';
import 'package:livestock/features/receiving/data/model/receiving_po_model.dart';
import 'package:livestock/features/receiving/presentation/widgets/poh_item_card.dart';
import 'package:livestock/features/receiving/presentation/widgets/receiving_detail_form_card.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../widgets/upload_file_card.dart';

class AddReceivingStep2Page extends ConsumerStatefulWidget {
  final ReceivingPo item;

  const AddReceivingStep2Page({super.key, required this.item});

  @override
  ConsumerState<AddReceivingStep2Page> createState() =>
      _AddReceivingStep2PageState();
}

class _AddReceivingStep2PageState extends ConsumerState<AddReceivingStep2Page> {
  @override
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final provider = ref.read(receivingFormProvider);
      if (provider.items.isEmpty) {
        provider.setItems(
          widget.item.items,
          animalGroupId: widget.item.animalGroupId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(receivingFormProvider);
    final type = ref.read(receivingTabProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Penerimaan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const StepInfoCard(
                  title: "Detail Penerimaan",
                  step: 2,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                PohItemCard(item: widget.item, tab: type),
                const SizedBox(height: 12),

                /// INFO ITEM
                CardWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Informasi Item",
                        style: AppTypography.mediumNormalBlack,
                      ),
                      const SizedBox(height: 12),
                      ...provider.items.map(
                        (e) => ReceivingDetailFormCard(
                          item: e,
                          onToggle: () =>
                              ref.read(receivingFormProvider).toggleItem(e.id),

                          // 🔥 HANYA ANIMAL
                          onItemCodeChanged: type == ReceivingTab.animal
                              ? (v) => ref
                                    .read(receivingFormProvider)
                                    .updateCode(e.id, v)
                              : null,

                          onWeightChanged: type == ReceivingTab.animal
                              ? (v) => ref
                                    .read(receivingFormProvider)
                                    .updateWeight(e.id, v)
                              : null,

                          onNotesChanged: type == ReceivingTab.animal
                              ? (v) => ref
                                    .read(receivingFormProvider)
                                    .updateNotes(e.id, v)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                const UploadFileCard(),
              ],
            ),
          ),

          /// NEXT BUTTON
          _NextButtonStep2(),
        ],
      ),
    );
  }
}

class _NextButtonStep2 extends ConsumerWidget {
  const _NextButtonStep2();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final provider = ref.read(receivingFormProvider);

              if (provider.selectedItems.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pilih minimal 1 item")),
                );
                return;
              }

              if (!provider.hasProofImage) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bukti penerimaan wajib diunggah"),
                  ),
                );
                return;
              }

              final invalidItems = provider.selectedItems.where((e) {
                final codeEmpty = (e.itemCode ?? '').trim().isEmpty;
                final weightEmpty =
                    e.receivedWeight == null || e.receivedWeight! <= 0;

                return codeEmpty || weightEmpty;
              }).toList();

              if (invalidItems.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Kode hewan dan berat wajib diisi"),
                  ),
                );
                return;
              }

              context.push('/receiving/add/confirmation');
            },
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
