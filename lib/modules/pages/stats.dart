import 'package:flutter/material.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/api/services/account_service.dart';
import 'package:myapp/modules/models/visit_history.dart';
import 'package:myapp/main.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late final AccountService _accountService;
  bool _isLoading = true;
  String? _error;
  List<VisitHistory> _visitHistory = [];
  
  String selectedPeriod = 'Неделя';
  final List<String> periods = ['Неделя', 'Месяц', 'Год'];

  @override
  void initState() {
    super.initState();
    _accountService = AccountService(dio);
    _loadVisitHistory();
  }

  Future<void> _loadVisitHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final history = await _accountService.getVisitHistory();
      
      // Загружаем детальную информацию для каждого посещения
      for (var visit in history) {
        try {
          final scheduleItem = await _accountService.getScheduleItem(visit.id);
          visit.scheduleItem = scheduleItem;
        } catch (e) {
          // Если не удалось загрузить детали, пропускаем
          print('Failed to load schedule item for ${visit.id}: $e');
        }
      }
      
      if (!mounted) return;
      
      setState(() {
        _visitHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _error = 'Ошибка загрузки истории: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _error!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                            fontFamily: 'Gilroy',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: _loadVisitHistory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                  height: screenHeight,
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок
                      Text(
                        'Статистика',
                        style: GoogleFonts.delaGothicOne(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.text,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Селектор периода
                      Row(
                        children: periods.map((period) {
                          final isSelected = selectedPeriod == period;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPeriod = period;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: period == periods.last ? 0 : 8.w,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textComplimentary.withOpacity(0.3),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    period,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.textAlternative
                                          : AppColors.text,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Gilroy',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 12.h),

                      // Основные метрики посещаемости - компактная версия
                      Row(
                        children: [
                          Expanded(
                            child: _CompactStatCard(
                              title: "Посещений",
                              value: _getVisitsCount().toString(),
                              icon: Icons.fitness_center,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: _CompactStatCard(
                              title: "Длительность",
                              value: _getAverageDuration(),
                              icon: Icons.timer,
                              color: AppColors.success,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: _CompactStatCard(
                              title: "Время",
                              value: _getBestTime(),
                              icon: Icons.access_time,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // История посещений
                      Expanded(
                        child: _buildHistoryList(),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Метод для отображения списка истории
  Widget _buildHistoryList() {
    // Сортируем записи по дате (последние первыми)
    final sortedHistory = List<VisitHistory>.from(_visitHistory);
    sortedHistory.sort((a, b) => b.startDate.compareTo(a.startDate));

    // Фильтруем по выбранному периоду
    final filteredHistory = _filterVisitsByPeriod(sortedHistory);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'История посещений',
          style: GoogleFonts.delaGothicOne(
            fontSize: 18.sp,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: filteredHistory.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 48.sp,
                        color: AppColors.textComplimentary.withOpacity(0.5),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Нет посещений за выбранный период',
                        style: TextStyle(
                          color: AppColors.textComplimentary,
                          fontSize: 14.sp,
                          fontFamily: 'Gilroy',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: filteredHistory.length,
                  itemBuilder: (context, index) {
                    final visit = filteredHistory[index];
                    return _VisitHistoryCard(visit: visit);
                  },
                ),
        ),
      ],
    );
  }

  // Фильтрация посещений по выбранному периоду
  List<VisitHistory> _filterVisitsByPeriod(List<VisitHistory> visits) {
    final now = DateTime.now();
    DateTime startDate;

    switch (selectedPeriod) {
      case 'Неделя':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'Месяц':
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case 'Год':
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    return visits.where((visit) => visit.startDate.isAfter(startDate)).toList();
  }

  // Подсчет количества посещений за период
  int _getVisitsCount() {
    final filteredVisits = _filterVisitsByPeriod(_visitHistory);
    return filteredVisits.length;
  }

  // Вычисление средней продолжительности
  String _getAverageDuration() {
    final filteredVisits = _filterVisitsByPeriod(_visitHistory);

    if (filteredVisits.isEmpty) return '0м';

    final totalMinutes = filteredVisits.fold<int>(
      0,
      (sum, visit) {
        final duration = visit.endDate.difference(visit.startDate).inMinutes;
        return sum + duration;
      },
    );

    final avgMinutes = totalMinutes ~/ filteredVisits.length;
    final hours = avgMinutes ~/ 60;
    final minutes = avgMinutes % 60;

    if (hours > 0) {
      return '$hoursч $minutesм';
    } else {
      return '$minutesм';
    }
  }

  // Определение лучшего времени посещения
  String _getBestTime() {
    final filteredVisits = _filterVisitsByPeriod(_visitHistory);
    
    if (filteredVisits.isEmpty) return 'Нет данных';

    // Группируем по часам
    final hourCounts = <int, int>{};
    for (var visit in filteredVisits) {
      final hour = visit.startDate.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    // Находим самый популярный час
    var maxCount = 0;
    var bestHour = 0;
    hourCounts.forEach((hour, count) {
      if (count > maxCount) {
        maxCount = count;
        bestHour = hour;
      }
    });

    return '${bestHour.toString().padLeft(2, '0')}:00';
  }
}

class _CompactStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _CompactStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 20.sp,
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: GoogleFonts.delaGothicOne(
              color: AppColors.text,
              fontSize: 18.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textComplimentary,
              fontSize: 10.sp,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VisitHistoryCard extends StatelessWidget {
  final VisitHistory visit;

  const _VisitHistoryCard({required this.visit});

  @override
  Widget build(BuildContext context) {
    // Форматируем дату и время
    final startDate = visit.startDate;
    final endDate = visit.endDate;
    
    final dateStr = '${startDate.day.toString().padLeft(2, '0')}.${startDate.month.toString().padLeft(2, '0')}.${startDate.year}';
    final startTimeStr = '${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}';
    final endTimeStr = '${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}';
    
    final durationMinutes = endDate.difference(startDate).inMinutes;
    final durationStr = _formatDuration(durationMinutes);

    // Форматируем день недели
    const weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final weekdayStr = weekdays[startDate.weekday - 1];

    // Получаем детальную информацию, если она загружена
    final scheduleItem = visit.scheduleItem;
    final activity = scheduleItem?.activity;
    final trainers = scheduleItem?.trainers ?? [];
    final room = scheduleItem?.room;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок с датой и днем недели
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14.sp,
                    color: AppColors.textComplimentary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '$dateStr ($weekdayStr)',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 12.sp,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Посещено',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Название активности (если есть)
          if (activity != null) ...[
            Text(
              activity.title,
              style: GoogleFonts.delaGothicOne(
                fontSize: 16.sp,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 8.h),
          ],

          // Время посещения
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$startTimeStr - $endTimeStr',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Тренер (если есть)
          if (trainers.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16.sp,
                  color: AppColors.textComplimentary,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    trainers.map((t) => t.title).join(', '),
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 13.sp,
                      fontFamily: 'Gilroy',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],

          // Зал (если есть)
          if (room != null) ...[
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.sp,
                  color: AppColors.textComplimentary,
                ),
                SizedBox(width: 8.w),
                Text(
                  room.title ?? 'Зал',
                  style: TextStyle(
                    color: AppColors.textComplimentary,
                    fontSize: 13.sp,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],

          // Длительность
          Row(
            children: [
              Icon(
                Icons.timer,
                size: 16.sp,
                color: AppColors.textComplimentary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Длительность: $durationStr',
                style: TextStyle(
                  color: AppColors.textComplimentary,
                  fontSize: 13.sp,
                  fontFamily: 'Gilroy',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0) {
      return '$hoursч $minsм';
    } else {
      return '$minsм';
    }
  }
}

