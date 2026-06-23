import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/features/purchase_order/data/model/purchase_order_list_model.dart';
import 'package:livestock/features/receiving/presentation/widgets/confirmation_bottom_sheet.dart';
import 'package:livestock/features/purchase_order/presentation/views/create_invoice/widgets/purchase_order_detail_invoice_bottom_sheet.dart';

import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/core/widgets/section_card.dart';
import 'package:livestock/core/widgets/select_field.dart';
import 'package:livestock/core/data/model/payment_type_model.dart';
import 'package:livestock/core/data/model/chart_of_account_model.dart';

import 'package:livestock/features/purchase_order/purchase_order_provider.dart';
import 'package:livestock/features/purchase_order/presentation/views/create_invoice/purchase_invoice_provider.dart';
import 'package:livestock/core/data/model/bank_account_model.dart';

import '../../../../../core/widgets/success_notification.dart';
import '../../../../../core/widgets/custom_date_picker_sheet.dart';

class CreatePurchaseOrderInvoicePage extends ConsumerStatefulWidget {
  final PurchaseOrderList item;

  const CreatePurchaseOrderInvoicePage({super.key, required this.item});

  @override
  ConsumerState<CreatePurchaseOrderInvoicePage> createState() =>
      _CreatePurchaseOrderInvoicePageState();
}

class _CreatePurchaseOrderInvoicePageState
    extends ConsumerState<CreatePurchaseOrderInvoicePage> {
  late final TextEditingController _amountController;

  final statusList = [
    {'label': 'Uang Muka', 'value': 'down_payment'},
    {'label': 'Pembayaran Sebagian', 'value': 'partial'},
    {'label': 'Pelunasan', 'value': 'full_payment'},
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: formatPrice(widget.item.amountRemainder.toInt()),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(purchaseInvoiceFormProvider.notifier)
          .setAmount(widget.item.amountRemainder.toDouble());
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invoiceState = ref.watch(purchaseInvoiceFormProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text("Buat Nota", style: AppTypography.largeBoldBlack),
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SectionCard(
                  title: "Informasi Item Pembelian",
                  children: [_buildSummaryCard()],
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: "Informasi Nota",
                  children: [
                    SelectField(
                      label: "Tanggal nota",
                      isMandatoryField: true,
                      hint: formatDateString(invoiceState.date.toString()),
                      icon: AppImages.icCalendarTick,
                      onTap: _showDatePicker,
                    ),
                    const SizedBox(height: 12),
                    SelectField(
                      label: "Status pembayaran",
                      isMandatoryField: true,
                      hint: invoiceState.paymentStatusLabel ?? "Pilih status",
                      icon: AppImages.icMoneyTick,
                      onTap: _showPaymentStatusBottomSheet,
                    ),
                    const SizedBox(height: 12),
                    SelectField(
                      label: "Tipe pembayaran",
                      isMandatoryField: true,
                      hint: invoiceState.paymentType?.name ?? "Pilih tipe",
                      icon: AppImages.icMoneyTimeSvg,
                      onTap: _showPaymentTypeBottomSheet,
                    ),
                    if (invoiceState.paymentType?.name == "Bank Transfer") ...[
                      const SizedBox(height: 12),
                      SelectField(
                        label: "Pilih Bank",
                        isMandatoryField: true,
                        hint:
                            invoiceState.bankAccount?.displayName ??
                            "Pilih bank",
                        icon: AppImages.icWalletCheck,
                        onTap: _showBankAccountBottomSheet,
                      ),
                    ],
                    const SizedBox(height: 12),
                    SelectField(
                      label: "Akun keuangan",
                      isMandatoryField: true,
                      hint: invoiceState.chartOfAccount?.name ?? "Pilih akun",
                      icon: AppImages.icWalletCheck,
                      onTap: _showAccountBottomSheet,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.fieldBorder),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: invoiceState.setoranStatus,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              onChanged: (value) {
                                ref
                                    .read(purchaseInvoiceFormProvider.notifier)
                                    .setSetoranStatus(value ?? false);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Status Setoran",
                                  style: AppTypography.smallBoldBlack,
                                ),
                                Text(
                                  "Harap centang jika pembayaran sudah diverifikasi",
                                  style: AppTypography.xSmallNormalGrey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFields(
                      label: "Jumlah pembayaran",
                      isMandatoryField: true,
                      hint: "Rp 0",
                      prefixText: "Rp ",
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [CurrencyInputFormatter()],
                      onChanged: (value) {
                        final rawValue = value.replaceAll('.', '');
                        double amount = double.tryParse(rawValue) ?? 0;
                        if (amount > widget.item.amountRemainder) {
                          amount = widget.item.amountRemainder.toDouble();
                          _amountController.text = formatPrice(amount.toInt());
                          _amountController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _amountController.text.length),
                          );
                        }
                        ref
                            .read(purchaseInvoiceFormProvider.notifier)
                            .setAmount(amount);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFields(
                      label: "Catatan",
                      hint: "Masukkan catatan nota (opsional)",
                      onChanged: (value) {
                        ref
                            .read(purchaseInvoiceFormProvider.notifier)
                            .setNotes(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: "Lainnya",
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.fieldBorder),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  invoiceState.imageFile != null
                                      ? invoiceState.imageFile!.path
                                            .split('/')
                                            .last
                                      : "Bukti Transfer / Nota",
                                  style: AppTypography.smallBoldBlack,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  invoiceState.imageFile != null
                                      ? "File berhasil dipilih"
                                      : "Pastikan bukti terlihat jelas!",
                                  style: AppTypography.xSmallNormalGrey,
                                ),
                                if (invoiceState.imageFile != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        invoiceState.imageFile!,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _showUploadBottomSheet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFF7E6),
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              invoiceState.imageFile != null
                                  ? "Ganti"
                                  : "Unggah",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: "Ringkasan Faktur",
                  children: [
                    Text("Rincian Bayar", style: AppTypography.smallBoldBlack),
                    const SizedBox(height: 12),
                    _rowSummary("Pesanan Pembelian", widget.item.purchOrderNo),
                    _rowSummary(
                      "Nama Supplier",
                      widget.item.supplierName ?? "-",
                    ),
                    _rowSummary(
                      "Tipe Pembayaran",
                      invoiceState.paymentType?.name ?? "-",
                    ),
                    _rowSummary(
                      "Akun keuangan",
                      invoiceState.chartOfAccount?.name ?? "-",
                    ),
                    _rowSummary(
                      "Status pembayaran",
                      invoiceState.paymentStatusLabel ?? "-",
                    ),
                    const Divider(
                      height: 24,
                      thickness: 1,
                      color: AppColors.fieldBorder,
                    ),
                    _rowSummary(
                      "Total Item",
                      widget.item.details.length.toString(),
                    ),
                    _rowSummary(
                      "Sub Total",
                      "Rp ${formatPrice(widget.item.amountPurchased)}",
                    ),
                    _rowSummary(
                      "Biaya Pengiriman",
                      "Rp ${formatPrice(widget.item.shippingCost)}",
                    ),
                    _rowSummary(
                      "Total keseluruhan",
                      "Rp ${formatPrice(widget.item.amountTotal)}",
                    ),
                    _rowSummary(
                      "Jumlah dibayar",
                      "Rp ${formatPrice((invoiceState.amount ?? 0).toInt())}",
                      isBold: true,
                    ),
                    _rowSummary(
                      "Sisa Pembayaran",
                      "Rp ${formatPrice((widget.item.amountRemainder - (invoiceState.amount ?? 0)).toInt().clamp(0, 999999999))}",
                      isBold: true,
                      valueColor:
                          (widget.item.amountRemainder -
                                  (invoiceState.amount ?? 0)) <=
                              0
                          ? AppColors.emerald700
                          : AppColors.danger,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _bottomButton(invoiceState),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final item = widget.item;
    return InkWell(
      onTap: _showDetailBottomSheet,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.fieldBorder.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.purchOrderNo,
                    style: AppTypography.mediumBoldBlack.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item.details.length} item • ${item.supplierName ?? '-'}",
                    style: AppTypography.smallNormalBlack,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 5,
                children: [
                  _statusChip(item.purchStatus),
                  Text(
                    "Rp${formatPrice(item.amountTotal)}",
                    style: AppTypography.smallBoldBlack,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors.grey),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(status, style: AppTypography.xSmallBoldPrimary),
    );
  }

  void _showDetailBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PurchaseOrderDetailInvoiceBottomSheet(item: widget.item),
    );
  }

  Future<void> _onNext() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ConfirmationBottomSheet(
        header: "Konfirmasi",
        title: "Lanjutkan Pembuatan Nota?",
        subTitle:
            "Mohon pastikan semua item dan detail sudah sesuai sebelum menyimpan data",
        saveText: "Simpan Nota",
      ),
    );

    if (result == true) {
      try {
        await ref
            .read(purchaseInvoiceFormProvider.notifier)
            .submitInvoice(widget.item);

        SuccessNotification.show(
          title: "Nota Berhasil Dibuat",
          subtitle: "Dokumen nota pembelian telah berhasil disimpan.",
        );

        if (mounted) {
          ref.invalidate(purchaseOrderDetailProvider(widget.item.id));
          ref.invalidate(purchaseOrderListProvider);
          await ref
              .read(purchaseInvoiceListProvider(widget.item.id).notifier)
              .fetchInvoices();
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = e.toString();
          if (e is DioException) {
            errorMessage =
                e.response?.data['message'] ?? e.message ?? e.toString();
          }
          SuccessNotification.showError(
            title: "Gagal Membuat Nota",
            subtitle: errorMessage,
          );
        }
      }
    }
  }

  void _showUploadBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Pilih Sumber Gambar",
                  style: AppTypography.mediumBoldBlack,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildUploadOption(
                        icon: Icons.camera_alt_rounded,
                        label: "Kamera",
                        onTap: () => _pickImage(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildUploadOption(
                        icon: Icons.photo_library_rounded,
                        label: "Galeri",
                        onTap: () => _pickImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 12),
            Text(label, style: AppTypography.smallBoldBlack),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      ref
          .read(purchaseInvoiceFormProvider.notifier)
          .setImageFile(File(pickedFile.path));
    }
  }

  Widget _buildSelectionCard({
    required String title,
    String? subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.fieldBorder.withValues(alpha: 0.5),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.smallBoldBlack.copyWith(
                        color: isSelected ? AppColors.primary : null,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(subtitle, style: AppTypography.xSmallNormalGrey),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final pickedDate = await showModalBottomSheet<DateTime?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CustomDatePickerSheet(),
    );

    if (pickedDate != null) {
      ref.read(purchaseInvoiceFormProvider.notifier).setDate(pickedDate);
    }
  }

  void _showPaymentStatusBottomSheet() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Text(
                    "Pilih Status Pembayaran",
                    style: AppTypography.mediumBoldBlack,
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...statusList.map((status) {
                          final isSelected =
                              ref
                                  .read(purchaseInvoiceFormProvider)
                                  .paymentStatus ==
                              status['value'];
                          return _buildSelectionCard(
                            title: status['label']!,
                            isSelected: isSelected,
                            onTap: () => Navigator.pop(context, status),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      ref
          .read(purchaseInvoiceFormProvider.notifier)
          .setPaymentStatus(result['value']!, result['label']!);

      // Auto-fill amount based on status
      if (result['value'] == 'full_payment') {
        final amount = widget.item.amountRemainder.toDouble();
        _amountController.text = formatPrice(amount.toInt());
        ref.read(purchaseInvoiceFormProvider.notifier).setAmount(amount);
      }
    }
  }

  void _showBankAccountBottomSheet() async {
    final result = await showModalBottomSheet<BankAccount>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Consumer(
            builder: (context, ref, child) {
              final banksAsync = ref.watch(purchaseBankAccountListProvider);
              final invoiceState = ref.watch(purchaseInvoiceFormProvider);

              return banksAsync.when(
                data: (banks) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Text(
                          "Pilih Bank",
                          style: AppTypography.mediumBoldBlack,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (banks.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text("Tidak ada data bank"),
                                ),
                              ...banks.map((bank) {
                                final isSelected =
                                    invoiceState.bankAccount?.id == bank.id;
                                return _buildSelectionCard(
                                  title: bank.bankName ?? "-",
                                  subtitle:
                                      "${bank.accountNumber} (${bank.accountHolderName})",
                                  isSelected: isSelected,
                                  onTap: () => Navigator.pop(context, bank),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => SizedBox(
                  height: 200,
                  child: Center(child: Text("Error: $e")),
                ),
              );
            },
          ),
        );
      },
    );

    if (result != null) {
      ref.read(purchaseInvoiceFormProvider.notifier).setBankAccount(result);
    }
  }

  void _showPaymentTypeBottomSheet() async {
    final result = await showModalBottomSheet<PaymentType>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Consumer(
            builder: (context, ref, child) {
              final typesAsync = ref.watch(purchasePaymentTypeListProvider);
              final invoiceState = ref.watch(purchaseInvoiceFormProvider);

              return typesAsync.when(
                data: (types) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Text(
                          "Pilih Tipe Pembayaran",
                          style: AppTypography.mediumBoldBlack,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (types.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text("Tidak ada data tipe pembayaran"),
                                ),
                              ...types.map((type) {
                                final isSelected =
                                    invoiceState.paymentType?.id == type.id;
                                return _buildSelectionCard(
                                  title: type.name,
                                  isSelected: isSelected,
                                  onTap: () => Navigator.pop(context, type),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => SizedBox(
                  height: 200,
                  child: Center(child: Text("Error: $e")),
                ),
              );
            },
          ),
        );
      },
    );

    if (result != null) {
      ref.read(purchaseInvoiceFormProvider.notifier).setPaymentType(result);
    }
  }

  void _showAccountBottomSheet() async {
    final result = await showModalBottomSheet<ChartOfAccount>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Consumer(
            builder: (context, ref, child) {
              final accountsAsync = ref.watch(
                purchaseChartOfAccountListProvider,
              );
              final invoiceState = ref.watch(purchaseInvoiceFormProvider);

              return accountsAsync.when(
                data: (accounts) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Text(
                          "Pilih Akun Keuangan",
                          style: AppTypography.mediumBoldBlack,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (accounts.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text("Tidak ada data akun keuangan"),
                                ),
                              ...accounts.map((account) {
                                final isSelected =
                                    invoiceState.chartOfAccount?.id ==
                                    account.id;
                                return _buildSelectionCard(
                                  title: account.name,
                                  subtitle: account.code,
                                  isSelected: isSelected,
                                  onTap: () => Navigator.pop(context, account),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => SizedBox(
                  height: 200,
                  child: Center(child: Text("Error: $e")),
                ),
              );
            },
          ),
        );
      },
    );

    if (result != null) {
      ref.read(purchaseInvoiceFormProvider.notifier).setChartOfAccount(result);
    }
  }

  Widget _bottomButton(dynamic invoiceState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.fieldBorder)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: (invoiceState.isValid &&
                      !invoiceState.isLoading &&
                      (invoiceState.amount ?? 0) <= widget.item.amountRemainder)
              ? _onNext
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: invoiceState.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text("Simpan Nota", style: AppTypography.mediumBoldWhite),
        ),
      ),
    );
  }

  Widget _rowSummary(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.smallNormalGrey),
          Text(
            value,
            style: isBold
                ? AppTypography.smallBoldBlack.copyWith(color: valueColor)
                : AppTypography.smallNormalBlack.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
