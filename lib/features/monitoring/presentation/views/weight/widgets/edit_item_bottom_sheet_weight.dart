import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/app/providers.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';
import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/core/widgets/animal_bottom_sheet.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';
import '../../../../data/monitoring_item_model.dart';

class EditItemBottomSheetWeight extends ConsumerStatefulWidget {
  final List<int> excludedIds;
  final MonitoringItem item;
  const EditItemBottomSheetWeight({
    super.key,
    this.excludedIds = const [],
    required this.item,
  });

  @override
  ConsumerState<EditItemBottomSheetWeight> createState() =>
      _EditItemBottomSheetWeightState();
}

class _EditItemBottomSheetWeightState
    extends ConsumerState<EditItemBottomSheetWeight> {
  final weightCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  AnimalProfile? selectedAnimal;
  int daysDiff = 0;
  double adgValue = 0.0;
  double weightGain = 0.0;

  @override
  void initState() {
    super.initState();
    weightCtrl.text = widget.item.weight ?? '';
    noteCtrl.text = widget.item.note ?? '';
    selectedAnimal = AnimalProfile(
      id: int.tryParse(widget.item.id ?? '') ?? 0,
      animalCode: widget.item.code ?? '',
      name: widget.item.name ?? '',
      salesOrderCustomerName: '',
      gender: '',
      status: '',
      available: '',
      age: 0,
      weight: double.tryParse(widget.item.stock ?? '0') ?? 0.0,
      purchPrice: 0.0,
      salesPrice: 0.0,
      refSalesPrice: 0,
      refSalesPriceTotal: 0,
      lastAdgDate: widget.item.age,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateADG(weightCtrl.text);
    });
  }

  @override
  void dispose() {
    weightCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  void _openAnimalSheet() async {
    ref.read(selectedAnimalProvider.notifier).state = selectedAnimal;

    final animal = await showModalBottomSheet<AnimalProfile>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: AnimalBottomSheet(excludedIds: widget.excludedIds),
      ),
    );

    if (animal != null) {
      setState(() {
        selectedAnimal = animal;
        _calculateADG(weightCtrl.text);
      });
    }
  }

  void _calculateADG(String val) {
    if (selectedAnimal == null) return;

    final newWeight = double.tryParse(val) ?? 0.0;
    final oldWeight = selectedAnimal!.weight;

    setState(() {
      weightGain = newWeight > 0.0 ? (newWeight - oldWeight) : 0.0;
    });

    if (selectedAnimal!.lastAdgDate != null &&
        selectedAnimal!.lastAdgDate!.isNotEmpty) {
      try {
        final lastDate = DateTime.parse(selectedAnimal!.lastAdgDate!);
        final today =
            ref.read(selectedMonitoringDateProvider) ?? DateTime.now();

        final diffDays = today.difference(lastDate).inDays;
        setState(() {
          daysDiff = diffDays < 0 ? 0 : diffDays;
          if (daysDiff > 0) {
            adgValue = (newWeight - oldWeight) / daysDiff;
          } else {
            adgValue = 0.0;
          }
        });
      } catch (_) {
        setState(() {
          daysDiff = 0;
          adgValue = 0.0;
        });
      }
    } else {
      setState(() {
        daysDiff = 0;
        adgValue = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastWeightStr = selectedAnimal != null
        ? "${selectedAnimal!.weight.toStringAsFixed(2)} kg"
        : "-";

    final today = ref.watch(selectedMonitoringDateProvider) ?? DateTime.now();
    bool isDateInvalid = false;
    String todayStr = "";
    String lastDateErrorStr = "";

    if (selectedAnimal != null &&
        selectedAnimal!.lastAdgDate != null &&
        selectedAnimal!.lastAdgDate!.isNotEmpty) {
      try {
        final lastDate = DateTime.parse(selectedAnimal!.lastAdgDate!);
        final lastDateOnly = DateTime(
          lastDate.year,
          lastDate.month,
          lastDate.day,
        );
        final todayOnly = DateTime(today.year, today.month, today.day);

        isDateInvalid = todayOnly.isBefore(lastDateOnly);
        todayStr = "${today.day}-${today.month}-${today.year}";
        lastDateErrorStr = "${lastDate.day}-${lastDate.month}-${lastDate.year}";
      } catch (_) {}
    }

    final isValid =
        selectedAnimal != null &&
        weightCtrl.text.isNotEmpty &&
        double.tryParse(weightCtrl.text) != null &&
        !isDateInvalid;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Edit Item", style: AppTypography.largeBoldBlack),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SelectField(
              label: "Hewan",
              hint: selectedAnimal != null
                  ? "${selectedAnimal!.animalCode} • ${selectedAnimal!.name}"
                  : "Pilih hewan",
              style: selectedAnimal != null
                  ? AppTypography.smallNormalBlack
                  : null,
              icon: AppImages.icProduct,
              onTap: _openAnimalSheet,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tanggal Timbang",
                        style: AppTypography.smallBoldBlack,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greyBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.fieldBorder),
                        ),
                        child: Text(
                          formatDateTime(today),
                          style: AppTypography.smallNormalBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Berat", style: AppTypography.smallBoldBlack),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greyBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.fieldBorder),
                        ),
                        child: Text(
                          lastWeightStr,
                          style: AppTypography.smallNormalGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isDateInvalid) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgColorShadeError,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.danger,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Tanggal Timbang ($todayStr) harus lebih baru dari Tanggal Monitoring Terakhir ($lastDateErrorStr). Penimbangan di masa lampau tidak diperbolehkan.",
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            TextFields(
              label: "Berat Hari Ini",
              hint: "Masukkan berat",
              suffix: "kg",
              controller: weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.\,]')),
              ],
              onChanged: (val) {
                _calculateADG(val);
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.fieldBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: weightGain.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              const TextSpan(text: " "),
                              const TextSpan(
                                text: "kg",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey2,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Kenaikan BB",
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.fieldBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "$daysDiff",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              const TextSpan(text: " "),
                              const TextSpan(
                                text: "hari",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey2,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Selisih hari",
                          style: TextStyle(
                            color: AppColors.info,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.fieldBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: adgValue.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              const TextSpan(text: " "),
                              const TextSpan(
                                text: "kg/day",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey2,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Nilai ADG",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFieldWithInnerCounter(
              label: 'Catatan',
              subLabel: '(Opsional)',
              hint: 'Masukkan catatan',
              maxLength: 80,
              controller: noteCtrl,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.grey3,
                  disabledForegroundColor: AppColors.white,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isValid
                    ? () {
                        Navigator.pop(
                          context,
                          MonitoringItem(
                            id: selectedAnimal!.id.toString(),
                            name: selectedAnimal!.name,
                            code: selectedAnimal!.animalCode,
                            age: selectedAnimal!.lastAdgDate ?? '',
                            stock: selectedAnimal!.weight.toString(),
                            subtitle: today.toIso8601String(),
                            weight: weightCtrl.text,
                            cutWeight: weightGain.toString(),
                            vaccine: daysDiff.toString(),
                            unit: adgValue.toString(),
                            note: noteCtrl.text,
                            quantity: int.tryParse(weightCtrl.text) ?? 0,
                          ),
                        );
                      }
                    : null,
                child: Text(
                  "Simpan Perubahan",
                  style: AppTypography.mediumBoldWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
