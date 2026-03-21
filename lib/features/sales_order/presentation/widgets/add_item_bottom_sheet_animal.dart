import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livestock/core/data/model/animal_profile_model.dart';
import 'package:livestock/core/data/model/province_model.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/widgets/animal_bottom_sheet.dart';
import 'package:livestock/core/widgets/province_bottom_sheet.dart';
import 'package:livestock/features/sales_order/data/model/sales_order_item_request_model.dart';
import '../../data/model/calculate_forecast_model.dart';

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
import '../../sales_order_provider.dart';

class AddItemBottomSheetAnimal extends ConsumerStatefulWidget {
  const AddItemBottomSheetAnimal({super.key});

  @override
  ConsumerState<AddItemBottomSheetAnimal> createState() =>
      _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends ConsumerState<AddItemBottomSheetAnimal> {
  final priceCtrl = TextEditingController();
  final discountCtrl = TextEditingController();
  final finalPriceCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final shippingCostCtrl = TextEditingController(text: '0');

  DateTime? deliveryDate;
  AnimalProfile? selectedAnimal;
  CalculateForecast? forecastData;
  Province? selectedProvince;

  @override
  void initState() {
    super.initState();

    priceCtrl.addListener(_calculateFinalPrice);
    discountCtrl.addListener(_calculateFinalPrice);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateShippingCost();
    });
  }

  Future<void> _updateShippingCost() async {
    final form = ref.read(salesOrderFormProvider);
    final selectedCity = ref.read(selectedCityProvider);
    final farmLocationId = form.farmLocation?.id;

    if (farmLocationId == null) return;

    try {
      final costs = await ref
          .read(masterRepositoryProvider)
          .getShippingCosts(
            cityId: selectedCity?.code,
            farmLocationId: farmLocationId,
          );

      if (costs.isNotEmpty) {
        setState(() {
          shippingCostCtrl.text = formatPrice(costs.first.price);
        });
      }
    } catch (e) {
      debugPrint("Error fetching shipping cost: $e");
    }
  }

  double _parsePrice(String text) =>
      double.tryParse(text.replaceAll('.', '').trim()) ?? 0;

  void _calculateFinalPrice() {
    final price = _parsePrice(priceCtrl.text);
    final discount = _parsePrice(discountCtrl.text);
    final result = price - discount;
    finalPriceCtrl.text = result > 0 ? formatPrice(result) : '0';
  }

  void _copyFromCustomer() {
    final customer = ref.read(salesOrderFormProvider).customer;
    if (customer == null) return;

    if (customer.state != null && customer.stateId != null) {
      ref.read(selectedProvinceProvider.notifier).state = Province(
        code: customer.stateId!,
        name: customer.state!,
      );
    }

    if (customer.city != null && customer.cityId != null) {
      ref.read(selectedCityProvider.notifier).state = City(
        code: customer.cityId!,
        name: customer.city!,
      );
    }

    if (customer.district != null && customer.districtId != null) {
      ref.read(selectedDistrictProvider.notifier).state = District(
        code: customer.districtId!,
        name: customer.district!,
      );
    } else {
      ref.read(selectedDistrictProvider.notifier).state = null;
    }

    if (customer.village != null && customer.villageId != null) {
      ref.read(selectedVillageProvider.notifier).state = Village(
        code: customer.villageId!,
        name: customer.village!,
      );
    } else {
      ref.read(selectedVillageProvider.notifier).state = null;
    }

    addressCtrl.text = customer.address ?? '';

    _updateShippingCost();
  }

  @override
  void dispose() {
    priceCtrl.dispose();
    discountCtrl.dispose();
    finalPriceCtrl.dispose();
    addressCtrl.dispose();
    shippingCostCtrl.dispose();
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
        final isValid =
            selectedAnimal != null &&
            _parsePrice(priceCtrl.text) > 0 &&
            _parsePrice(finalPriceCtrl.text) > 0 &&
            deliveryDate != null &&
            selectedProvince != null &&
            selectedCity != null &&
            selectedDistrict != null &&
            selectedVillage != null &&
            addressCtrl.text.trim().isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tambah Item",
                            style: AppTypography.largeBoldBlack,
                          ),
                          RawMaterialButton(
                            onPressed: () => Navigator.pop(context),
                            elevation: 1.0,
                            constraints: BoxConstraints(minWidth: 0.0),
                            padding: EdgeInsets.all(8.0),
                            shape: CircleBorder(
                              side: const BorderSide(
                                color: AppColors.iconColor,
                                width: 2.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Icon(Icons.close_rounded, size: 14.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SelectField(
                        label: "Hewan",
                        hint: selectedAnimal?.name ?? "Pilih Hewan",
                        icon: AppImages.icProduct,
                        onTap: () async {
                          final result =
                              await showModalBottomSheet<AnimalProfile>(
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
                              priceCtrl.text = formatPrice(
                                result.refSalesPriceTotal,
                              );
                              discountCtrl.text = '0';
                            });

                            if (result.animalGroup != null) {
                              final forecast = await ref
                                  .read(salesOrderFormProvider.notifier)
                                  .calculateForecastForItem(
                                    animalGroupId: result.animalGroup!.id,
                                  );

                              setState(() {
                                forecastData = forecast;
                                priceCtrl.text = formatPrice(
                                  forecast.forecastPrice,
                                );
                                finalPriceCtrl.text = formatPrice(
                                  forecast.targetPriceForecast,
                                );
                              });
                            }
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      if (selectedAnimal != null)
                        _buildAnimalInfoSection(selectedAnimal!),

                      SectionCard(
                        title: 'Rincian Bayar',
                        children: [
                          TextFields(
                            label: "Harga Jual",
                            hint: "0",
                            isMandatoryField: true,
                            prefixText: 'Rp ',
                            controller: priceCtrl,
                            enabled: selectedAnimal != null,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyInputFormatter(),
                            ],
                          ),
                          TextFields(
                            label: "Harga diskon",
                            hint: "0",
                            prefixText: 'Rp ',
                            controller: discountCtrl,
                            enabled: selectedAnimal != null,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyInputFormatter(),
                            ],
                          ),
                          TextFields(
                            label: "Harga Akhir",
                            hint: "0",
                            isMandatoryField: true,
                            prefixText: 'Rp ',
                            controller: finalPriceCtrl,
                            enabled: selectedAnimal != null,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyInputFormatter(),
                            ],
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
                            isMandatoryField: true,
                            onTap: () async {
                              final d = await showModalBottomSheet<DateTime?>(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
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
                        actionLabel: 'Salin Alamat Pelanggan',
                        onActionTap: _copyFromCustomer,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SelectField(
                                  label: "Provinsi",
                                  hint:
                                      selectedProvince?.name ??
                                      "Pilih provinsi",
                                  icon: AppImages.icMap,
                                  isMandatoryField: true,
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
                                          builder: (_) =>
                                              const ProvinceBottomSheet(),
                                        );

                                    if (result != null) {
                                      ref
                                              .read(
                                                selectedProvinceProvider
                                                    .notifier,
                                              )
                                              .state =
                                          result;

                                      ref
                                              .read(
                                                selectedCityProvider.notifier,
                                              )
                                              .state =
                                          null;
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
                              const SizedBox(width: 8),
                              Expanded(
                                child: SelectField(
                                  label: "Kota",
                                  hint: selectedCity?.name ?? "Pilih kota",
                                  icon: AppImages.icMap,
                                  isMandatoryField: true,
                                  onTap: selectedProvince == null
                                      ? null
                                      : () async {
                                          final result =
                                              await showModalBottomSheet<City>(
                                                context: context,
                                                builder: (_) =>
                                                    CityBottomSheet(),
                                              );

                                          if (result != null) {
                                            ref
                                                    .read(
                                                      selectedCityProvider
                                                          .notifier,
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

                                            _updateShippingCost();
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
                                  hint:
                                      selectedDistrict?.name ??
                                      "Pilih kecamatan",
                                  icon: AppImages.icMap,
                                  isMandatoryField: true,
                                  onTap: selectedCity == null
                                      ? null
                                      : () async {
                                          final result =
                                              await showModalBottomSheet<
                                                District
                                              >(
                                                context: context,
                                                builder: (_) =>
                                                    DistrictBottomSheet(
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
                                  hint:
                                      selectedVillage?.name ??
                                      "Pilih kelurahan",
                                  icon: AppImages.icMap,
                                  isMandatoryField: true,
                                  onTap: selectedDistrict == null
                                      ? null
                                      : () async {
                                          final result =
                                              await showModalBottomSheet<
                                                Village
                                              >(
                                                context: context,
                                                builder: (_) =>
                                                    VillageBottomSheet(
                                                      param:
                                                          selectedDistrict.code,
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
                          SizedBox(height: 8.0),
                          TextFields(
                            label: "Alamat",
                            hint: "Masukkan lengkap",
                            isMandatoryField: true,
                            controller: addressCtrl,
                            maxLines: 3,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SectionCard(
                        title: 'Rincian Biaya',
                        children: [
                          TextFields(
                            label: "Biaya Pengiriman",
                            hint: "0",
                            prefixText: 'Rp ',
                            controller: shippingCostCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyInputFormatter(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isValid
                          ? AppColors.primary
                          : AppColors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isValid
                        ? () {
                            final item = SalesOrderItemRequest(
                              animalProfile: selectedAnimal!,
                              qty: 1,
                              unitPrice: _parsePrice(priceCtrl.text),
                              discount: _parsePrice(discountCtrl.text),
                              subtotal: _parsePrice(finalPriceCtrl.text),
                              dlvDate: deliveryDate,
                              deliveryAddress: addressCtrl.text,
                              shippingCost: _parsePrice(shippingCostCtrl.text),
                              forecastWeight: forecastData?.forecastWeight,
                              stateId: selectedProvince.code,
                              state: selectedProvince.name,
                              cityId: selectedCity.code,
                              city: selectedCity.name,
                              districtId: selectedDistrict.code,
                              district: selectedDistrict.name,
                              villageId: selectedVillage.code,
                              village: selectedVillage.name,
                            );

                            Navigator.pop(context, item);
                          }
                        : null,
                    child: Text(
                      "Tambah Item",
                      style: AppTypography.mediumBoldWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimalInfoSection(AnimalProfile animal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.greyBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    AppImages.icNavCow,
                    fit: BoxFit.contain,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(animal.name, style: AppTypography.smallBoldBlack),
                  Text(
                    animal.animalCode,
                    style: AppTypography.xSmallNormalGrey,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text('Berat Hewan', style: AppTypography.smallBoldBlack),
          const SizedBox(height: 6),
          _infoField(
            '${animal.weight.toStringAsFixed(0)} kg',
            AppImages.icMoneys,
          ),
          const SizedBox(height: 14),
          Text('Est. Harga jual per kg', style: AppTypography.smallBoldBlack),
          const SizedBox(height: 6),
          _infoField(
            'Rp ${formatPrice(animal.refSalesPrice)}',
            AppImages.icMoneys,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Est. Harga Jual Total',
                style: AppTypography.smallNormalGrey,
              ),
              Text(
                'Rp ${formatPrice(animal.refSalesPriceTotal)}',
                style: AppTypography.smallBoldBlack,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoField(String value, String iconAsset) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder, width: 1),
      ),
      child: Row(
        children: [
          Image.asset(iconAsset, width: 18, height: 18),
          const SizedBox(width: 10),
          Text(value, style: AppTypography.smallNormalBlack),
        ],
      ),
    );
  }
}
