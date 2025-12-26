import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';

class ReceivingFilterBottomSheet extends StatelessWidget {
  const ReceivingFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Filter Data", style: AppTypography.largeBoldBlack),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _FilterChip(label: "Hewan", selected: true),
              _FilterChip(label: "Pakan & Obat"),
              _FilterChip(label: "Peralatan"),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _FilterChip(label: "Semua Status", selected: true),
              _FilterChip(label: "Diterima"),
              _FilterChip(label: "Menunggu"),
            ],
          ),
          const SizedBox(height: 16),
          const _DateOption(label: "Hari ini"),
          const _DateOption(label: "Minggu ini"),
          const _DateOption(label: "Bulan ini"),
          const _DateOption(label: "Rentang tanggal manual", highlighted: true),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Simpan Perubahan",
                style: AppTypography.mediumBoldWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryShade : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.fieldBorder,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.xSmallNormalBlack.copyWith(
          color: selected ? Colors.orange : Colors.black87,
        ),
      ),
    );
  }
}

class _DateOption extends StatelessWidget {
  final String label;
  final bool highlighted;

  const _DateOption({required this.label, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primaryShade : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted ? AppColors.primary : AppColors.hint,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.smallBoldBlack.copyWith(
          color: highlighted ? AppColors.primary : AppColors.black,
        ),
      ),
    );
  }
}
