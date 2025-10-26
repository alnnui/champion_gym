import 'package:flutter/material.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/components/animated_tap.dart';
import 'package:myapp/modules/models/activity.dart';
import 'package:myapp/modules/models/schedule_models.dart';
import 'package:myapp/main.dart';
import 'package:myapp/modules/api/services/club_service.dart';
import 'package:myapp/modules/widgets/date_range_picker.dart';
import 'dart:io';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  late ClubService _clubService;
  List<Activity> _activities = [];
  List<Group> _groups = [];
  List<ScheduleActivity> _scheduleItems = [];
  
  Group? _selectedGroup;
  ActivityType? _selectedActivityType;
  
  DateTime? _dateSince;
  DateTime? _dateTo;
  int? _selectedYear;
  int? _selectedWeek;
  
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _clubService = ClubService(dio);
    _loadActivities();
  }

  @override
  void dispose() {
    // Отменяем асинхронные операции при удалении виджета
    super.dispose();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      // Using fallback club ID
      final int fallbackClubId = 2511;
      final int clubId = fallbackClubId;
      
      // Загружаем расписание клуба с параметрами year и week
      final scheduleResponse = await _clubService.getClubSchedule(
        clubId,
        year: _selectedYear,
        week: _selectedWeek,
      );
      
      // Также загружаем иерархию групп для фильтрации
      final groups = await _clubService.getActivitiesHierarchy();
      
      // Проверяем, что виджет еще в дереве перед setState()
      if (!mounted) return;
      
      setState(() {
        _scheduleItems = scheduleResponse.schedule;
        _groups = groups;
        
        // Собираем все activities из всех групп и типов (для справки)
        _activities = [];
        for (var group in groups) {
          final activityTypes = group.activityTypes ?? [];
          for (var activityType in activityTypes) {
            final activities = activityType.activities ?? [];
            _activities.addAll(activities);
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      // Проверяем mounted перед setState() в блоке catch
      if (!mounted) return;
      
      // Определяем тип ошибки
      String errorMessage;
      if (e is SocketException) {
        errorMessage = 'Нет подключения к интернету';
      } else if (e.toString().contains('Failed host lookup') || 
                 e.toString().contains('Network is unreachable')) {
        errorMessage = 'Нет подключения к интернету';
      } else if (e.toString().contains('Connection refused') ||
                 e.toString().contains('Connection timed out')) {
        errorMessage = 'Не удалось подключиться к серверу';
      } else {
        errorMessage = 'Ошибка загрузки данных';
      }
      
      setState(() {
        _error = errorMessage;
        _isLoading = false;
      });
    }
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
        _loadActivities();
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
    _loadActivities();
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

  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Text(
              'Запись на занятия',
              style: GoogleFonts.delaGothicOne(
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.text,
              ),
            ),

            SizedBox(height: 16.h),

            // Date range selector
            _buildDateRangeSelector(),

            SizedBox(height: 16.h),

            // Показываем загрузку или ошибку
            if (_isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              )
            else if (_error != null)
              Expanded(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Иконка ошибки
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _error!.contains('интернету')
                                ? Icons.wifi_off
                                : _error!.contains('серверу')
                                    ? Icons.cloud_off
                                    : Icons.error_outline,
                            size: 48.sp,
                            color: AppColors.error,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        
                        // Заголовок ошибки
                        Text(
                          _error!,
                          style: GoogleFonts.delaGothicOne(
                            fontSize: 16.sp,
                            color: AppColors.text,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        
                        // Подсказка
                        Text(
                          _error!.contains('интернету')
                              ? 'Проверьте подключение к сети и попробуйте снова'
                              : 'Попробуйте обновить данные',
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 12.sp,
                            fontFamily: 'Gilroy',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        
                        // Кнопка повтора
                        ElevatedButton(
                          onPressed: _loadActivities,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textAlternative,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 14.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Повторить',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Gilroy',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else ...[
              // Выбор группы
              Text(
                'Группы',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                  fontFamily: 'Gilroy',
                ),
              ),
              SizedBox(height: 8.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _groups.map((group) {
                    final isSelected = _selectedGroup?.id == group.id;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: AnimatedTap(
                        onTap: () => setState(() {
                          _selectedGroup = isSelected ? null : group;
                          _selectedActivityType = null;
                        }),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
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
                                  : AppColors.textComplimentary,
                            ),
                          ),
                          child: Text(
                            group.title,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isSelected
                                  ? AppColors.textAlternative
                                  : AppColors.text,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 16.h),

              // Выбор типа активности
              if (_selectedGroup != null && (_selectedGroup!.activityTypes?.isNotEmpty ?? false)) ...[
                Text(
                  'Типы активности',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    fontFamily: 'Gilroy',
                  ),
                ),
                SizedBox(height: 8.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: (_selectedGroup!.activityTypes ?? []).map((activityType) {
                      final isSelected = _selectedActivityType?.id == activityType.id;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: AnimatedTap(
                          onTap: () => setState(() {
                            _selectedActivityType = isSelected ? null : activityType;
                          }),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
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
                                    : AppColors.textComplimentary,
                              ),
                            ),
                            child: Text(
                              activityType.title,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isSelected
                                    ? AppColors.textAlternative
                                    : AppColors.text,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              // Поиск
              _buildSearchBar(),

              SizedBox(height: 16.h),

              // Список занятий
              Expanded(
                child: _buildSessionsList(),
              ),
            ],
          ],
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

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Поиск по названию...',
        hintStyle: TextStyle(
          color: AppColors.textComplimentary,
          fontFamily: 'Gilroy',
        ),
        prefixIcon: Icon(Icons.search, color: AppColors.textComplimentary),
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
      onChanged: (value) {
        setState(() {
          _search = value;
        });
      },
    );
  }

  Widget _buildSessionsList() {
    List<ScheduleActivity> displayItems = _scheduleItems;
    
    // Применяем фильтры по группе и типу активности
    if (_selectedGroup != null || _selectedActivityType != null) {
      displayItems = displayItems.where((scheduleItem) {
        final activity = scheduleItem.activity;
        if (activity == null) return false;
        
        // Находим, к какой группе и типу относится эта активность
        for (var group in _groups) {
          if (_selectedGroup != null && group.id != _selectedGroup!.id) {
            continue;
          }
          
          for (var activityType in (group.activityTypes ?? [])) {
            if (_selectedActivityType != null && activityType.id != _selectedActivityType!.id) {
              continue;
            }
            
            // Проверяем, есть ли эта активность в текущем типе
            final hasActivity = (activityType.activities ?? []).any((a) => a.id == activity.id);
            if (hasActivity) {
              return true;
            }
          }
        }
        return false;
      }).toList();
    }
    
    // Применяем поиск
    displayItems = displayItems.where((scheduleItem) {
      final activity = scheduleItem.activity;
      if (activity == null) return false;
      
      final matchesSearch = activity.title.toLowerCase().contains(_search.toLowerCase()) ||
          (activity.description?.toLowerCase().contains(_search.toLowerCase()) ?? false);
      return matchesSearch;
    }).toList();
    
    // Разделяем на прошедшие и будущие тренировки
    final now = DateTime.now();
    final upcomingItems = <ScheduleActivity>[];
    final pastItems = <ScheduleActivity>[];
    
    for (var item in displayItems) {
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
    displayItems = [...upcomingItems, ...pastItems];

    if (displayItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64.sp,
              color: AppColors.textComplimentary,
            ),
            SizedBox(height: 16.h),
            Text(
              'Нет доступных занятий',
              style: TextStyle(
                color: AppColors.textComplimentary,
                fontSize: 16.sp,
                fontFamily: 'Gilroy',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: displayItems.length,
      itemBuilder: (context, index) {
        final scheduleItem = displayItems[index];
        final activity = scheduleItem.activity;
        
        // Найдём группу и тип активности для этого activity
        String? groupTitle;
        String? activityTypeTitle;
        
        if (activity != null) {
          for (var group in _groups) {
            for (var activityType in (group.activityTypes ?? [])) {
              if ((activityType.activities ?? []).any((a) => a.id == activity.id)) {
                groupTitle = group.title;
                activityTypeTitle = activityType.title;
                break;
              }
            }
            if (groupTitle != null) break;
          }
        }
        
        return _ScheduleActivityCard(
          scheduleItem: scheduleItem,
          groupTitle: groupTitle,
          activityTypeTitle: activityTypeTitle,
          onBook: () => _bookActivity(scheduleItem),
        );
      },
    );
  }

  void _bookActivity(ScheduleActivity scheduleItem) async {
    // Проверяем, что тренировка еще не прошла
    if (scheduleItem.dateTime != null && scheduleItem.dateTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нельзя записаться на прошедшую тренировку'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Показываем индикатор загрузки
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16.h),
              Text(
                'Записываем на занятие...',
                style: TextStyle(
                  color: AppColors.text,
                  fontFamily: 'Gilroy',
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    try {
      // Вызываем API для записи
      final result = await _clubService.reserveActivitySchedule(scheduleItem.id);
      
      // Закрываем диалог загрузки
      if (mounted) Navigator.of(context).pop();
      
      // Проверяем результат
      if (result['result'] == 'success') {
        // Показываем сообщение об успехе
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Вы успешно записаны на ${scheduleItem.activity?.title ?? "занятие"}'),
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
        }
        
        // Обновляем список занятий
        _loadActivities();
      } else {
        // Неожиданный результат
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Неожиданный ответ от сервера'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      // Закрываем диалог загрузки
      if (mounted) Navigator.of(context).pop();
      
      // Показываем сообщение об ошибке
      if (mounted) {
        String errorMessage = 'Ошибка при записи на занятие';
        
        if (e is Exception) {
          final exceptionMessage = e.toString().replaceFirst('Exception: ', '');
          if (exceptionMessage.isNotEmpty) {
            errorMessage = exceptionMessage;
          }
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

}

class _ScheduleActivityCard extends StatelessWidget {
  final ScheduleActivity scheduleItem;
  final String? groupTitle;
  final String? activityTypeTitle;
  final VoidCallback onBook;

  const _ScheduleActivityCard({
    required this.scheduleItem,
    this.groupTitle,
    this.activityTypeTitle,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final activity = scheduleItem.activity;
    final trainers = scheduleItem.trainers ?? [];
    
    // Проверяем, прошла ли тренировка
    final isPast = scheduleItem.dateTime != null && 
                   scheduleItem.dateTime!.isBefore(DateTime.now());
    
    // Format date and time
    String dateStr = '';
    String timeStr = '';
    if (scheduleItem.dateTime != null) {
      final dt = scheduleItem.dateTime!;
      timeStr = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      
      // Форматируем дату: "26 октября" или "26 окт" для краткости
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
        margin: EdgeInsets.only(bottom: 12.h),
        child: Card(
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Time badge and title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date and Time badges
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
                                        fontFamily: 'Gilroy',
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
                                    fontFamily: 'Gilroy',
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        // Activity title
                        Text(
                          activity?.title ?? 'Без названия',
                          style: GoogleFonts.delaGothicOne(
                            fontSize: 16.sp,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        // Группа и тип активности
                        if (groupTitle != null || activityTypeTitle != null)
                          Text(
                            [groupTitle, activityTypeTitle]
                                .where((s) => s != null)
                                .join(' • '),
                            style: TextStyle(
                              color: AppColors.textComplimentary,
                              fontSize: 11.sp,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Rating badge
                  if (activity?.rating != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.primary,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${activity!.rating}',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12.sp,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              
              // Description
              if (activity?.description != null) ...[
                SizedBox(height: 8.h),
                Text(
                  activity!.description!,
                  style: TextStyle(
                    color: AppColors.textComplimentary,
                    fontSize: 12.sp,
                    fontFamily: 'Gilroy',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              SizedBox(height: 12.h),
              
              // Trainer info
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
                      trainerNames,
                      style: TextStyle(
                        color: AppColors.textComplimentary,
                        fontSize: 13.sp,
                        fontFamily: 'Gilroy',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              // Room info
              if (scheduleItem.room != null) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.sp,
                      color: AppColors.textComplimentary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      scheduleItem.room!.title ?? 'Зал не указан',
                      style: TextStyle(
                        color: AppColors.textComplimentary,
                        fontSize: 13.sp,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ],
                ),
              ],
              
              // Duration and other info
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (scheduleItem.length != null)
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          color: AppColors.textComplimentary,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${scheduleItem.length} мин',
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 14.sp,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ],
                    ),
                  if (activity?.commentsCount != null)
                    Row(
                      children: [
                        Icon(
                          Icons.comment,
                          color: AppColors.textComplimentary,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${activity!.commentsCount} комментариев',
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 12.sp,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              
              // Ratings
              if (activity?.ratings != null && activity!.ratings!.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Text(
                  'Оценки',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    fontFamily: 'Gilroy',
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: activity.ratings!.map((rating) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundComplimentary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            rating.parameter.title,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.text,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                index < rating.rating
                                    ? Icons.star
                                    : Icons.star_outline,
                                color: AppColors.primary,
                                size: 12.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '(${rating.votes})',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textComplimentary,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
              
              SizedBox(height: 12.h),
              
              // Book button
              SizedBox(
                width: double.infinity,
                child: AnimatedTap(
                  onTap: isPast ? null : onBook,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isPast 
                          ? AppColors.textComplimentary.withOpacity(0.3)
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isPast ? 'Тренировка завершена' : 'Записаться',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 16.sp,
                        color: isPast
                            ? AppColors.textComplimentary
                            : AppColors.textAlternative,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
