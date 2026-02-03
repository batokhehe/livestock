import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/product_header_card.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/custom_date_picker_sheet.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../../core/widgets/step_info_card.dart';
import '../../sales_order_provider.dart';

class AddSalesOrderPage extends ConsumerStatefulWidget {
  const AddSalesOrderPage({super.key});

  @override
  ConsumerState<AddSalesOrderPage> createState() => _AddSalesOrderPageState();
}

class _AddSalesOrderPageState extends ConsumerState<AddSalesOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Penjualan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                StepInfoCard(
                  title: "Informasi Pesanan Penjualan",
                  step: 1,
                  totalStep: 3,
                ),
                SizedBox(height: 12),
                _SalesOrderInfoSection(),
                SizedBox(height: 12),
                _FarmInfoSection(),
              ],
            ),
          ),
          const _NextButton(),
        ],
      ),
    );
  }
}

class _SalesOrderInfoSection extends ConsumerWidget {
  const _SalesOrderInfoSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesOrderSelectedDate = ref.watch(salesOrderDateProvider);
    final paymentSelectedDate = ref.watch(paymentDateProvider);

    final salesOrderDateText = salesOrderSelectedDate == null
        ? 'Pilih Tanggal'
        : DateFormat('dd MMM yyyy', 'id_ID').format(salesOrderSelectedDate);

    final paymentDateText = paymentSelectedDate == null
        ? 'Pilih Tanggal'
        : DateFormat('dd MMM yyyy', 'id_ID').format(paymentSelectedDate);

    return SectionCard(
      title: "Informasi Penjualan",
      children: [
        SelectField(
          label: "Tanggal Penjualan",
          hint: salesOrderDateText,
          icon: AppImages.icCalendarSearch,
          onTap: () async {
            final pickedDate = await showModalBottomSheet<DateTime?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const CustomDatePickerSheet(),
            );

            if (pickedDate != null) {
              ref.read(salesOrderDateProvider.notifier).state = pickedDate;
            }
          },
        ),
        SizedBox(height: 12),
        SelectField(
          label: "Tanggal Pelunasan",
          hint: paymentDateText,
          icon: AppImages.icCalendarSearch,
          onTap: () async {
            final pickedDate = await showModalBottomSheet<DateTime?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const CustomDatePickerSheet(),
            );

            if (pickedDate != null) {
              ref.read(paymentDateProvider.notifier).state = pickedDate;
            }
          },
        ),
        SizedBox(height: 12),
        SelectField(
          label: "Nama Pelanggan",
          hint: "Pilih Pelanggan",
          icon: AppImages.icUserTag,
        ),
        SizedBox(height: 12),
        TextFieldWithInnerCounter(
          label: "Catatan",
          subLabel: "(Optional)",
          hint: "Masukkan catatan",
          maxLength: 80,
        ),
      ],
    );
  }
}

class _FarmInfoSection extends StatelessWidget {
  const _FarmInfoSection();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Informasi Peternakan",
      children: const [
        SelectField(
          label: "Lokasi peternakan",
          hint: "Pilih lokasi",
          icon: AppImages.icHomeHashTag,
        ),
        SizedBox(height: 12),
        SelectField(
          label: "Area peternakan",
          hint: "Pilih area",
          icon: AppImages.icMap,
        ),
        SizedBox(height: 12),
        CardWrapper(
          child: ProductHeaderCard(
            title: "3 Hewan",
            subtitle: "Hewan Tersedia",
            image: AppImages.icProduct,
          ),
        ),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
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
            onPressed: () {
              context.push('/SalesOrder/add/step-2');
            },
            child: Text("Selanjutnya", style: AppTypography.mediumBoldWhite),
          ),
        ),
      ),
    );
  }
}
