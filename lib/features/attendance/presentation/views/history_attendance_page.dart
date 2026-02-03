import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/item_double_card.dart';

import '../../../../core/helpers/utils.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/widgets/date_group_card.dart';
import '../../providers/attendance_provider.dart';

class HistoryAttendancePage extends ConsumerStatefulWidget {
  const HistoryAttendancePage({super.key});

  @override
  ConsumerState<HistoryAttendancePage> createState() =>
      _HistoryAttendancePageState();
}

class _HistoryAttendancePageState extends ConsumerState<HistoryAttendancePage> {
  @override
  void initState() {
    super.initState();

    /// 🔥 REFRESH DATA SETIAP PAGE DIBUKA
    Future.microtask(() {
      ref.invalidate(attendanceHistoryProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    /// QUERY DERIVED DARI PROVIDER
    final query = ref.watch(attendanceQueryProvider);

    /// DATA DARI API
    final attendanceAsync = ref.watch(attendanceHistoryProvider(query));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        title: const Text("Riwayat Absen", style: AppTypography.largeBoldBlack),
        backgroundColor: AppColors.white,
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _locationFilter(context),
            const SizedBox(height: 12),
            _tabSwitcher(ref),
            const SizedBox(height: 16),

            /// ================= LIST =================
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(attendanceHistoryProvider);
                },
                child: attendanceAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),

                  error: (e, _) => Center(
                    child: Text(
                      e.toString(),
                      style: AppTypography.smallNormalGrey,
                    ),
                  ),

                  data: (List data) {
                    if (data.isEmpty) {
                      return const Center(
                        child: Text("Belum ada riwayat absensi"),
                      );
                    }

                    final activeTab = ref.watch(attendanceTabProvider);

                    /// ================= GROUP BY DATE =================
                    final Map<String, List<Map<String, dynamic>>> grouped = {};

                    for (final attendance in data) {
                      final date = attendance['transdate'];

                      grouped.putIfAbsent(date, () => []);

                      if (activeTab == AttendanceTab.overnight) {
                        for (final detail in attendance['details']) {
                          grouped[date]!.add({
                            'detail': detail,
                            'note': attendance['additional_information'],
                          });
                        }
                      } else {
                        grouped[date]!.add(attendance);
                      }
                    }

                    final dates = grouped.keys.toList();

                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: dates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final date = dates[index];
                        final items = grouped[date]!;

                        /// ================= TAB NGINAP =================
                        if (activeTab == AttendanceTab.overnight) {
                          return DateGroupCard(
                            dateLabel: formatDate(date),
                            children: items.map<Widget>((item) {
                              final detail = item['detail'];
                              final employee = detail['employee'];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ItemDoubleCard(
                                  title: employee['name'],
                                  subTitle: employee['phone_number'] ?? "-",
                                  tag: item['note'] ?? "-",
                                ),
                              );
                            }).toList(),
                          );
                        }

                        /// ================= TAB ABSENSI =================
                        final attendance = items.first;

                        return _attendanceCard(
                          date: attendance['transdate'],
                          area: "Area simpang ciheulang",
                          pic:
                              "${attendance['recorder']['name']} · Kepala Kandang",
                          present: countPresent(attendance['details']),
                          absent: countAbsent(attendance['details']),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI =================

  Widget _locationFilter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Row(
              children: const [
                Icon(Icons.location_on, size: 18, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(child: Text("Semua lokasi peternakan")),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(AppImages.icFilterSearch, width: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabSwitcher(WidgetRef ref) {
    final activeTab = ref.watch(attendanceTabProvider);

    return Row(
      children: [
        _tabItem(
          ref,
          "Absensi",
          AttendanceTab.attendance,
          activeTab == AttendanceTab.attendance,
        ),
        const SizedBox(width: 8),
        _tabItem(
          ref,
          "Nginap",
          AttendanceTab.overnight,
          activeTab == AttendanceTab.overnight,
        ),
      ],
    );
  }

  Widget _tabItem(
    WidgetRef ref,
    String text,
    AttendanceTab value,
    bool active,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(attendanceTabProvider.notifier).state = value;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryShade : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        child: Text(
          text,
          style: AppTypography.smallNormalPrimary.copyWith(
            color: active ? AppColors.primary : AppColors.black,
          ),
        ),
      ),
    );
  }

  Widget _attendanceCard({
    required String date,
    required String area,
    required String pic,
    required int present,
    required int absent,
  }) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formatDate(date), style: AppTypography.smallNormalBlack),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(area, style: AppTypography.smallBoldBlack),
                      const SizedBox(height: 4),
                      Text(pic, style: AppTypography.xSmallNormalGrey),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$present hadir",
                      style: AppTypography.xSmallNormalGreen,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$absent tidak hadir",
                      style: AppTypography.xSmallNormalRed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
