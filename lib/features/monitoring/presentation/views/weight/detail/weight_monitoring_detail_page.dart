import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import 'package:livestock/features/monitoring/data/weight_monitoring_model.dart';

class WeightMonitoringDetailPage extends StatelessWidget {
  final WeightMonitoring item;

  const WeightMonitoringDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final avgDiffWeight = item.details.isEmpty
        ? 0.0
        : item.details.map((e) => e.diffWeight).reduce((a, b) => a + b) /
              item.details.length;
    final avgAdg = item.details.isEmpty
        ? 0.0
        : item.details.map((e) => e.adg).reduce((a, b) => a + b) /
              item.details.length;

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          'Detail Pemantauan',
          style: AppTypography.largeBoldBlack,
        ),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoSection(item: item),
          const SizedBox(height: 12),
          _ItemsSection(details: item.details),
          const SizedBox(height: 12),
          _SummarySection(
            totalAnimals: item.detailsCount,
            avgDiffWeight: avgDiffWeight,
            avgAdg: avgAdg,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Informasi Pemantauan ────────────────────────────────────────────────────

class _InfoSection extends StatelessWidget {
  final WeightMonitoring item;
  const _InfoSection({required this.item});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Informasi pemantauan',
      child: Column(
        children: [
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.monitoringCode, style: AppTypography.smallBoldBlack),
                const SizedBox(height: 2),
                Text(
                  '${item.animalCount} hewan',
                  style: AppTypography.xSmallNormalBlack,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    if (item.employeeName.isNotEmpty)
                      InfoTag(label: item.employeeName),
                    InfoTag(label: '${item.animalCount} hewan'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.formattedMonitoringDate ?? item.dateLabel,
                  style: AppTypography.smallBoldBlack.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tanggal Pemantauan',
                  style: AppTypography.smallNormalGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Informasi Item ──────────────────────────────────────────────────────────

class _ItemsSection extends StatelessWidget {
  final List<WeightMonitoringDetail> details;
  const _ItemsSection({required this.details});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Informasi Item',
      child: Column(
        children: details.map((d) => _DetailCard(detail: d)).toList(),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final WeightMonitoringDetail detail;
  const _DetailCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: code, nama•berat
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail.animalCode, style: AppTypography.smallBoldBlack),
                Text(
                  '${detail.animalName} • ${detail.initialWeight.toStringAsFixed(2)} kg',
                  style: AppTypography.xSmallNormalBlack,
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          // Baris 1: Tanggal Timbang (initial) | Berat (initial)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('-', style: AppTypography.smallBoldBlack),
                    Text(
                      'Tanggal Timbang',
                      style: AppTypography.xSmallNormalGrey,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${detail.initialWeight.toStringAsFixed(2)} kg',
                      style: AppTypography.smallBoldBlack,
                    ),
                    Text('Berat', style: AppTypography.xSmallNormalGrey),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          // Baris 2: Tanggal Pemantauan Akhir | Berat Hari Ini
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('-', style: AppTypography.smallBoldBlack),
                    Text(
                      'Pemantauan Akhir',
                      style: AppTypography.xSmallNormalGrey,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${detail.finalWeight.toStringAsFixed(2)} kg',
                      style: AppTypography.smallBoldBlack,
                    ),
                    Text(
                      'Berat Hari Ini',
                      style: AppTypography.xSmallNormalGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          // Baris 3: Kenaikan BB | Selisih hari | Nilai ADG
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${detail.diffWeight.toStringAsFixed(2)} kg',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        'Kenaikan BB',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${detail.differentDays} hari',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        'Selisih hari',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${detail.adg.toStringAsFixed(2)} kg/day',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        'Nilai ADG',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Catatan jika ada
          if (detail.notes != null && detail.notes!.isNotEmpty) ...[
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.fieldBorder,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Catatan', style: AppTypography.xSmallNormalGrey),
                  Text(detail.notes!, style: AppTypography.smallBoldBlack),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Rincian ────────────────────────────────────────────────────────────────

class _SummarySection extends StatelessWidget {
  final int totalAnimals;
  final double avgDiffWeight;
  final double avgAdg;

  const _SummarySection({
    required this.totalAnimals,
    required this.avgDiffWeight,
    required this.avgAdg,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Rincian',
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Column(
          children: [
            _SummaryRow(label: 'Total Hewan', value: '$totalAnimals'),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.fieldBorder,
            ),
            _SummaryRow(
              label: 'Kenaikan Berat Rata-rata',
              value: '${avgDiffWeight.toStringAsFixed(2)} kg',
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.fieldBorder,
            ),
            _SummaryRow(
              label: 'ADG Rata-rata',
              value: '${avgAdg.toStringAsFixed(2)} kg/day',
              valueColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.smallNormalBlack),
          Text(
            value,
            style: AppTypography.smallBoldBlack.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}

// ─── Shared ──────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.fieldBorder,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.smallNormalGrey),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: child,
    );
  }
}
