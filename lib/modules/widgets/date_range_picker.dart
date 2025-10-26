import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:myapp/modules/components/animated_tap.dart';

class CustomWeekPicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(int year, int week, DateTime monday, DateTime sunday) onWeekSelected;

  const CustomWeekPicker({
    super.key,
    this.initialDate,
    required this.onWeekSelected,
  });

  @override
  State<CustomWeekPicker> createState() => _CustomWeekPickerState();
}

class _CustomWeekPickerState extends State<CustomWeekPicker> {
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedMonday;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _currentMonth = DateTime(widget.initialDate!.year, widget.initialDate!.month);
      _selectedMonday = _getMondayOfWeek(widget.initialDate!);
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  DateTime _getMondayOfWeek(DateTime date) {
    // Получаем понедельник текущей недели
    final daysFromMonday = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: daysFromMonday));
  }

  void _selectWeek(DateTime date) {
    setState(() {
      _selectedMonday = _getMondayOfWeek(date);
    });
  }

  bool _isSameWeek(DateTime date1, DateTime date2) {
    final monday1 = _getMondayOfWeek(date1);
    final monday2 = _getMondayOfWeek(date2);
    return monday1.year == monday2.year &&
        monday1.month == monday2.month &&
        monday1.day == monday2.day;
  }

  int _getWeekNumber(DateTime date) {
    final thursday = date.subtract(Duration(days: date.weekday - DateTime.thursday));
    final firstDayOfYear = DateTime(thursday.year, 1, 1);
    final firstThursday = firstDayOfYear.weekday <= DateTime.thursday
        ? firstDayOfYear.add(Duration(days: DateTime.thursday - firstDayOfYear.weekday))
        : firstDayOfYear.add(Duration(days: 7 - firstDayOfYear.weekday + DateTime.thursday));
    final weekNumber = ((thursday.difference(firstThursday).inDays / 7).floor() + 1);
    return weekNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.textComplimentary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(height: 20.h),

            // Header with month/year navigation
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: AppColors.text),
                    onPressed: _previousMonth,
                  ),
                  Text(
                    _getMonthYearText(_currentMonth),
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: AppColors.text),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Weekday headers
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
                    .map((day) => SizedBox(
                          width: 40.w,
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                color: AppColors.textComplimentary,
                                fontSize: 12.sp,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),

            SizedBox(height: 12.h),

            // Calendar grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildCalendarGrid(),
            ),

            SizedBox(height: 20.h),

            // Selected week info
            if (_selectedMonday != null) ...[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Column(
                  children: [
                    Text(
                      'Выбрана неделя ${_getWeekNumber(_selectedMonday!)}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${_formatDate(_selectedMonday!)} - ${_formatDate(_selectedMonday!.add(Duration(days: 6)))}',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 12.sp,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Action buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedTap(
                      onTap: () {
                        setState(() {
                          _selectedMonday = null;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.textComplimentary.withOpacity(0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Очистить',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: AnimatedTap(
                      onTap: _selectedMonday == null
                          ? null
                          : () {
                              final monday = _selectedMonday!;
                              final sunday = monday.add(Duration(days: 6));
                              final year = monday.year;
                              final week = _getWeekNumber(monday);
                              widget.onWeekSelected(year, week, monday, sunday);
                              Navigator.pop(context);
                            },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: _selectedMonday == null
                              ? AppColors.primary.withOpacity(0.5)
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Применить',
                            style: TextStyle(
                              color: AppColors.textAlternative,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    
    int firstWeekday = firstDayOfMonth.weekday;
    
    List<Widget> dayWidgets = [];
    
    // Add empty cells for days before the first day of month
    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(SizedBox(width: 40.w, height: 40.h));
    }
    
    // Add day cells
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isSelected = _selectedMonday != null && _isSameWeek(date, _selectedMonday!);
      final isToday = _isSameDay(date, DateTime.now());
      
      dayWidgets.add(
        AnimatedTap(
          onTap: () => _selectWeek(date),
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primary, width: 1)
                  : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 14.sp,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'Gilroy',
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return Wrap(
      spacing: 4.w,
      runSpacing: 8.h,
      children: dayWidgets,
    );
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

// Helper function to show the picker
Future<void> showCustomWeekPicker({
  required BuildContext context,
  DateTime? initialDate,
  required Function(int year, int week, DateTime monday, DateTime sunday) onWeekSelected,
}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => CustomWeekPicker(
      initialDate: initialDate,
      onWeekSelected: onWeekSelected,
    ),
  );
}
