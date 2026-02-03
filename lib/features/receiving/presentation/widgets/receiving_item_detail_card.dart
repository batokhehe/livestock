import 'package:flutter/material.dart';
import 'package:livestock/core/widgets/text_field_with_inner_counter.dart';

import '../../../../core/widgets/info_tag.dart';
import '../../../../core/widgets/input_field.dart';

class ReceivingDetailItemCard extends StatelessWidget {
  final bool selected;

  const ReceivingDetailItemCard({super.key, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
            children: [
              const Text(
                "00001",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Checkbox(
                value: selected,
                onChanged: (_) {},
                activeColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text("Sapi Besar • Jantan", style: TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: const [
              InfoTag(label: "14 Bulan"),
              InfoTag(label: "315 kg"),
              InfoTag(label: "Rp 23.000.000"),
              InfoTag(label: "Vaksin 12/7"),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Ini adalah baris catatan",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          InputField(label: "Kode Hewan", hint: "Masukkan kode"),
          const SizedBox(height: 12),
          InputField(label: "Berat Diterima", hint: "Berat", suffix: "kg"),
          const SizedBox(height: 12),
          TextFieldWithInnerCounter(
            hint: "Masukkan catatan",
            label: "Catatan",
            subLabel: "(Optional)",
            maxLength: 80,
          ),
        ],
      ),
    );
  }
}
