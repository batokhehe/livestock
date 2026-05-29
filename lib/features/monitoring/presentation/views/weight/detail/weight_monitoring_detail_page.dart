import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import 'package:livestock/core/widgets/success_notification.dart';
import 'package:livestock/features/monitoring/data/weight_monitoring_model.dart';
import 'package:livestock/features/monitoring/monitoring_provider.dart';
import 'package:livestock/features/monitoring/presentation/notifier/weight_monitoring_list_notifier.dart';

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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _InfoSection(item: item),
                const SizedBox(height: 12),
                _ItemsSection(
                  details: item.details,
                  monitoringDate: item.monitoringDate,
                ),
                const SizedBox(height: 12),
                _SummarySection(
                  totalAnimals: item.detailsCount,
                  avgDiffWeight: avgDiffWeight,
                  avgAdg: avgAdg,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          _EditButton(item: item),
        ],
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final WeightMonitoring item;
  const _EditButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () {
            context.push('/monitoring/edit', extra: item);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Edit Data",
                  style: AppTypography.smallBoldPrimary.copyWith(
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.edit_rounded, color: Colors.blue.shade700, size: 20),
              ],
            ),
          ),
        ),
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
                  item.monitoringDate.toIndonesianDate(),
                  style: AppTypography.smallBoldBlack.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text('Tanggal Timbang', style: AppTypography.smallNormalGrey),
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
  final String monitoringDate;
  const _ItemsSection({required this.details, required this.monitoringDate});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Informasi Item',
      child: Column(
        children: details
            .map((d) => _DetailCard(detail: d, monitoringDate: monitoringDate))
            .toList(),
      ),
    );
  }
}

class _DetailCard extends ConsumerWidget {
  final WeightMonitoringDetail detail;
  final String monitoringDate;
  const _DetailCard({required this.detail, required this.monitoringDate});

  void _showDeleteConfirmSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeleteConfirmBottomSheet(
        onDelete: () async {
          // Show loading
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          try {
            await ref
                .read(monitoringApiProvider)
                .deleteWeightMonitoringDetails(ids: [detail.id]);

            // Invalidate list provider
            ref.invalidate(weightMonitoringListProvider);

            if (!context.mounted) return;

            // Pop loading
            Navigator.pop(context);
            // Pop bottom sheet
            Navigator.pop(context);
            // Pop detail page
            Navigator.pop(context);

            SuccessNotification.show(
              title: 'Berhasil',
              subtitle: 'Item berhasil dihapus',
            );
          } catch (e) {
            if (!context.mounted) return;

            // Pop loading
            Navigator.pop(context);
            SuccessNotification.showError(
              title: 'Gagal',
              subtitle: 'Gagal menghapus item: $e',
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.animalCode,
                        style: AppTypography.smallBoldBlack,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${detail.animalName} • ${detail.initialWeight.toStringAsFixed(2)} kg',
                        style: AppTypography.xSmallNormalBlack,
                      ),
                    ],
                  ),
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
                    Text(
                      monitoringDate.isNotEmpty
                          ? monitoringDate.toIndonesianDate()
                          : '-',
                      style: AppTypography.smallBoldBlack,
                    ),
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
                    Text(
                      (detail.animalProfile?.lastAdgDate?.isNotEmpty ?? false)
                          ? detail.animalProfile!.lastAdgDate!
                                .toIndonesianDate()
                          : '-',
                      style: AppTypography.smallBoldBlack,
                    ),
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

class _DeleteConfirmBottomSheet extends StatelessWidget {
  final VoidCallback onDelete;

  const _DeleteConfirmBottomSheet({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Hapus Item", style: AppTypography.largeBoldBlack),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Image.asset(AppImages.icDeleteConfirmation, height: 120),
          const SizedBox(height: 20),
          const Text("Hapus Item Ini?", style: AppTypography.mediumBoldBlack),
          const SizedBox(height: 8),
          const Text(
            "Item yang telah diinput akan dihapus dan tidak dapat dikembalikan. "
            "Apakah Anda yakin ingin melanjutkan?",
            textAlign: TextAlign.center,
            style: AppTypography.smallNormalGrey,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.primaryShade,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.primaryShade),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Batal",
                    style: AppTypography.mediumBoldPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onDelete,
                  child: const Text(
                    "Hapus Sekarang",
                    style: AppTypography.mediumBoldWhite,
                  ),
                ),
              ),
            ],
          ),
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
            _SummaryRow(
              label: 'Kenaikan Berat Rata-rata',
              value: '${avgDiffWeight.toStringAsFixed(2)} kg',
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
