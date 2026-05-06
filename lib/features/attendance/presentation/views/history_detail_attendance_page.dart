import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/section_card.dart';

import '../../../../core/theme/AppImages.dart';
import '../../../../core/widgets/product_header_card.dart';
import '../../providers/attendance_provider.dart';

class HistoryDetailAttendancePage extends ConsumerStatefulWidget {
  final String type;
  final String transDate;
  final String id;
  final String? additionalInformation;

  const HistoryDetailAttendancePage({
    super.key,
    required this.type,
    required this.transDate,
    required this.id,
    this.additionalInformation,
  });

  @override
  ConsumerState<HistoryDetailAttendancePage> createState() =>
      _HistoryDetailAttendancePageState();
}

class _HistoryDetailAttendancePageState
    extends ConsumerState<HistoryDetailAttendancePage> {
  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(
      attendanceDetailProvider((
        type: widget.type,
        transDate: widget.transDate,
        id: widget.id,
      )),
    );

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        title: const Text("Detail Absen", style: AppTypography.largeBoldBlack),
        backgroundColor: AppColors.white,
        leading: const BackButton(),
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text(e.toString())),

        data: (attendance) {
          final details = attendance['details'] as List;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _attendanceInfo(attendance),
              const SizedBox(height: 16),

              SectionCard(
                title: "Informasi Pekerja",
                children: [
                  _summary(details),
                  const SizedBox(height: 12),

                  ...details.map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _employeeItem(d),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _attendanceInfo(Map data) {
    return SectionCard(
      title: 'Informasi Absensi',
      children: [
        CardWrapper(
          child: ProductHeaderCard(
            subtitle: 'Area Brown Field',
            title: DateFormat(
              'dd MMM yyyy',
              'id_ID',
            ).format(DateTime.parse(data['transdate'])),
            image: AppImages.icCalendarTick,
            isActive: false,
          ),
        ),
        const SizedBox(height: 12),
        CardWrapper(
          child: ProductHeaderCard(
            subtitle: 'Catatan',
            title: widget.additionalInformation ?? data['additional_information'] ?? '-',
            image: AppImages.icNote,
            isActive: false,
          ),
        ),
      ],
    );
  }

  Widget _summary(List details) {
    final total = details.length;
    final present = details.where((e) => e['status'] == 'present').length;
    final absent = total - present;

    return CardWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.groups, color: AppColors.primary),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$total", style: AppTypography.smallBoldBlack),
                  Text("Pekerja", style: AppTypography.xSmallNormalBlack),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("$present hadir", style: AppTypography.xSmallNormalGreen),
              Text("$absent tidak hadir", style: AppTypography.xSmallNormalRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _employeeItem(Map d) {
    final isPresent = d['status'] == 'present';

    return CardWrapper(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(AppImages.icUserTick, width: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d['employee']['name'],
                  style: AppTypography.smallBoldBlack,
                ),
                Text(
                  d['employee']['position'],
                  style: AppTypography.xSmallNormalGrey,
                ),
              ],
            ),
          ),
          Text(
            isPresent ? "Hadir" : "Tidak Hadir",
            style: AppTypography.xSmallNormalBlack,
          ),
        ],
      ),
    );
  }
}
