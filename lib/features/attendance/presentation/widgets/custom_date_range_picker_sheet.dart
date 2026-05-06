import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class CustomDateRangePickerSheet extends StatefulWidget {
  const CustomDateRangePickerSheet({super.key});

  @override
  State<CustomDateRangePickerSheet> createState() =>
      _CustomDateRangePickerSheetState();
}

class _CustomDateRangePickerSheetState
    extends State<CustomDateRangePickerSheet> {
  late DateTime _focusedMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 22,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 4),
          _calendarHeader(),
          const SizedBox(height: 4),
          _weekDays(),
          const SizedBox(height: 4),
          _calendarGrid(),
          const SizedBox(height: 16),
          _actions(),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    String displayStr = "Pilih rentang tanggal";
    if (_startDate != null) {
      final startStr = DateFormat('d MMM', 'id_ID').format(_startDate!);
      if (_endDate != null) {
        final endStr = DateFormat('d MMM', 'id_ID').format(_endDate!);
        displayStr = "$startStr - $endStr";
      } else {
        displayStr = "$startStr - Pilih tanggal akhir";
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Rentang Tanggal", style: AppTypography.xSmallBoldBlack),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                displayStr,
                style: AppTypography.mediumBoldBlack,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.edit, size: 20),
          ],
        ),
      ],
    );
  }

  // ================= MONTH NAV =================
  Widget _calendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM yyyy', 'id_ID').format(_focusedMonth),
          style: AppTypography.smallBoldBlack,
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month - 1,
                  );
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month + 1,
                  );
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _weekDays() {
    const days = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 7,
      physics: const NeverScrollableScrollPhysics(),
      children: days
          .map(
            (d) =>
                Center(child: Text(d, style: AppTypography.xSmallNormalGrey)),
          )
          .toList(),
    );
  }

  bool _isDateInRange(DateTime date) {
    if (_startDate != null && _endDate != null) {
      return date.isAfter(_startDate!) && date.isBefore(_endDate!);
    }
    return false;
  }

  Widget _calendarGrid() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );
    final startWeekday = firstDay.weekday % 7;

    final totalCells = startWeekday + daysInMonth;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 0,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        if (index < startWeekday) {
          return const SizedBox();
        }

        final day = index - startWeekday + 1;
        final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);

        final isStart = _startDate != null && DateUtils.isSameDay(date, _startDate);
        final isEnd = _endDate != null && DateUtils.isSameDay(date, _endDate);
        final inRange = _isDateInRange(date);

        final isSelected = isStart || isEnd;

        BoxDecoration? decoration;
        if (isSelected) {
          decoration = const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          );
        } else if (inRange) {
          decoration = BoxDecoration(
            color: AppColors.primaryShade,
            shape: BoxShape.rectangle,
          );
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              if (_startDate == null || (_startDate != null && _endDate != null)) {
                _startDate = date;
                _endDate = null;
              } else if (date.isBefore(_startDate!)) {
                _startDate = date;
              } else {
                _endDate = date;
              }
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: decoration,
            child: Text(
              '$day',
              style: TextStyle(
                color: isSelected ? Colors.white : (inRange ? AppColors.primaryDark : Colors.black),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= ACTIONS =================
  Widget _actions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _startDate = null;
              _endDate = null;
            });
          },
          child: const Text("Hapus", style: AppTypography.smallNormalPrimary),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batalkan", style: AppTypography.smallNormalPrimary),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                if (_startDate != null && _endDate != null) {
                  Navigator.pop(context, DateTimeRange(start: _startDate!, end: _endDate!));
                } else if (_startDate != null) {
                  Navigator.pop(context, DateTimeRange(start: _startDate!, end: _startDate!));
                } else {
                   Navigator.pop(context, null);
                }
              },
              child: const Text("OK", style: AppTypography.smallNormalPrimary),
            ),
          ],
        ),
      ],
    );
  }
}
