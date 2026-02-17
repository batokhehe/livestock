import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'package:livestock/core/data/model/province_model.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/widgets/animal_bottom_sheet.dart';
import 'package:livestock/core/widgets/province_bottom_sheet.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_item_request_model.dart';

import '../../../../app/providers.dart';
import '../../../../core/data/model/city_model.dart';
import '../../../../core/data/model/district_model.dart';
import '../../../../core/data/model/village_model.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/city_bottom_sheet.dart';
import '../../../../core/widgets/custom_date_picker_sheet.dart';
import '../../../../core/widgets/district_bottom_sheet.dart';
import '../../../../core/widgets/input_field_card.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/village_bottom_sheet.dart';

class AddItemBottomSheetAnimal extends ConsumerStatefulWidget {
  const AddItemBottomSheetAnimal({super.key});

  @override
  ConsumerState<AddItemBottomSheetAnimal> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends ConsumerState<AddItemBottomSheetAnimal> {
  final priceCtrl = TextEditingController();
  final discountCtrl = TextEditingController();
  final finalPriceCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  DateTime? deliveryDate;
  AnimalProfile? selectedAnimal;
  Province? selectedProvince;

  @override
  void initState() {
    super.initState();

    priceCtrl.addListener(_calculateFinalPrice);
    discountCtrl.addListener(_calculateFinalPrice);
  }

  void _calculateFinalPrice() {
    final price = double.tryParse(priceCtrl.text) ?? 0;
    final discount = double.tryParse(discountCtrl.text) ?? 0;

    finalPriceCtrl.text = (price - discount).toStringAsFixed(0);
  }

  @override
  void dispose() {
    priceCtrl.dispose();
    discountCtrl.dispose();
    finalPriceCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProvince = ref.watch(selectedProvinceProvider);
    final selectedCity = ref.watch(selectedCityProvider);
    final selectedDistrict = ref.watch(selectedDistrictProvider);
    final selectedVillage = ref.watch(selectedVillageProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      expand: false,
      builder: (_, controller) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).padding.bottom + 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== HEADER =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tambah Item", style: AppTypography.largeBoldBlack),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SelectField(
                  label: "Hewan",
                  hint: selectedAnimal?.name ?? "Pilih Hewan",
                  icon: AppImages.icProduct,
                  onTap: () async {
                    final result = await showModalBottomSheet<AnimalProfile>(
                      context: context,
                      backgroundColor: AppColors.greyBg,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => const AnimalBottomSheet(),
                    );

                    if (result != null) {
                      setState(() {
                        selectedAnimal = result;
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),
                SectionCard(
                  title: 'Rincian Bayar',
                  children: [
                    TextFields(
                      label: "Harga Jual",
                      hint: "Masukkan harga jual",
                      prefixIcon: AppImages.icMoneys,
                      controller: priceCtrl,
                    ),
                    TextFields(
                      label: "Harga diskon",
                      hint: "Masukkan harga diskon",
                      prefixIcon: AppImages.icMoneys,
                      controller: discountCtrl,
                    ),
                    TextFields(
                      label: "Harga Akhir",
                      hint: "Masukkan harga akhir",
                      prefixIcon: AppImages.icMoneys,
                      controller: finalPriceCtrl,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SectionCard(
                  title: 'Jadwal Pengiriman',
                  children: [
                    SelectField(
                      label: "Tanggal Pengiriman",
                      hint: formatDateTime(deliveryDate),
                      icon: AppImages.icCalendarSearch,

                      onTap: () async {
                        final d = await showModalBottomSheet<DateTime?>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const CustomDatePickerSheet(),
                        );
                        if (d != null) {
                          setState(() => deliveryDate = d);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: 'Alamat Pengiriman',
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SelectField(
                            label: "Provinsi",
                            hint: selectedProvince?.name ?? "Pilih provinsi",
                            icon: AppImages.icMap,
                            onTap: () async {
                              final result =
                                  await showModalBottomSheet<Province>(
                                    context: context,
                                    backgroundColor: AppColors.greyBg,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (_) => const ProvinceBottomSheet(),
                                  );

                              if (result != null) {
                                ref
                                        .read(selectedProvinceProvider.notifier)
                                        .state =
                                    result;

                                // reset child
                                ref.read(selectedCityProvider.notifier).state =
                                    null;
                                ref
                                        .read(selectedDistrictProvider.notifier)
                                        .state =
                                    null;
                                ref
                                        .read(selectedVillageProvider.notifier)
                                        .state =
                                    null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SelectField(
                            label: "Kota",
                            hint: selectedCity?.name ?? "Pilih kota",
                            icon: AppImages.icMap,
                            onTap: selectedProvince == null
                                ? null
                                : () async {
                                    final result =
                                        await showModalBottomSheet<City>(
                                          context: context,
                                          builder: (_) => CityBottomSheet(),
                                        );

                                    if (result != null) {
                                      ref
                                              .read(
                                                selectedCityProvider.notifier,
                                              )
                                              .state =
                                          result;
                                      ref
                                              .read(
                                                selectedDistrictProvider
                                                    .notifier,
                                              )
                                              .state =
                                          null;
                                      ref
                                              .read(
                                                selectedVillageProvider
                                                    .notifier,
                                              )
                                              .state =
                                          null;
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SelectField(
                            label: "Kecamatan",
                            hint: selectedDistrict?.name ?? "Pilih kecamatan",
                            icon: AppImages.icMap,
                            onTap: selectedCity == null
                                ? null
                                : () async {
                                    final result =
                                        await showModalBottomSheet<District>(
                                          context: context,
                                          builder: (_) => DistrictBottomSheet(
                                            param: selectedCity.code,
                                          ),
                                        );

                                    if (result != null) {
                                      ref
                                              .read(
                                                selectedDistrictProvider
                                                    .notifier,
                                              )
                                              .state =
                                          result;
                                      ref
                                              .read(
                                                selectedVillageProvider
                                                    .notifier,
                                              )
                                              .state =
                                          null;
                                    }
                                  },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SelectField(
                            label: "Kelurahan",
                            hint: selectedVillage?.name ?? "Pilih kelurahan",
                            icon: AppImages.icMap,
                            onTap: selectedDistrict == null
                                ? null
                                : () async {
                                    final result =
                                        await showModalBottomSheet<Village>(
                                          context: context,
                                          builder: (_) => VillageBottomSheet(
                                            param: selectedDistrict.code,
                                          ),
                                        );

                                    if (result != null) {
                                      ref
                                              .read(
                                                selectedVillageProvider
                                                    .notifier,
                                              )
                                              .state =
                                          result;
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                    TextFields(
                      label: "Alamat",
                      hint: "Masukkan lengkap",
                      controller: addressCtrl,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 24),

                    // ===== BUTTON =====
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (selectedAnimal == null) return;

                          final item = SalesOrderItemRequest(
                            animalProfile: selectedAnimal!,
                            qty: 1,
                            unitPrice: double.tryParse(priceCtrl.text) ?? 0,
                            discount: double.tryParse(discountCtrl.text) ?? 0,
                            subtotal: double.tryParse(finalPriceCtrl.text) ?? 0,
                            dlvDate: deliveryDate,
                            deliveryAddress: addressCtrl.text,

                            stateId: selectedProvince?.code,
                            state: selectedProvince?.name,
                            cityId: selectedCity?.code,
                            city: selectedCity?.name,
                            districtId: selectedDistrict?.code,
                            district: selectedDistrict?.name,
                            villageId: selectedVillage?.code,
                            village: selectedVillage?.name,
                          );

                          Navigator.pop(context, item);
                        },
                        child: Text(
                          "Tambah Item",
                          style: AppTypography.mediumBoldWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
