import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';

import '../../../../core/theme/AppTypography.dart';
import '../widgets/confirmation_bottom_sheet.dart';

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
                _stepCard(),
                const SizedBox(height: 12),
                _infoPenerimaan(),
                const SizedBox(height: 12),
                _pohInfo(),
                const SizedBox(height: 12),
                _itemInfo(),
              ],
            ),
          ),

          /// BOTTOM BUTTON
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
                child: const Text(
                  "Konfirmasi Penerimaan",
                  style: TextStyle(fontWeight: FontWeight.w700),
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

  /// INFORMASI PENERIMAAN
  Widget _infoPenerimaan() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Informasi Penerimaan",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12),
          Text("14 Nov 2025"),
          SizedBox(height: 4),
          Text("-", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  /// POH INFO
  Widget _pohInfo() {
    return _card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "POH-2511-0009",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              _StatusChip(label: "Dikonfirmasi", color: Colors.green),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Text(
                "2 hewan • ",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                "Lunas",
                style: TextStyle(fontSize: 12, color: Colors.green),
              ),
              Spacer(),
              Text(
                "0 Diterima",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ahmad Umar",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Nama Pemasok",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "30 Okt 2025",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Tanggal Pembelian",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// INFORMASI ITEM
  Widget _itemInfo() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Item",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          _itemCard(
            kode: "00001",
            berat: "315 kg",
            umur: "14 Bulan",
            potong: "31.5 kg",
            harga: "Rp 23.000.000",
            vaksin: "Vaksin 12/",
          ),

          const SizedBox(height: 12),

          _itemCard(
            kode: "00002",
            berat: "10 kg",
            umur: "14 Bulan",
            potong: "10 kg",
            harga: "Rp 8.000.000",
          ),
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
