import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';
import 'package:livestock/core/widgets/item_double_card.dart';
import 'package:livestock/features/attendance/presentation/widgets/attendance_overnight_item_double_card.dart';

import '../../../../core/helpers/utils.dart';
import '../../../../core/theme/AppImages.dart';
import '../../../../core/widgets/date_group_card.dart';
import '../../../../core/data/model/farm_location_model.dart';
import '../../../../core/widgets/farm_location_paginated_bottom_sheet.dart';
import '../../providers/attendance_provider.dart';
import '../widgets/history_attendance_filter_bottom_sheet.dart';

class HistoryAttendancePage extends ConsumerStatefulWidget {
  const HistoryAttendancePage({super.key});

  @override
  ConsumerState<HistoryAttendancePage> createState() =>
      _HistoryAttendancePageState();
}

class _HistoryAttendancePageState extends ConsumerState<HistoryAttendancePage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    /// 🔥 REFRESH DATA SETIAP PAGE DIBUKA
    Future.microtask(() {
      ref.invalidate(attendanceHistoryNotifierProvider);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(attendanceHistoryNotifierProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// QUERY DERIVED DARI PROVIDER
    final query = ref.watch(attendanceQueryProvider);

    /// DATA DARI API
    final attendanceAsync = ref.watch(attendanceHistoryNotifierProvider);

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
                  ref.invalidate(attendanceHistoryNotifierProvider);
                  await ref.read(attendanceHistoryNotifierProvider.future);
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

                  data: (Map<String, dynamic> response) {
                    final List data = response['data'];
                    final int total = response['total'] ?? 0;
                    final bool hasMore = data.length < total;

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
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: dates.length + (hasMore ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index == dates.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final date = dates[index];
                        final items = grouped[date]!;

                        /// ================= TAB NGINAP =================
                        if (activeTab == AttendanceTab.overnight) {
                          return DateGroupCard(
                            dateLabel: formatDateString(date),
                            children: items.map<Widget>((item) {
                              final detail = item['detail'];
                              final employee = detail['employee'];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: AttendanceOvernightItemDoubleCard(
                                  title: employee['name'],
                                  subTitle: employee['phone_number'] ?? "-",
                                  tag: item['note'] ?? "-",
                                ),
                              );
                            }).toList(),
                          );
                        }

                        /// ================= TAB ABSENSI =================
                        return DateGroupCard(
                          dateLabel: formatDateString(date),
                          children: items.map<Widget>((item) {
                            // final detail = item['detail'];
                            // final employee = detail['employee'];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _attendanceCard(
                                date: item['transdate'],
                                area: "Area simpang ciheulang",
                                pic:
                                    "${item['recorder']['name']} · Kepala Kandang",
                                present: countPresent(item['details']),
                                absent: countAbsent(item['details']),
                              ),
                            );
                          }).toList(),
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
    final selectedLocation = ref.watch(attendanceLocationProvider);

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final result = await showModalBottomSheet<FarmLocation?>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => FarmLocationPaginatedBottomSheet(
                  initialSelectedId: selectedLocation?.id,
                ),
              );

              if (result != null) {
                ref.read(attendanceLocationProvider.notifier).state = result;
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selectedLocation?.name ?? "Semua lokasi peternakan",
                    ),
                  ),
                  selectedLocation != null
                      ? GestureDetector(
                          onTap: () {
                            ref
                                    .read(attendanceLocationProvider.notifier)
                                    .state =
                                null;
                          },
                          child: const Icon(Icons.close),
                        )
                      : const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const HistoryAttendanceFilterBottomSheet(),
              );
            },
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
          // Text(formatDateString(date), style: AppTypography.smallNormalBlack),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(0),
            // decoration: BoxDecoration(
            //   color: AppColors.white,
            //   borderRadius: BorderRadius.circular(16),
            //   border: Border.all(color: AppColors.fieldBorder),
            // ),
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
