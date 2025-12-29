import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/input_field_card.dart';

import '../../../../core/widgets/text_field_with_inner_counter.dart';

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
                          TextFields(
                            label: "Kode Hewan",
                            initial: "0001",
                            enabled: false,
                          ),
                          TextFields(
                            label: "Nama Hewan",
                            initial: "Black Mamba",
                            enabled: false,
                          ),
                          TextFields(
                            label: "Kode Ref. Hewan",
                            initial: "SP001",
                            enabled: false,
                          ),
                          TextFields(label: "Umur", initial: "14"),
                          TextFields(label: "POEL", initial: "POEL-001"),
                          Dropdowns(
                            label: "Jenis Kelamin",
                            value: "Jantan",
                            icon: AppImages.icMan,
                            enabled: false,
                          ),
                          Dropdowns(
                            label: "Grup hewan",
                            value: "Sapi Besar",
                            icon: AppImages.icProduct,
                          ),
                          Dropdowns(
                            label: "Status hewan",
                            value: "Aktif",
                            icon: AppImages.icStatus,
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: const [
                              Expanded(
                                child: TextFields(
                                  label: "Berat",
                                  initial: "130.00",
                                  suffix: "kg",
                                  enabled: false,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextFields(
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
                          Dropdowns(
                            label: "Lokasi peternakan",
                            value: "Sapi Agri Banten",
                            enabled: false,
                            icon: AppImages.icHomeHashTag,
                          ),
                          Dropdowns(
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
                          TextFields(
                            label: "Harga Beli",
                            initial: "Rp 25.000.000",
                            enabled: false,
                          ),
                          TextFields(
                            label: "Ref Harga Jual (kg)",
                            initial: "Rp 401.282",
                            enabled: false,
                          ),
                          TextFields(
                            label: "Ref Total Harga Jual",
                            initial: "Rp 26.083.000",
                            enabled: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    TextFieldWithInnerCounter(
                      label: 'Catatan',
                      subLabel: '(Opsional)',
                      hint: 'Masukkan catatan',
                      maxLength: 80,
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
