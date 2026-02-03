import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/product_header_card.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required String productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Detail Hewan", style: AppTypography.largeBoldBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            _ProductInfoCard(),
            SizedBox(height: 12),
            _LocationInfoCard(),
            SizedBox(height: 12),
            _PriceInfoCard(),
            SizedBox(height: 12),
            _AnotherInfoCard(),
            SizedBox(height: 24),
            _UpdateButton(),
          ],
        ),
      ),
    );
  }
}

class _ProductInfoCard extends StatelessWidget {
  const _ProductInfoCard();

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: "Informasi Hewan",
      child: Column(
        children: [
          ProductHeaderCard(
            title: "0001",
            subtitle: "Black Mamba",
            image: AppImages.icProduct,
            isActive: true,
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          _twoColumnRow(
            leftValue: "Sapi Besar",
            leftLabel: "Grup hewan",
            rightValue: "POEL-001",
            rightLabel: "POEL",
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          _twoColumnRow(
            leftValue: "22 Sep 2025",
            leftLabel: "Tanggal Timbang",
            rightValue: "130.00 kg",
            rightLabel: "Berat",
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          _twoColumnRow(
            leftValue: "18 Nov 2025",
            leftLabel: "Pemantauan Akhir",
            rightValue: "160.00 kg",
            rightLabel: "Berat Hari Ini",
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          _twoColumnRow(
            leftValue: "14 bulan",
            leftLabel: "Umur",
            rightValue: "B 6792 CM",
            rightLabel: "Nomor Kendaraan",
          ),
        ],
      ),
    );
  }
}

Widget _twoColumnRow({
  required String leftValue,
  required String leftLabel,
  required String rightValue,
  required String rightLabel,
}) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(
          child: _InfoItem(value: leftValue, label: leftLabel, alignEnd: false),
        ),
        Expanded(
          child: _InfoItem(
            value: rightValue,
            label: rightLabel,
            alignEnd: true,
          ),
        ),
      ],
    ),
  );
}

class _InfoItem extends StatelessWidget {
  final String value;
  final String label;
  final bool alignEnd;

  const _InfoItem({
    required this.value,
    required this.label,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.smallBoldBlack),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.xSmallNormalGrey),
      ],
    );
  }
}

class _LocationInfoCard extends StatelessWidget {
  const _LocationInfoCard();

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: "Informasi Peternakan",
      child: ProductHeaderCard(
        title: "Sapi Agri Banten",
        subtitle: "Area brown field",
        image: AppImages.icField,
        isActive: false,
      ),
    );
  }
}

class _PriceInfoCard extends StatelessWidget {
  const _PriceInfoCard();

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: "Informasi Harga",
      child: Column(
        children: [
          ProductHeaderCard(
            title: "Rp. 25.000.000",
            subtitle: "Harga Beli",
            image: AppImages.icMoneys,
            isActive: false,
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          _twoColumnRow(
            leftValue: "Rp 401.282",
            leftLabel: "Ref Harga Jual (kg)",
            rightValue: "Rp 26.083.000",
            rightLabel: "Harga Beli",
          ),
        ],
      ),
    );
  }
}

class _AnotherInfoCard extends StatelessWidget {
  const _AnotherInfoCard();

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: "Informasi Lainnya",
      child: Column(
        children: [
          ProductHeaderCard(
            title: "H. Imron  Sigit Purawa",
            subtitle: "Nama Pelanggan",
            image: AppImages.icUserTag,
            isActive: false,
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          _twoColumnRow(
            leftValue: "Catatan",
            leftLabel: "-",
            rightValue: "",
            rightLabel: "",
          ),
        ],
      ),
    );
  }
}

class _CardWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.smallNormalBlack),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [child],
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateButton extends StatelessWidget {
  const _UpdateButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryShade,
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          context.push("/product-update");
        },
        child: const Text("Perbarui Data"),
      ),
    );
  }
}
