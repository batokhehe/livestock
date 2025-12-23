import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';

class UpdateProductPage extends StatelessWidget {
  const UpdateProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Perbarui Data Hewan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _Section(
                      title: "Informasi Hewan",
                      child: Column(
                        children: [
                          _TextField(
                            label: "Kode Hewan",
                            initial: "0001",
                            enabled: false,
                          ),
                          _TextField(
                            label: "Nama Hewan",
                            initial: "Black Mamba",
                            enabled: false,
                          ),
                          _TextField(
                            label: "Kode Ref. Hewan",
                            initial: "SP001",
                            enabled: false,
                          ),
                          _TextField(label: "Umur", initial: "14"),
                          _TextField(label: "POEL", initial: "POEL-001"),
                          _Dropdown(
                            label: "Jenis Kelamin",
                            value: "Jantan",
                            icon: AppImages.icMan,
                            enabled: false,
                          ),
                          _Dropdown(
                            label: "Grup hewan",
                            value: "Sapi Besar",
                            icon: AppImages.icProduct,
                          ),
                          _Dropdown(
                            label: "Status hewan",
                            value: "Aktif",
                            icon: AppImages.icStatus,
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: const [
                              Expanded(
                                child: _TextField(
                                  label: "Berat",
                                  initial: "130.00",
                                  suffix: "kg",
                                  enabled: false,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _TextField(
                                  label: "Berat Hari Ini",
                                  initial: "160.00",
                                  suffix: "kg",
                                  enabled: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _Section(
                      title: "Informasi Peternakan",
                      child: Column(
                        children: const [
                          _Dropdown(
                            label: "Lokasi peternakan",
                            value: "Sapi Agri Banten",
                            enabled: false,
                            icon: AppImages.icHomeHashTag,
                          ),
                          _Dropdown(
                            label: "Area peternakan",
                            value: "Area brown field",
                            enabled: false,
                            icon: AppImages.icMap,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _Section(
                      title: "Informasi Hewan",
                      child: Column(
                        children: const [
                          _TextField(
                            label: "Harga Beli",
                            initial: "Rp 25.000.000",
                            enabled: false,
                          ),
                          _TextField(
                            label: "Ref Harga Jual (kg)",
                            initial: "Rp 401.282",
                            enabled: false,
                          ),
                          _TextField(
                            label: "Ref Total Harga Jual",
                            initial: "Rp 26.083.000",
                            enabled: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _Section(
                      title: "Informasi Lainnya",
                      child: Column(
                        children: const [
                          _TextField(
                            label: "Catatan (Opsional)",
                            hint: "Masukkan catatan",
                            maxLines: 3,
                            showCounter: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Simpan Perubahan",
                    style: AppTypography.mediumBoldWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.smallNormalBlack),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? initial;
  final String? suffix;
  final int maxLines;
  final bool showCounter;
  final bool enabled;

  const _TextField({
    required this.label,
    this.hint,
    this.initial,
    this.suffix,
    this.maxLines = 1,
    this.showCounter = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: enabled
                ? AppTypography.smallBoldBlack
                : AppTypography.smallBoldGrey,
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initial,
            enabled: enabled,
            maxLines: maxLines,
            maxLength: showCounter ? 80 : null,
            style: enabled
                ? AppTypography.smallBoldBlack
                : AppTypography.smallBoldGrey,
            decoration: InputDecoration(
              hintText: hint,
              counterText: showCounter ? null : "",
              suffixText: suffix,
              filled: true,
              fillColor: enabled ? AppColors.white : AppColors.greyBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.fieldBorder,
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.grey2, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String label;
  final String value;
  final String? icon;
  final bool enabled;

  const _Dropdown({
    required this.label,
    required this.value,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: enabled
                ? AppTypography.smallBoldBlack
                : AppTypography.smallBoldGrey,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: enabled ? AppColors.white : AppColors.greyBg,
              border: Border.all(
                color: enabled ? AppColors.fieldBorder : AppColors.grey2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Image.asset(icon!, width: 14, height: 14),
                  const SizedBox(width: 8),
                ],

                /// VALUE
                Expanded(
                  child: Text(
                    value,
                    style: enabled
                        ? AppTypography.smallNormalBlack
                        : AppTypography.smallNormalGrey,
                  ),
                ),

                /// CHEVRON
                Icon(
                  Icons.chevron_right,
                  color: enabled ? Colors.grey : Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
