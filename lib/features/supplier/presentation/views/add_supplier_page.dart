import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/app/providers.dart';
import 'package:livestock/core/data/model/city_model.dart';
import 'package:livestock/core/data/model/province_model.dart';
import 'package:livestock/core/data/model/supplier_model.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/city_bottom_sheet.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/core/widgets/province_bottom_sheet.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/core/widgets/success_notification.dart';

class AddSupplierPage extends ConsumerStatefulWidget {
  final String? initialType;
  const AddSupplierPage({super.key, this.initialType});

  @override
  ConsumerState<AddSupplierPage> createState() => _AddSupplierPageState();
}

class _AddSupplierPageState extends ConsumerState<AddSupplierPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  Province? _selectedProvince;
  City? _selectedCity;
  String _tipePemasok = 'Hewan';
  String _status = 'active';
  bool _isLoading = false;

  final List<String> _typeOptions = const [
    'Hewan',
    'Pakan',
    'Obat',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null && widget.initialType!.isNotEmpty) {
      final t = widget.initialType!.toLowerCase();
      if (t.contains('hewan') || t.contains('animal')) {
        _tipePemasok = 'Hewan';
      } else if (t.contains('pakan') || t.contains('feed')) {
        _tipePemasok = 'Pakan';
      } else if (t.contains('obat') || t.contains('med')) {
        _tipePemasok = 'Obat';
      } else if (t.contains('lain') || t.contains('other')) {
        _tipePemasok = 'Lainnya';
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
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
      });
      ref.read(selectedProvinceProvider.notifier).state = result;
      ref.read(selectedCityProvider.notifier).state = null;
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
      });
      ref.read(selectedCityProvider.notifier).state = result;
    }
  }

  bool get _isFormValid {
    return _nameCtrl.text.trim().isNotEmpty &&
        _phoneCtrl.text.trim().isNotEmpty &&
        _addressCtrl.text.trim().isNotEmpty &&
        _selectedProvince != null &&
        _selectedCity != null &&
        _tipePemasok.isNotEmpty;
  }

  Future<void> _submitSupplier() async {
    if (!_isFormValid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final payload = {
        "name": _nameCtrl.text.trim(),
        "contact_email":
            _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        "contact_phone": _phoneCtrl.text.trim(),
        "address": _addressCtrl.text.trim(),
        "state": _selectedProvince?.name,
        "state_id": _selectedProvince?.code,
        "city": _selectedCity?.name,
        "city_id": _selectedCity?.code,
        "tipe_pemasok": _tipePemasok,
        "status": _status,
      }..removeWhere((k, v) => v == null);

      final newSupplier = await ref
          .read(getMasterDataListUseCaseProvider)
          .createSupplier(payload);

      // Invalidate providers
      ref.invalidate(paginatedSupplierProvider);
      ref.invalidate(supplierListProvider);

      if (mounted) {
        SuccessNotification.show(
          title: "Berhasil",
          subtitle: "Pemasok baru berhasil ditambahkan",
        );
        Navigator.pop(context, newSupplier);
      }
    } on DioException catch (e) {
      if (mounted) {
        String errorMessage = "Gagal menambahkan pemasok";
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'].toString();
        } else if (e.message != null) {
          errorMessage = e.message!;
        }
        SuccessNotification.showError(
          title: "Gagal Menambahkan Pemasok",
          subtitle: errorMessage,
        );
      }
    } catch (e) {
      if (mounted) {
        SuccessNotification.showError(
          title: "Gagal Menambahkan Pemasok",
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
        title: const Text(
          "Tambah Pemasok",
          style: AppTypography.largeBoldBlack,
        ),
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
                  // SECTION 1: Informasi Pemasok
                  SectionCard(
                    title: "Informasi Pemasok",
                    children: [
                      TextFields(
                        label: "Nama Pemasok",
                        hint: "Masukkan nama pemasok",
                        isMandatoryField: true,
                        controller: _nameCtrl,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      AppRadioGroup<String>(
                        title: "Tipe Pemasok",
                        isMandatoryField: true,
                        value: _tipePemasok,
                        options: _typeOptions,
                        labelBuilder: (v) => v,
                        onChanged: (v) {
                          setState(() {
                            _tipePemasok = v;
                          });
                        },
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
                    ],
                  ),
                  const SizedBox(height: 16),

                  // SECTION 3: Status
                  SectionCard(
                    title: "Status",
                    children: [
                      AppRadioGroup<String>(
                        title: "Status",
                        isMandatoryField: true,
                        value: _status,
                        options: const ["active", "inactive"],
                        labelBuilder: (v) =>
                            v == "active" ? "Aktif" : "Tidak Aktif",
                        onChanged: (v) {
                          setState(() {
                            _status = v;
                          });
                        },
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
                  onPressed:
                      _isFormValid && !_isLoading ? _submitSupplier : null,
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
                          "Simpan Pemasok",
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
