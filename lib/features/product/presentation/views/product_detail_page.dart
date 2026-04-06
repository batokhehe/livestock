import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/product_header_card.dart';

import '../../../../app/providers.dart';
import '../../../../core/data/model/animal_profile_model.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/helpers/utils.dart';
import '../../../../core/widgets/two_column_row_card.dart';

class ProductDetailPage extends ConsumerWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(animalDetailProvider(productId));

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
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (animal) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _ProductInfoCard(data: animal),
                const SizedBox(height: 12),
                _LocationInfoCard(data: animal),
                const SizedBox(height: 12),
                _PriceInfoCard(data: animal),
                const SizedBox(height: 12),
                _AnotherInfoCard(data: animal),
                const SizedBox(height: 24),
                const _UpdateButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProductInfoCard extends StatelessWidget {
  final AnimalProfile data;

  const _ProductInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: "Informasi Hewan",
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: ProductHeaderCard(
              title: data.animalCode,
              subtitle: data.name,
              image: AppImages.icProduct,
              status: data.available,
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: TwoColumnRowCard(
              leftValue: data.animalGroup?.name ?? "-",
              leftLabel: "Grup hewan",
              rightValue: data.poel ?? "-",
              rightLabel: "POEL",
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: TwoColumnRowCard(
              leftValue: data.age.toString(),
              leftLabel: "Umur",
              rightValue: "${data.weight} kg",
              rightLabel: "Berat",
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationInfoCard extends StatelessWidget {
  final AnimalProfile data;

  const _LocationInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: "Informasi Peternakan",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: ProductHeaderCard(
          title: data.farmLocation?.name ?? "-",
          subtitle: data.farmArea?.name ?? "-",
          image: AppImages.icField,
          isActive: false,
        ),
      ),
    );
  }
}

class _PriceInfoCard extends StatelessWidget {
  final AnimalProfile data;

  const _PriceInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: "Informasi Harga",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            /*ProductHeaderCard(
              title: 'Rp ${formatPrice(data.purchPrice)}',
              subtitle: "Harga Beli",
              image: AppImages.icMoneys,
              isActive: false,
            ),
            SizedBox(height: 8),*/
            Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
            TwoColumnRowCard(
              leftValue: 'Rp ${formatPrice(data.refSalesPrice)}',
              leftLabel: "Ref Harga Jual (kg)",
              rightValue: data.currentClassName ?? "-",
              rightLabel: "Kelas Hewan",
            ),
            SizedBox(height: 8),
            TwoColumnRowCard(
              leftValue: 'Rp ${formatPrice(data.refSalesPriceTotal)}',
              leftLabel: "Ref Harga Total",
              rightValue: 'Rp ${formatPrice(data.currentClassPrice ?? 0)}',
              rightLabel: "Harga Kelas",
            ),
          ],
        ),
      ),
    );
  }
}

class _AnotherInfoCard extends StatelessWidget {
  final AnimalProfile data;

  const _AnotherInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final hasNoData =
        data.salesOrderCustomerName.isEmpty ||
        equalsIgnoreCase(data.salesOrderCustomerName, '-');

    return _CardWrapper(
      title: "Informasi Lainnya",
      child: hasNoData
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  "Belum ada data",
                  style: AppTypography.xSmallBoldGrey,
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: ProductHeaderCard(
                    title: data.salesOrderCustomerName,
                    subtitle: "Nama Pelanggan",
                    image: AppImages.icUserTag,
                    isActive: false,
                  ),
                ),
                Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: TwoColumnRowCard(
                    leftValue: "Catatan",
                    leftLabel: data.notes ?? "-",
                    rightValue: "",
                    rightLabel: "",
                  ),
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
        onPressed: null,
        /*onPressed: () {
          context.push("/product-update");
        },*/
        child: const Text("Perbarui Data"),
      ),
    );
  }
}
