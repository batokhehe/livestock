import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/custom_date_picker_sheet.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/core/widgets/step_info_card.dart';
import '../../transfer_provider.dart';
import '../widgets/transfer_animal_paginated_bottom_sheet.dart';

class AddTransferPage extends ConsumerStatefulWidget {
  const AddTransferPage({super.key});

  @override
  ConsumerState<AddTransferPage> createState() => _AddTransferPageState();
}

class _AddTransferPageState extends ConsumerState<AddTransferPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedTransferDateProvider.notifier).state = DateTime.now();
      ref.read(selectedTransferAnimalProvider.notifier).state = null;
      ref.read(transferAnimalSearchProvider.notifier).state = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedTransferDateProvider);
    final selectedAnimal = ref.watch(selectedTransferAnimalProvider);

    final bool isValid = selectedAnimal != null;

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
                                  .state =
                              pickedDate;
                        }
                      },
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
                      hint: selectedAnimal != null
                          ? "${selectedAnimal.name} (${selectedAnimal.animalCode})"
                          : "Pilih Hewan",
                      icon: AppImages.icProduct,
                      onTap: () async {
                        ref.read(transferAnimalSearchProvider.notifier).state =
                            '';
                        final animal = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => TransferAnimalPaginatedBottomSheet(
                            initialSelectedId: selectedAnimal?.id,
                          ),
                        );

                        if (animal != null) {
                          ref
                                  .read(selectedTransferAnimalProvider.notifier)
                                  .state =
                              animal;
                        }
                      },
                    ),
                    if (selectedAnimal != null) ...[
                      const SizedBox(height: 12),
                      CardWrapper(
                        child: ProductHeaderCard(
                          title: selectedAnimal.animalCode,
                          subtitle:
                              "${selectedAnimal.name} • ${selectedAnimal.weight.floor()} kg",
                          image: AppImages.icProduct,
                          status: selectedAnimal.available,
                        ),
                      ),
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
