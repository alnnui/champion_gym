import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/main.dart';
import 'package:myapp/modules/api/services/club_service.dart';
import 'package:myapp/modules/models/schedule_models.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:myapp/modules/components/animated_tap.dart';
import 'package:myapp/modules/widgets/date_range_picker.dart';
class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}
class _SchedulePageState extends State<SchedulePage> {
  late final ClubService _clubService;
  bool _loading = true;
  String? _error;
  ScheduleResponse? _scheduleResponse;
  
  DateTime? _dateSince;
  DateTime? _dateTo;
  int? _selectedYear;
  int? _selectedWeek;
  
  @override void initState() {
    super.initState();
    _clubService = ClubService(dio);
    _loadSchedule();
  }
  Future<void> _loadSchedule() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Using fallback club ID
      final int fallbackClubId = 2511;
      final int clubId = fallbackClubId;
      
      final response = await _clubService.getClubSchedule(
        clubId,
        year: _selectedYear,
        week: _selectedWeek,
      );
      // mark loading finished on success
      setState(() {
        _scheduleResponse = response;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Не удалось загрузить расписание клуба: $e';
        _loading = false;
      });
    }
  }
  
  // Вычисляет номер недели в году (ISO 8601)
  int _getWeekNumber(DateTime date) {
    // ISO 8601: неделя начинается с понедельника
    // Первая неделя года - это неделя, содержащая первый четверг года
    
    // Находим четверг текущей недели
    final thursday = date.subtract(Duration(days: date.weekday - DateTime.thursday));
    
    // Находим первый четверг года
    final firstDayOfYear = DateTime(thursday.year, 1, 1);
    final firstThursday = firstDayOfYear.weekday <= DateTime.thursday
        ? firstDayOfYear.add(Duration(days: DateTime.thursday - firstDayOfYear.weekday))
        : firstDayOfYear.add(Duration(days: 7 - firstDayOfYear.weekday + DateTime.thursday));
    
    // Вычисляем номер недели
    final weekNumber = ((thursday.difference(firstThursday).inDays / 7).floor() + 1);
    
    return weekNumber;
  }
  
  Future<void> _selectDateRange() async {
    await showCustomWeekPicker(
      context: context,
      initialDate: _dateSince,
      onWeekSelected: (year, week, monday, sunday) {
        setState(() {
          _selectedYear = year;
          _selectedWeek = week;
          _dateSince = monday;
          _dateTo = sunday;
        });
        _loadSchedule();
      },
    );
  }

  void _clearDateRange() {
    setState(() {
      _dateSince = null;
      _dateTo = null;
      _selectedYear = null;
      _selectedWeek = null;
    });
    _loadSchedule();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Date range selector
              _buildDateRangeSelector(),
              
              SizedBox(height: 16.h),
              
              // Main content
              Expanded(
                child: Builder(builder: (context) {
                  if (_loading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary,));
                  }
                  if (_error != null) {
                    return Center(child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ));
                  }

                  // Show schedule data
                  var scheduleItems = _scheduleResponse?.schedule ?? [];
                  
                  // Разделяем на прошедшие и будущие тренировки
                  final now = DateTime.now();
                  final upcomingItems = <ScheduleActivity>[];
                  final pastItems = <ScheduleActivity>[];
                  
                  for (var item in scheduleItems) {
                    final isPast = item.dateTime != null && item.dateTime!.isBefore(now);
                    if (isPast) {
                      pastItems.add(item);
                    } else {
                      upcomingItems.add(item);
                    }
                  }
                  
                  // Сортируем будущие по возрастанию (самые ранние первыми)
                  upcomingItems.sort((a, b) {
                    if (a.dateTime != null && b.dateTime != null) {
                      return a.dateTime!.compareTo(b.dateTime!);
                    }
                    if (a.dateTime != null) return -1;
                    if (b.dateTime != null) return 1;
                    return 0;
                  });
                  
                  // Сортируем прошедшие по убыванию (самые свежие из прошедших первыми)
                  pastItems.sort((a, b) {
                    if (a.dateTime != null && b.dateTime != null) {
                      return b.dateTime!.compareTo(a.dateTime!);
                    }
                    if (a.dateTime != null) return -1;
                    if (b.dateTime != null) return 1;
                    return 0;
                  });
                  
                  // Объединяем: сначала будущие, потом прошедшие
                  scheduleItems = [...upcomingItems, ...pastItems];
                  
                  if (scheduleItems.isEmpty) {
                    return const Center(
                      child: Text(
                        'Нет доступного расписания',
                        style: TextStyle(color: AppColors.textComplimentary),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: scheduleItems.length,
                    itemBuilder: (context, index) {
                      final item = scheduleItems[index];
                      final activity = item.activity;
                      final trainers = item.trainers ?? [];
                      
                      // Проверяем, прошла ли тренировка
                      final isPast = item.dateTime != null && 
                                     item.dateTime!.isBefore(DateTime.now());
                      
                      // Format date and time
                      String dateStr = '';
                      String timeStr = '';
                      if (item.dateTime != null) {
                        final dt = item.dateTime!;
                        timeStr = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                        
                        // Форматируем дату
                        const months = [
                          'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
                          'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
                        ];
                        dateStr = '${dt.day} ${months[dt.month - 1]}';
                        
                        // Если это не текущий год, добавляем год
                        if (dt.year != DateTime.now().year) {
                          dateStr += ' ${dt.year}';
                        }
                      }
                      
                      // Trainer names
                      String trainerNames = trainers.isNotEmpty
                          ? trainers.map((t) => t.title).join(', ')
                          : 'Тренер не указан';
                      
                      return Opacity(
                        opacity: isPast ? 0.5 : 1.0,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8.h),
                          child: Card(
                            color: AppColors.backgroundComplimentary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Date badge
                                    if (dateStr.isNotEmpty)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.cardBackground,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: AppColors.textComplimentary.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 12.sp,
                                              color: AppColors.textComplimentary,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              dateStr,
                                              style: TextStyle(
                                                color: AppColors.text,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (dateStr.isNotEmpty && timeStr.isNotEmpty)
                                      SizedBox(width: 8.w),
                                    // Time badge
                                    if (timeStr.isNotEmpty)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          timeStr,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                // Activity title
                                Text(
                                  activity?.title ?? 'Без названия',
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                if (item.length != null) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Длительность: ${item.length} мин',
                                    style: TextStyle(
                                      color: AppColors.textComplimentary,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                                SizedBox(height: 8.h),
                                // Trainer
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      size: 16.sp,
                                      color: AppColors.textComplimentary,
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        trainerNames,
                                        style: TextStyle(
                                          color: AppColors.textComplimentary,
                                          fontSize: 13.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                // Room info
                                if (item.room != null) ...[
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 16.sp,
                                        color: AppColors.textComplimentary,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        item.room!.title ?? 'Зал не указан',
                                        style: TextStyle(
                                          color: AppColors.textComplimentary,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDateRangeSelector() {
    final hasDateRange = _dateSince != null && _dateTo != null;
    
    String dateRangeText = 'Выберите неделю';
    if (hasDateRange) {
      final weekNum = _getWeekNumber(_dateSince!);
      dateRangeText = 'Неделя $weekNum, ${_dateSince!.year}';
    }
    
    return Row(
      children: [
        Expanded(
          child: AnimatedTap(
            onTap: _selectDateRange,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: hasDateRange
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasDateRange
                      ? AppColors.primary
                      : AppColors.textComplimentary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: hasDateRange
                        ? AppColors.primary
                        : AppColors.textComplimentary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      dateRangeText,
                      style: TextStyle(
                        color: hasDateRange
                            ? AppColors.primary
                            : AppColors.textComplimentary,
                        fontSize: 14.sp,
                        fontFamily: 'Gilroy',
                        fontWeight: hasDateRange ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasDateRange) ...[
          SizedBox(width: 8.w),
          AnimatedTap(
            onTap: _clearDateRange,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.textComplimentary.withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.clear,
                color: AppColors.textComplimentary,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ],
    );
  }
}