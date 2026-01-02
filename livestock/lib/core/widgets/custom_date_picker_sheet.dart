import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/AppColors.dart';
import '../../../core/theme/AppTypography.dart';

class CustomDatePickerSheet extends StatefulWidget {
  const CustomDatePickerSheet({super.key});

  @override
  State<CustomDatePickerSheet> createState() => _CustomDatePickerSheetState();
}

class _CustomDatePickerSheetState extends State<CustomDatePickerSheet> {
  late DateTime _focusedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime.now();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
    final displayDate = _selectedDate ?? DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select date", style: AppTypography.xSmallBoldBlack),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('EEE, MMM d').format(displayDate),
              style: AppTypography.largeBoldBlack,
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
          DateFormat('MMMM yyyy').format(_focusedMonth),
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
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

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
        crossAxisSpacing: 6,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        if (index < startWeekday) {
          return const SizedBox();
        }

        final day = index - startWeekday + 1;
        final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);

        final isSelected =
            _selectedDate != null && DateUtils.isSameDay(date, _selectedDate);

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : null,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$day',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
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
          onPressed: () => Navigator.pop(context, null),
          child: Text("Hapus", style: AppTypography.smallNormalPrimary),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batalkan", style: AppTypography.smallNormalPrimary),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _selectedDate);
              },
              child: Text("OK", style: AppTypography.smallNormalPrimary),
            ),
          ],
        ),
      ],
    );
  }
}
