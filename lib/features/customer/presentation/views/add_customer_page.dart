import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/app/providers.dart';
import 'package:livestock/core/data/model/city_model.dart';
import 'package:livestock/core/data/model/customer_model.dart';
import 'package:livestock/core/data/model/district_model.dart';
import 'package:livestock/core/data/model/province_model.dart';
import 'package:livestock/core/data/model/village_model.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/city_bottom_sheet.dart';
import 'package:livestock/core/widgets/district_bottom_sheet.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/core/widgets/province_bottom_sheet.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/core/widgets/success_notification.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';
import 'package:livestock/core/widgets/village_bottom_sheet.dart';

class AddCustomerPage extends ConsumerStatefulWidget {
  const AddCustomerPage({super.key});

  @override
  ConsumerState<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends ConsumerState<AddCustomerPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  Province? _selectedProvince;
  City? _selectedCity;
  District? _selectedDistrict;
  Village? _selectedVillage;
  String _status = 'active';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _openProvinceSheet() async {
    ref.read(selectedProvinceProvider.notifier).state = _selectedProvince;

    final result = await showModalBottomSheet<Province>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const ProvinceBottomSheet(),
      ),
    );

    if (result != null && result.code != _selectedProvince?.code) {
      setState(() {
        _selectedProvince = result;
        _selectedCity = null;
        _selectedDistrict = null;
        _selectedVillage = null;
      });
      ref.read(selectedProvinceProvider.notifier).state = result;
      ref.read(selectedCityProvider.notifier).state = null;
      ref.read(selectedDistrictProvider.notifier).state = null;
      ref.read(selectedVillageProvider.notifier).state = null;
    }
  }

  void _openCitySheet() async {
    if (_selectedProvince == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih provinsi terlebih dahulu")),
      );
      return;
    }

    ref.read(selectedProvinceProvider.notifier).state = _selectedProvince;
    ref.read(selectedCityProvider.notifier).state = _selectedCity;

    final result = await showModalBottomSheet<City>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const CityBottomSheet(),
      ),
    );

    if (result != null && result.code != _selectedCity?.code) {
      setState(() {
        _selectedCity = result;
        _selectedDistrict = null;
        _selectedVillage = null;
      });
      ref.read(selectedCityProvider.notifier).state = result;
      ref.read(selectedDistrictProvider.notifier).state = null;
      ref.read(selectedVillageProvider.notifier).state = null;
    }
  }

  void _openDistrictSheet() async {
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih kota/kabupaten terlebih dahulu")),
      );
      return;
    }

    ref.read(selectedCityProvider.notifier).state = _selectedCity;
    ref.read(selectedDistrictProvider.notifier).state = _selectedDistrict;

    final result = await showModalBottomSheet<District>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DistrictBottomSheet(param: _selectedCity!.code),
      ),
    );

    if (result != null && result.code != _selectedDistrict?.code) {
      setState(() {
        _selectedDistrict = result;
        _selectedVillage = null;
      });
      ref.read(selectedDistrictProvider.notifier).state = result;
      ref.read(selectedVillageProvider.notifier).state = null;
    }
  }

  void _openVillageSheet() async {
    if (_selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih kecamatan terlebih dahulu")),
      );
      return;
    }

    ref.read(selectedDistrictProvider.notifier).state = _selectedDistrict;
    ref.read(selectedVillageProvider.notifier).state = _selectedVillage;

    final result = await showModalBottomSheet<Village>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: VillageBottomSheet(param: _selectedDistrict!.code),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedVillage = result;
      });
      ref.read(selectedVillageProvider.notifier).state = result;
    }
  }

  bool get _isFormValid {
    return _nameCtrl.text.trim().isNotEmpty &&
        _phoneCtrl.text.trim().isNotEmpty &&
        _addressCtrl.text.trim().isNotEmpty &&
        _selectedProvince != null &&
        _selectedCity != null &&
        _selectedDistrict != null &&
        _selectedVillage != null;
  }

  Future<void> _submitCustomer() async {
    if (!_isFormValid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final payload = {
        "name": _nameCtrl.text.trim(),
        "contact_email": _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        "contact_phone": _phoneCtrl.text.trim(),
        "address": _addressCtrl.text.trim(),
        "state": _selectedProvince?.name,
        "state_id": _selectedProvince?.code,
        "city": _selectedCity?.name,
        "city_id": _selectedCity?.code,
        "district": _selectedDistrict?.name,
        "district_id": _selectedDistrict?.code,
        "village": _selectedVillage?.name,
        "village_id": _selectedVillage?.code,
        "status": _status,
        "notes": _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      }..removeWhere((k, v) => v == null);

      final newCustomer = await ref
          .read(getMasterDataListUseCaseProvider)
          .createCustomer(payload);

      ref.invalidate(paginatedCustomerProvider);

      if (mounted) {
        SuccessNotification.show(
          title: "Berhasil",
          subtitle: "Pelanggan baru berhasil ditambahkan",
        );
        Navigator.pop(context, newCustomer);
      }
    } on DioException catch (e) {
      if (mounted) {
        String errorMessage = "Gagal menambahkan pelanggan";
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'].toString();
        } else if (e.message != null) {
          errorMessage = e.message!;
        }
        SuccessNotification.showError(
          title: "Gagal Menambahkan Pelanggan",
          subtitle: errorMessage,
        );
      }
    } catch (e) {
      if (mounted) {
        SuccessNotification.showError(
          title: "Gagal Menambahkan Pelanggan",
          subtitle: e.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text("Tambah Pelanggan", style: AppTypography.largeBoldBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION 1: Informasi Kontak
                  SectionCard(
                    title: "Informasi Pelanggan",
                    children: [
                      TextFields(
                        label: "Nama Pelanggan",
                        hint: "Masukkan nama pelanggan",
                        isMandatoryField: true,
                        controller: _nameCtrl,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      TextFields(
                        label: "Telepon Kontak",
                        hint: "Masukkan nomor telepon",
                        isMandatoryField: true,
                        keyboardType: TextInputType.phone,
                        controller: _phoneCtrl,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      TextFields(
                        label: "Email Kontak",
                        hint: "Masukkan email (opsional)",
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailCtrl,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // SECTION 2: Alamat & Wilayah
                  SectionCard(
                    title: "Alamat & Wilayah",
                    children: [
                      TextFields(
                        label: "Alamat",
                        hint: "Masukkan alamat lengkap",
                        isMandatoryField: true,
                        maxLines: 3,
                        controller: _addressCtrl,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      SelectField(
                        label: "Provinsi",
                        isMandatoryField: true,
                        hint: _selectedProvince?.name ?? "Pilih provinsi",
                        style: _selectedProvince != null
                            ? AppTypography.smallNormalBlack
                            : null,
                        icon: AppImages.icMap,
                        onTap: _openProvinceSheet,
                      ),
                      const SizedBox(height: 12),
                      SelectField(
                        label: "Kota/Kabupaten",
                        isMandatoryField: true,
                        hint: _selectedCity?.name ?? "Pilih kota/kabupaten",
                        style: _selectedCity != null
                            ? AppTypography.smallNormalBlack
                            : null,
                        icon: AppImages.icMap,
                        enabled: _selectedProvince != null,
                        onTap: _openCitySheet,
                      ),
                      const SizedBox(height: 12),
                      SelectField(
                        label: "Kecamatan",
                        isMandatoryField: true,
                        hint: _selectedDistrict?.name ?? "Pilih kecamatan",
                        style: _selectedDistrict != null
                            ? AppTypography.smallNormalBlack
                            : null,
                        icon: AppImages.icMap,
                        enabled: _selectedCity != null,
                        onTap: _openDistrictSheet,
                      ),
                      const SizedBox(height: 12),
                      SelectField(
                        label: "Kelurahan / Desa",
                        isMandatoryField: true,
                        hint: _selectedVillage?.name ?? "Pilih kelurahan / desa",
                        style: _selectedVillage != null
                            ? AppTypography.smallNormalBlack
                            : null,
                        icon: AppImages.icMap,
                        enabled: _selectedDistrict != null,
                        onTap: _openVillageSheet,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // SECTION 3: Status & Catatan
                  SectionCard(
                    title: "Status & Catatan",
                    children: [
                      AppRadioGroup<String>(
                        title: "Status",
                        isMandatoryField: true,
                        value: _status,
                        options: const ["active", "inactive"],
                        labelBuilder: (v) => v == "active" ? "Aktif" : "Tidak Aktif",
                        onChanged: (v) {
                          setState(() {
                            _status = v;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFieldWithInnerCounter(
                        label: 'Catatan',
                        subLabel: '(Opsional)',
                        hint: 'Masukkan catatan pelanggan...',
                        maxLength: 80,
                        controller: _notesCtrl,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom Action Button
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.grey3,
                    disabledForegroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: _isFormValid ? 2 : 0,
                  ),
                  onPressed: _isFormValid && !_isLoading ? _submitCustomer : null,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Simpan Pelanggan",
                          style: AppTypography.mediumBoldWhite,
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
