import 'package:flutter/material.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/components/animated_tap.dart';

class ClassSession {
  final String category; // Йога, Пилатес, HIIT и т.д.
  final String title;
  final String trainer;
  final DateTime dateTime;
  final int durationMinutes;
  final String location;
  final int capacity;
  int booked;

  ClassSession({
    required this.category,
    required this.title,
    required this.trainer,
    required this.dateTime,
    required this.durationMinutes,
    required this.location,
    required this.capacity,
    required this.booked,
  });

  int get spotsLeft => capacity - booked;
  bool get isFull => spotsLeft <= 0;
}

class Event {
  final String title;
  final String description;
  final DateTime dateTime;
  final int durationMinutes;
  final String location;
  final String organizer;
  final int capacity;
  int registered;
  final bool isSpecial;

  Event({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.durationMinutes,
    required this.location,
    required this.organizer,
    required this.capacity,
    required this.registered,
    this.isSpecial = false,
  });

  int get spotsLeft => capacity - registered;
  bool get isFull => spotsLeft <= 0;
}

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({Key? key}) : super(key: key);

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  // Категории скрыты, список временно не используется
  int _selectedTab = 0; // 0 - занятия, 1 - мероприятия

  final List<ClassSession> _sessions = [
    ClassSession(
      category: 'Йога',
      title: 'Утреняя йога',
      trainer: 'Анастасия',
      dateTime: DateTime.now().add(const Duration(hours: 3)),
      durationMinutes: 60,
      location: 'Зал Йога',
      capacity: 16,
      booked: 12,
    ),
    ClassSession(
      category: 'Пилатес',
      title: 'Пилатес Core',
      trainer: 'Марина',
      dateTime: DateTime.now().add(const Duration(hours: 5)),
      durationMinutes: 50,
      location: 'Студия 2',
      capacity: 14,
      booked: 10,
    ),
    ClassSession(
      category: 'HIIT',
      title: 'Интенсивный HIIT',
      trainer: 'Игорь',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
      durationMinutes: 40,
      location: 'Зал А',
      capacity: 20,
      booked: 19,
    ),
    ClassSession(
      category: 'Стретчинг',
      title: 'Гибкость и мобилити',
      trainer: 'Ева',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 4)),
      durationMinutes: 45,
      location: 'Студия 1',
      capacity: 18,
      booked: 7,
    ),
    ClassSession(
      category: 'Зумба',
      title: 'Вечерняя Zumba',
      trainer: 'Дана',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
      durationMinutes: 55,
      location: 'Зал В',
      capacity: 25,
      booked: 20,
    ),
  ];

  final List<Event> _events = [
    Event(
      title: 'Мастер-класс по функциональному тренингу',
      description:
          'Изучите основы функционального тренинга с профессиональным тренером',
      dateTime: DateTime.now().add(const Duration(days: 3, hours: 2)),
      durationMinutes: 90,
      location: 'Зал А',
      organizer: 'Champion Fitness',
      capacity: 30,
      registered: 18,
      isSpecial: true,
    ),
    Event(
      title: 'Соревнования по кроссфиту',
      description: 'Еженедельные соревнования для всех уровней подготовки',
      dateTime: DateTime.now().add(const Duration(days: 5, hours: 1)),
      durationMinutes: 120,
      location: 'Зал В',
      organizer: 'CrossFit Community',
      capacity: 50,
      registered: 35,
    ),
    Event(
      title: 'Йога-ретрит выходного дня',
      description: 'Полный день практики йоги, медитации и релаксации',
      dateTime: DateTime.now().add(const Duration(days: 7)),
      durationMinutes: 480,
      location: 'Студия 1',
      organizer: 'Yoga Studio',
      capacity: 20,
      registered: 12,
      isSpecial: true,
    ),
    Event(
      title: 'Семинар по питанию',
      description: 'Как правильно питаться для достижения ваших фитнес-целей',
      dateTime: DateTime.now().add(const Duration(days: 10, hours: 3)),
      durationMinutes: 60,
      location: 'Конференц-зал',
      organizer: 'Nutrition Expert',
      capacity: 40,
      registered: 25,
    ),
  ];

  String _search = '';
  DateTime? _selectedDate;
  String _selectedCategory = 'Все';

  List<ClassSession> get _filteredSessions {
    return _sessions.where((s) {
      final matchesCategory =
          _selectedCategory == 'Все' || s.category == _selectedCategory;
      final matchesSearch =
          s.title.toLowerCase().contains(_search.toLowerCase()) ||
          s.trainer.toLowerCase().contains(_search.toLowerCase());
      final matchesDate =
          _selectedDate == null ||
          (s.dateTime.year == _selectedDate!.year &&
              s.dateTime.month == _selectedDate!.month &&
              s.dateTime.day == _selectedDate!.day);
      return matchesCategory && matchesSearch && matchesDate;
    }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<Event> get _filteredEvents {
    return _events.where((e) {
      final matchesSearch =
          e.title.toLowerCase().contains(_search.toLowerCase()) ||
          e.organizer.toLowerCase().contains(_search.toLowerCase());
      final matchesDate =
          _selectedDate == null ||
          (e.dateTime.year == _selectedDate!.year &&
              e.dateTime.month == _selectedDate!.month &&
              e.dateTime.day == _selectedDate!.day);
      return matchesSearch && matchesDate;
    }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

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

            // Табы
            _buildTabBar(),

            SizedBox(height: 16.h),

            // Поиск
            _buildSearchBar(),

            SizedBox(height: 12.h),

            // Выбор даты
            _buildDatePicker(context),

            SizedBox(height: 16.h),

            // Список занятий или мероприятий
            Expanded(
              child: _selectedTab == 0
                  ? _buildSessionsList()
                  : _buildEventsList(),
            ),
          ],
        ),
      ),
      // FAB убран — запись происходит из карточки занятия
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedTap(
              onTap: () => setState(() => _selectedTab = 0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Занятия',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedTab == 0
                        ? AppColors.textAlternative
                        : AppColors.text,
                    fontFamily: 'Gilroy',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedTap(
              onTap: () => setState(() => _selectedTab = 1),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Мероприятия',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedTab == 1
                        ? AppColors.textAlternative
                        : AppColors.text,
                    fontFamily: 'Gilroy',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: _selectedTab == 0
            ? 'Поиск по типу или тренеру...'
            : 'Поиск по мероприятию или организатору...',
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

  // Категории скрыты — виджет удалён

  Widget _buildDatePicker(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Дата: ${_selectedDate == null ? 'Все даты' : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}'}',
            style: TextStyle(
              color: AppColors.text,
              fontFamily: 'Gilroy',
              fontSize: 14.sp,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now().add(const Duration(days: 90)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.primary,
                      onPrimary: AppColors.textAlternative,
                      surface: AppColors.backgroundComplimentary,
                      onSurface: AppColors.text,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              setState(() {
                _selectedDate = date;
              });
            }
          },
          icon: Icon(
            Icons.calendar_today,
            color: AppColors.primary,
            size: 20.sp,
          ),
          label: Text(
            'Выбрать дату',
            style: TextStyle(
              color: AppColors.primary,
              fontFamily: 'Gilroy',
              fontSize: 14.sp,
            ),
          ),
        ),
        if (_selectedDate != null)
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = null;
              });
            },
            icon: Icon(Icons.clear, color: AppColors.error, size: 20.sp),
          ),
      ],
    );
  }

  Widget _buildSessionsList() {
    if (_filteredSessions.isEmpty) {
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
      itemCount: _filteredSessions.length,
      itemBuilder: (context, index) {
        final session = _filteredSessions[index];
        return _SessionCard(
          session: session,
          onBook: () => _bookSession(session),
        );
      },
    );
  }

  Widget _buildEventsList() {
    if (_filteredEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event, size: 64.sp, color: AppColors.textComplimentary),
            SizedBox(height: 16.h),
            Text(
              'Нет доступных мероприятий',
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
      itemCount: _filteredEvents.length,
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        return _EventCard(
          event: event,
          onRegister: () => _registerEvent(event),
        );
      },
    );
  }

  void _bookSession(ClassSession session) {
    if (session.isFull) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Мест нет — выберите другое время'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() {
      session.booked += 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вы записаны: ${session.title} (${session.category})'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _registerEvent(Event event) {
    if (event.isFull) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Мест нет — выберите другое мероприятие'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() {
      event.registered += 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вы зарегистрированы: ${event.title}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // Диалог добавления тренировок больше не используется в новой концепции записи на занятия
}

class _SessionCard extends StatelessWidget {
  final ClassSession session;
  final VoidCallback onBook;

  const _SessionCard({required this.session, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Card(
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.title,
                          style: GoogleFonts.delaGothicOne(
                            fontSize: 16.sp,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          session.category,
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 12.sp,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (session.isFull ? AppColors.error : AppColors.primary)
                              .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      session.isFull
                          ? 'Нет мест'
                          : 'Осталось: ${session.spotsLeft}',
                      style: TextStyle(
                        color: session.isFull
                            ? AppColors.error
                            : AppColors.primary,
                        fontSize: 12.sp,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: AppColors.textComplimentary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    session.trainer,
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.textComplimentary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    session.location,
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: AppColors.textComplimentary,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${session.durationMinutes} мин',
                        style: TextStyle(
                          color: AppColors.textComplimentary,
                          fontSize: 14.sp,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${session.dateTime.day}.${session.dateTime.month}.${session.dateTime.year}  ${session.dateTime.hour.toString().padLeft(2, '0')}:${session.dateTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              SizedBox(
                width: double.infinity,
                child: AnimatedTap(
                  onTap: session.isFull ? null : onBook,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: session.isFull
                          ? AppColors.error
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      session.isFull ? 'Мест нет' : 'Записаться',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 16.sp,
                        color: AppColors.textAlternative,
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
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onRegister;

  const _EventCard({required this.event, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Card(
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (event.isSpecial)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'СПЕЦИАЛЬНОЕ',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Gilroy',
                                  ),
                                ),
                              ),
                            if (event.isSpecial) SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                event.title,
                                style: GoogleFonts.delaGothicOne(
                                  fontSize: 16.sp,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          event.description,
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 12.sp,
                            fontFamily: 'Gilroy',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (event.isFull ? AppColors.error : AppColors.primary)
                              .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.isFull
                          ? 'Нет мест'
                          : 'Осталось: ${event.spotsLeft}',
                      style: TextStyle(
                        color: event.isFull
                            ? AppColors.error
                            : AppColors.primary,
                        fontSize: 12.sp,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              Row(
                children: [
                  Icon(
                    Icons.business,
                    color: AppColors.textComplimentary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    event.organizer,
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.textComplimentary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    event.location,
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: AppColors.textComplimentary,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${event.durationMinutes ~/ 60}ч ${event.durationMinutes % 60}м',
                        style: TextStyle(
                          color: AppColors.textComplimentary,
                          fontSize: 14.sp,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${event.dateTime.day}.${event.dateTime.month}.${event.dateTime.year}  ${event.dateTime.hour.toString().padLeft(2, '0')}:${event.dateTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              SizedBox(
                width: double.infinity,
                child: AnimatedTap(
                  onTap: event.isFull ? null : onRegister,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: event.isFull ? AppColors.error : AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.isFull ? 'Мест нет' : 'Зарегистрироваться',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 16.sp,
                        color: AppColors.textAlternative,
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
    );
  }
}

// Удалён старый вспомогательный виджет деталей тренировки
