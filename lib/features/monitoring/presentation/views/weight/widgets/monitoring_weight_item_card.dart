import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/helpers/utils.dart';
import 'package:livestock/features/monitoring/data/monitoring_item_model.dart';

class MonitoringWeightItemCard extends StatelessWidget {
  final MonitoringItem item;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const MonitoringWeightItemCard({
    super.key,
    required this.item,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final lastDateStr = item.age != null && item.age!.isNotEmpty
        ? item.age!.toIndonesianDate()
        : "-";
    final lastWeightStr = item.stock != null && item.stock!.isNotEmpty
        ? "${double.tryParse(item.stock!)?.toStringAsFixed(2) ?? item.stock} kg"
        : "-";

    final todayStr = item.subtitle != null && item.subtitle!.isNotEmpty
        ? item.subtitle!.toIndonesianDate()
        : "-";
    final todayWeightStr = item.weight != null && item.weight!.isNotEmpty
        ? "${double.tryParse(item.weight!)?.toStringAsFixed(2) ?? item.weight} kg"
        : "-";

    final weightGain = double.tryParse(item.cutWeight ?? '0') ?? 0.0;
    final daysDiff = int.tryParse(item.vaccine ?? '0') ?? 0;
    final adgValue = double.tryParse(item.unit ?? '0') ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.code ?? '',
                        style: AppTypography.smallBoldBlack.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${item.name} • $lastWeightStr",
                        style: AppTypography.smallNormalGrey,
                      ),
                    ],
                  ),
                ),
                if (onDelete != null) ...[
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: AppColors.danger,
                        size: 20,
                      ),
                    ),
                  ),
                ],
                if (onDelete != null && onEdit != null) const SizedBox(width: 8),
                if (onEdit != null) ...[
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          _buildRowTwoColumns(
            leftTitle: todayStr,
            leftSubtitle: "Tanggal Timbang",
            rightTitle: todayWeightStr,
            rightSubtitle: "Berat Hari Ini",
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          _buildRowTwoColumns(
            leftTitle: lastDateStr,
            leftSubtitle: "Tanggal Pemantauan Terakhir",
            rightTitle: lastWeightStr,
            rightSubtitle: "Berat",
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: weightGain.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            const TextSpan(text: " "),
                            const TextSpan(
                              text: "kg",
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.grey2,
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Kenaikan BB",
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 32,
                  width: 1,
                  color: AppColors.fieldBorder,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "$daysDiff",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            const TextSpan(text: " "),
                            const TextSpan(
                              text: "hari",
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.grey2,
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Selisih hari",
                        style: TextStyle(
                          color: AppColors.info,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 32,
                  width: 1,
                  color: AppColors.fieldBorder,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: adgValue.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            const TextSpan(text: " "),
                            const TextSpan(
                              text: "kg/day",
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.grey2,
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Nilai ADG",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Catatan", style: AppTypography.xSmallNormalGrey),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.note == null || item.note!.isEmpty ? "-" : item.note!,
                    textAlign: TextAlign.end,
                    style: AppTypography.smallBoldBlack,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowTwoColumns({
    required String leftTitle,
    required String leftSubtitle,
    required String rightTitle,
    required String rightSubtitle,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(leftTitle, style: AppTypography.smallBoldBlack),
                  const SizedBox(height: 4),
                  Text(leftSubtitle, style: AppTypography.xSmallNormalGrey),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            color: AppColors.fieldBorder,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rightTitle, style: AppTypography.smallBoldBlack),
                  const SizedBox(height: 4),
                  Text(rightSubtitle, style: AppTypography.xSmallNormalGrey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
