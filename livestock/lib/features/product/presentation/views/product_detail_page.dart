import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
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
          _header("0001", "Black Mamba", AppImages.icProduct, true),
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

Widget _header(String title, String subtitle, String image, bool isShow) {
  return Padding(
    padding: EdgeInsetsGeometry.all(8),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryShade,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(image, width: 24, height: 24),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.smallBoldBlack),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTypography.smallNormalGrey),
            ],
          ),
        ),

        isShow
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("Aktif", style: AppTypography.xSmallNormalGreen),
              )
            : SizedBox.shrink(),
      ],
    ),
  );
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
      child: _header(
        "Sapi Agri Banten",
        "Area brown field",
        AppImages.icField,
        false,
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
          _header("Rp. 25.000.000", "Harga Beli", AppImages.icMoneys, false),
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
          _header(
            "H. Imron  Sigit Purawa",
            "Nama Pelanggan",
            AppImages.icUserTag,
            false,
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

class _RowItem extends StatelessWidget {
  final String label;
  final String value;

  const _RowItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.smallNormalGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.smallNormalBlack,
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
