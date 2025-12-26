import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/widgets/text_field_disabled.dart';
import 'package:livestock/features/receiving/presentation/widgets/poh_item_card.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/border_card.dart';
import '../../receiving_provider.dart' as receiving;
import '../widgets/confirmation_bottom_sheet.dart';
import '../widgets/receiving_detail_card.dart';
import '../widgets/receiving_item_double_card.dart';
import '../widgets/step_info_card.dart';
import '../widgets/upload_file_card.dart';

class AddReceivingConfirmationPage extends StatelessWidget {
  const AddReceivingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Penerimaan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepInfoCard(
                  title: "Tinjau Penerimaan",
                  step: 3,
                  totalStep: 3,
                ),
                const SizedBox(height: 12),
                _infoReceiving(),
                const SizedBox(height: 12),
                PohItemCard(item: dummyItem),
                const SizedBox(height: 12),
                _infoItem(),
                const SizedBox(height: 12),
                UploadFileCard(onTap: () {}),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const ConfirmationBottomSheet(),
                  );
                },
                child: Text(
                  "Konfirmasi Penerimaan",
                  style: AppTypography.mediumBoldWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// STEP CARD
  Widget _stepCard() {
    return _card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tinjau Penerimaan",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 4),
              Text(
                "Langkah 3/3",
                style: TextStyle(fontSize: 12, color: Colors.orange),
              ),
            ],
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _infoReceiving() {
    return BorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Penerimaan",
            style: AppTypography.mediumNormalBlack,
          ),
          const SizedBox(height: 12),
          TextFieldDisabled(value: "14 Nov 2025"),
        ],
      ),
    );
  }

  Widget _infoItem() {
    return BorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Item", style: AppTypography.mediumNormalBlack),
          const SizedBox(height: 12),
          ReceivingItemDoubleCard(item: dummyItem),
          ...receiving.items.map((e) => ReceivingDetailCard(item: e)),
        ],
      ),
    );
  }

  /// ITEM CARD
  Widget _itemCard({
    required String kode,
    required String berat,
    required String umur,
    required String potong,
    required String harga,
    String? vaksin,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("00001", style: TextStyle(fontWeight: FontWeight.w700)),
              _StatusChip(label: "Diperiksa", color: Colors.green),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Sapi Besar • Jantan",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _tag(umur),
              _tag(potong),
              _tag(harga, color: Colors.orange),
              if (vaksin != null) _tag(vaksin),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "$berat\nCatatan",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// CARD WRAPPER
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  static Widget _tag(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: color ?? Colors.grey,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// STATUS CHIP
class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
