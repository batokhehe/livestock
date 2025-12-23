import 'package:flutter/material.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../data/receiving_item_model.dart';
import '../../data/receiving_model.dart';

class ReceivingDetailPage extends StatelessWidget {
  final Receiving receiving;

  const ReceivingDetailPage({super.key, required this.receiving});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Detail Penerimaan",
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
                _infoPenerimaan(),
                const SizedBox(height: 12),
                _infoItem(),
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
                  /// TODO: update item
                },
                child: const Text(
                  "Perbarui Item",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= INFO PENERIMAAN =================
  Widget _infoPenerimaan() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Penerimaan",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                receiving.code,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              _statusChip("Diterima", AppColors.success),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                receiving.subtitle, // "2 hewan • Sapi Jawara"
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                "${receiving.total} Diterima",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sapi Jawara",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Area Pandeglang",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "14 Nov 2025",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text("-", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= INFO ITEM =================
  Widget _infoItem() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Item",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          ...receiving.items.map((e) => _itemDetail(e)),
        ],
      ),
    );
  }

  Widget _itemDetail(ReceivingItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            children: [
              Text(
                item.code,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              _statusChip("Diperiksa", AppColors.success),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.subtitle, // "Limosin • Jantan • Sapi Besar"
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _tag(item.age),
              _tag(item.weight),
              _tag(item.price, color: Colors.orange),
              if (item.vaccine != null) _tag(item.vaccine!),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Ini adalah baris catatan",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// ================= UTIL =================
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

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _tag(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.grey.shade700,
      ),
    );
  }
}
