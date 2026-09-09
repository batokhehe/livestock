import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/app/providers.dart';
import 'package:livestock/core/data/model/feed_medicine_model.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/success_notification.dart';

class AddFeedMedicinePage extends ConsumerStatefulWidget {
  final String? initialType;
  const AddFeedMedicinePage({super.key, this.initialType});

  @override
  ConsumerState<AddFeedMedicinePage> createState() =>
      _AddFeedMedicinePageState();
}

class _AddFeedMedicinePageState extends ConsumerState<AddFeedMedicinePage> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _uomCtrl = TextEditingController();

  String _feedType = 'pakan';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null && widget.initialType!.isNotEmpty) {
      final t = widget.initialType!.toLowerCase();
      if (t.contains('obat') || t.contains('med')) {
        _feedType = 'obat';
      } else {
        _feedType = 'pakan';
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _uomCtrl.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _nameCtrl.text.trim().isNotEmpty &&
        _uomCtrl.text.trim().isNotEmpty &&
        _feedType.isNotEmpty;
  }

  Future<void> _submitFeedMedicine() async {
    if (!_isFormValid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final payload = {
        "name": _nameCtrl.text.trim(),
        "description":
            _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        "feed_type": _feedType,
        "uom": _uomCtrl.text.trim(),
      }..removeWhere((k, v) => v == null);

      final newFeedMedicine = await ref
          .read(getMasterDataListUseCaseProvider)
          .createFeedMedicine(payload);

      // Invalidate providers
      ref.invalidate(paginatedFeedMedicineProvider);
      ref.invalidate(feedMedicineListProvider);

      if (mounted) {
        SuccessNotification.show(
          title: "Berhasil",
          subtitle: "Pakan/Obat baru berhasil ditambahkan",
        );
        Navigator.pop(context, newFeedMedicine);
      }
    } on DioException catch (e) {
      if (mounted) {
        String errorMessage = "Gagal menambahkan pakan/obat";
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'].toString();
        } else if (e.message != null) {
          errorMessage = e.message!;
        }
        SuccessNotification.showError(
          title: "Gagal Menambahkan Pakan/Obat",
          subtitle: errorMessage,
        );
      }
    } catch (e) {
      if (mounted) {
        SuccessNotification.showError(
          title: "Gagal Menambahkan Pakan/Obat",
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
          "Tambah Pakan / Obat",
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
                  SectionCard(
                    title: "Informasi Pakan / Obat",
                    children: [
                      TextFields(
                        label: "Nama Pakan / Obat",
                        hint: "Masukkan nama pakan atau obat",
                        isMandatoryField: true,
                        controller: _nameCtrl,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      AppRadioGroup<String>(
                        title: "Tipe",
                        isMandatoryField: true,
                        value: _feedType,
                        options: const ["pakan", "obat"],
                        labelBuilder: (v) =>
                            v == "pakan" ? "Pakan" : "Obat",
                        onChanged: (v) {
                          setState(() {
                            _feedType = v;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFields(
                        label: "Satuan (UOM)",
                        hint: "Contoh: kg, liter, botol, sachet, pcs",
                        isMandatoryField: true,
                        controller: _uomCtrl,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      TextFields(
                        label: "Deskripsi",
                        hint: "Masukkan deskripsi (opsional)",
                        maxLines: 3,
                        controller: _descCtrl,
                        onChanged: (_) => setState(() {}),
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
                  onPressed: _isFormValid && !_isLoading
                      ? _submitFeedMedicine
                      : null,
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
                          "Simpan",
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
