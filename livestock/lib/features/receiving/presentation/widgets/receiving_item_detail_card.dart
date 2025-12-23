import 'package:flutter/material.dart';

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
          /// HEADER
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

          /// INFO HEWAN
          const Text("Sapi Besar • Jantan", style: TextStyle(fontSize: 12)),

          const SizedBox(height: 6),

          /// TAG INFO
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: const [
              _InfoTag(label: "14 Bulan"),
              _InfoTag(label: "315 kg"),
              _InfoTag(label: "Rp 23.000.000"),
              _InfoTag(label: "Vaksin 12/7"),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            "Ini adalah baris catatan",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),

          const SizedBox(height: 12),

          /// KODE HEWAN
          _InputField(label: "Kode Hewan", hint: "Masukkan kode"),

          const SizedBox(height: 12),

          /// BERAT
          _InputField(label: "Berat Diterima", hint: "Berat", suffix: "kg"),

          const SizedBox(height: 12),

          /// CATATAN
          _TextAreaField(label: "Catatan (Opsional)", hint: "Masukkan catatan"),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final String label;

  const _InfoTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.orange,
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final String? suffix;

  const _InputField({required this.label, required this.hint, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

class _TextAreaField extends StatelessWidget {
  final String label;
  final String hint;

  const _TextAreaField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          maxLines: 3,
          maxLength: 80,
          decoration: InputDecoration(
            hintText: hint,
            counterText: "0/80",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
