import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:livestock/features/attendance/providers/attendance_provider.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import 'custom_date_range_picker_sheet.dart';

class HistoryAttendanceFilterBottomSheet extends ConsumerStatefulWidget {
  const HistoryAttendanceFilterBottomSheet({super.key});

  @override
  ConsumerState<HistoryAttendanceFilterBottomSheet> createState() =>
      _HistoryAttendanceFilterBottomSheetState();
}

class _HistoryAttendanceFilterBottomSheetState
    extends ConsumerState<HistoryAttendanceFilterBottomSheet> {
  late final TextEditingController _searchCtrl;
  String _selectedFilterType = 'Bulan Ini';
  DateTimeRange? _selectedDateRange;

  final List<String> _filterTypes = [
    'Hari ini',
    'Minggu Ini',
    'Bulan Ini',
    'Rentang tanggal manual',
  ];

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _selectedFilterType = ref.read(attendanceFilterTypeProvider);
    _selectedDateRange = ref.read(attendanceDateRangeProvider);
    _searchCtrl.text = ref.read(attendanceSearchProvider) ?? '';
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 22,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 24),
          _dateFilter(),
          const SizedBox(height: 32),
          _actions(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Filter Riwayat", style: AppTypography.mediumBoldBlack),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _dateFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _filterTypes.map((type) {
        final isSelected = _selectedFilterType == type;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () async {
              if (type == 'Rentang tanggal manual') {
                final result = await showModalBottomSheet<DateTimeRange?>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const CustomDateRangePickerSheet(),
                );
                if (result != null) {
                  setState(() {
                    _selectedFilterType = type;
                    _selectedDateRange = result;
                  });
                }
              } else {
                setState(() {
                  _selectedFilterType = type;
                  _selectedDateRange = null; // clear it for other types
                });
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.fieldBorder,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected ? AppColors.primaryShade : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: isSelected
                        ? AppTypography.smallBoldPrimary
                        : AppTypography.smallNormalBlack,
                  ),
                  if (type == 'Rentang tanggal manual' &&
                      isSelected &&
                      _selectedDateRange != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      "${DateFormat('dd MMM yyyy', 'id_ID').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM yyyy', 'id_ID').format(_selectedDateRange!.end)}",
                      style: AppTypography.xSmallNormalPrimary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _searchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Cari Pekerja", style: AppTypography.smallBoldBlack),
        const SizedBox(height: 12),
        TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            hintText: "Masukkan nama pekerja",
            hintStyle: AppTypography.hint,
            prefixIcon: const Icon(Icons.search, color: AppColors.grey),
            isDense: true,
            filled: true,
            fillColor: AppColors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              ref.read(attendanceFilterTypeProvider.notifier).state =
                  'Bulan Ini';
              ref.read(attendanceDateRangeProvider.notifier).state = null;
              ref.read(attendanceSearchProvider.notifier).state = null;
              ref.invalidate(attendanceHistoryNotifierProvider);
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: AppColors.primary),
            ),
            child: const Text("Reset", style: AppTypography.smallBoldPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              ref.read(attendanceFilterTypeProvider.notifier).state =
                  _selectedFilterType;
              ref.read(attendanceDateRangeProvider.notifier).state =
                  _selectedDateRange;
              ref.read(attendanceSearchProvider.notifier).state =
                  _searchCtrl.text.isNotEmpty ? _searchCtrl.text : null;
              ref.invalidate(attendanceHistoryNotifierProvider);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text("Terapkan", style: AppTypography.smallBoldWhite),
          ),
        ),
      ],
    );
  }
}
