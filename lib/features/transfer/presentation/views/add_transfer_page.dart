import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/custom_date_picker_sheet.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/core/widgets/step_info_card.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import '../../data/model/batch_animal_transfer_model.dart';
import '../../transfer_provider.dart';
import '../widgets/transfer_animal_paginated_bottom_sheet.dart';

class AddTransferPage extends ConsumerStatefulWidget {
  const AddTransferPage({super.key});

  @override
  ConsumerState<AddTransferPage> createState() => _AddTransferPageState();
}

class _AddTransferPageState extends ConsumerState<AddTransferPage> {
  late final TextEditingController _batchNotesController;

  @override
  void initState() {
    super.initState();
    _batchNotesController = TextEditingController(
      text: ref.read(selectedTransferNotesProvider),
    );

    _batchNotesController.addListener(() {
      ref.read(selectedTransferNotesProvider.notifier).state =
          _batchNotesController.text;
    });

    Future.microtask(() {
      ref.read(transferAnimalSearchProvider.notifier).state = '';
    });
  }

  @override
  void dispose() {
    _batchNotesController.dispose();
    super.dispose();
  }

  void _openAnimalPicker(List<BatchAnimalTransferItem> currentItems) async {
    ref.read(transferAnimalSearchProvider.notifier).state = '';
    final currentAnimals = currentItems.map((e) => e.animal).toList();

    final result = await showModalBottomSheet<List<AnimalProfile>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransferAnimalPaginatedBottomSheet(
        initialSelectedAnimals: currentAnimals,
      ),
    );

    if (result != null) {
      final existingMap = {for (var item in currentItems) item.animal.id: item};
      final newItems = result.map((a) {
        if (existingMap.containsKey(a.id)) {
          return existingMap[a.id]!;
        }
        return BatchAnimalTransferItem(animal: a);
      }).toList();

      ref.read(selectedTransferAnimalsProvider.notifier).state = newItems;

      // If list of animals changes, reset destination to prevent invalid combinations
      if (newItems.isEmpty) {
        ref.read(selectedTransferToLocationProvider.notifier).state = null;
        ref.read(selectedTransferToAreaProvider.notifier).state = null;
      }
    }
  }

  void _removeAnimal(int animalId) {
    final current = ref.read(selectedTransferAnimalsProvider);
    final updated = current.where((e) => e.animal.id != animalId).toList();
    ref.read(selectedTransferAnimalsProvider.notifier).state = updated;
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedTransferDateProvider);
    final selectedAnimals = ref.watch(selectedTransferAnimalsProvider);

    final bool isValid = selectedAnimals.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Pemindahan",
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
                  title: "Informasi Pemindahan Hewan",
                  step: 1,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: "Informasi Pemindahan",
                  children: [
                    SelectField(
                      label: "Tanggal Pemindahan",
                      isMandatoryField: true,
                      hint: formatDateTime(selectedDate),
                      icon: AppImages.icCalendarSearch,
                      onTap: () async {
                        final pickedDate =
                            await showModalBottomSheet<DateTime?>(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const CustomDatePickerSheet(),
                            );

                        if (pickedDate != null) {
                          ref
                              .read(selectedTransferDateProvider.notifier)
                              .state = pickedDate;
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFields(
                      label: "Catatan Pemindahan (Opsional)",
                      hint: "Contoh: Transfer batch hewan ke lokasi baru",
                      controller: _batchNotesController,
                      maxLines: 2,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: "Informasi Hewan",
                  children: [
                    SelectField(
                      label: "Pilih Hewan",
                      isMandatoryField: true,
                      hint: selectedAnimals.isNotEmpty
                          ? "${selectedAnimals.length} Hewan Dipilih"
                          : "Pilih Hewan...",
                      icon: AppImages.icProduct,
                      onTap: () => _openAnimalPicker(selectedAnimals),
                    ),
                    if (selectedAnimals.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ...selectedAnimals.map((item) {
                        return _AnimalTransferItemCard(
                          key: ValueKey(item.animal.id),
                          item: item,
                          onRemove: () => _removeAnimal(item.animal.id),
                          onUpdated: (updatedItem) {
                            final current =
                                ref.read(selectedTransferAnimalsProvider);
                            final updated = current.map((e) {
                              if (e.animal.id == updatedItem.animal.id) {
                                return updatedItem;
                              }
                              return e;
                            }).toList();
                            ref
                                .read(selectedTransferAnimalsProvider.notifier)
                                .state = updated;
                          },
                        );
                      }),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isValid
                        ? AppColors.primary
                        : AppColors.grey3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: isValid ? 2 : 0,
                  ),
                  onPressed: isValid
                      ? () {
                          context.push('/transfer/add-step-2');
                        }
                      : null,
                  child: Text(
                    "Selanjutnya",
                    style: AppTypography.mediumBoldWhite.copyWith(
                      color: isValid
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimalTransferItemCard extends StatefulWidget {
  final BatchAnimalTransferItem item;
  final VoidCallback onRemove;
  final ValueChanged<BatchAnimalTransferItem> onUpdated;

  const _AnimalTransferItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onUpdated,
  });

  @override
  State<_AnimalTransferItemCard> createState() =>
      _AnimalTransferItemCardState();
}

class _AnimalTransferItemCardState extends State<_AnimalTransferItemCard> {
  late final TextEditingController _costCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _costCtrl = TextEditingController(
      text: widget.item.shippingCost != null && widget.item.shippingCost! > 0
          ? formatPrice(widget.item.shippingCost!.toInt())
          : '',
    );
    _notesCtrl = TextEditingController(text: widget.item.notes);

    _costCtrl.addListener(_notify);
    _notesCtrl.addListener(_notify);
  }

  void _notify() {
    final raw = _costCtrl.text.replaceAll('.', '');
    final cost = double.tryParse(raw) ?? 0;
    final notes = _notesCtrl.text;

    widget.onUpdated(
      widget.item.copyWith(
        shippingCost: cost,
        notes: notes,
      ),
    );
  }

  @override
  void dispose() {
    _costCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animal = widget.item.animal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ProductHeaderCard(
                    title: animal.animalCode,
                    subtitle:
                        "${animal.name} • ${animal.weight.floor()} kg",
                    image: AppImages.icProduct,
                    status: animal.available,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.danger,
                    size: 22,
                  ),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            const Divider(height: 20, color: AppColors.fieldBorder),
            TextFields(
              label: "Biaya Pengiriman (Opsional)",
              hint: "0",
              prefixText: "Rp ",
              controller: _costCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(),
              ],
            ),
            TextFields(
              label: "Catatan Hewan (Opsional)",
              hint: "Contoh: Handle with care",
              controller: _notesCtrl,
            ),
          ],
        ),
      ),
    );
  }
}
