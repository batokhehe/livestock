import 'package:flutter/material.dart';

class TwoColumnRowCard extends StatelessWidget {
  final String leftValue;
  final String leftLabel;
  final String rightValue;
  final String rightLabel;

  const TwoColumnRowCard({
    super.key,
    required this.leftValue,
    required this.leftLabel,
    required this.rightValue,
    required this.rightLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: InfoItem(
              value: leftValue,
              label: leftLabel,
              alignEnd: false,
            ),
          ),
          Expanded(
            child: InfoItem(
              value: rightValue,
              label: rightLabel,
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String value;
  final String label;
  final bool alignEnd;

  const InfoItem({
    super.key,
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
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
