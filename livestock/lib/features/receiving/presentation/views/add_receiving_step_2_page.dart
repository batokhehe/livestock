import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../widgets/receiving_item_detail_card.dart';

class AddReceivingStep2Page extends StatelessWidget {
  const AddReceivingStep2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Tambah Penerimaan",
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const _StepHeaderStep2(),
                const SizedBox(height: 12),

                /// 🔹 POH INFO
                const _POHInfoCard(),
                const SizedBox(height: 12),

                /// 🔹 INFORMASI ITEM
                const _ItemInfoHeader(),
                const SizedBox(height: 8),

                /// 🔹 ITEM LIST
                ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    return ReceivingDetailItemCard(selected: i == 0);
                  },
                ),
              ],
            ),
          ),

          _NextButtonStep2(),
        ],
      ),
    );
  }
}

class _POHInfoCard extends StatelessWidget {
  const _POHInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "POH-2511-0009",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                "Dikonfirmasi",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "2 hewan • Lunas",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Ahmad Umar\nNama Pemasok", style: TextStyle(fontSize: 12)),
              Text(
                "30 Okt 2025\nTanggal Pembelian",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemInfoHeader extends StatelessWidget {
  const _ItemInfoHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: const Text(
        "Informasi Item",
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _StepHeaderStep2 extends StatelessWidget {
  const _StepHeaderStep2();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: const Text(
        "Detail Penerimaan\nLangkah 2/3",
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _NextButtonStep2 extends StatelessWidget {
  const _NextButtonStep2();

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
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // 👉 lanjut ke STEP 3
              // ganti path sesuai router kamu
              context.push('/receiving/add/confirmation');
            },
            child: const Text(
              "Selanjutnya",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
