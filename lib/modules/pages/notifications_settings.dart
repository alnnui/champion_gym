import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/modules/components/animated_tap.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _pushNotifications = true;
  bool _workoutReminders = true;
  bool _achievementNotifications = true;
  bool _promotionNotifications = false;
  bool _clubUpdates = true;
  bool _trainerMessages = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _reminderTime = 'За час';
  String _notificationFrequency = 'Всегда';

  final List<String> _reminderTimes = [
    'За 30 минут',
    'За час',
    'За 2 часа',
    'За день',
  ];
  final List<String> _frequencies = ['Всегда', 'Только важные', 'Никогда'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _pushNotifications = prefs.getBool('push_notifications') ?? true;
        _workoutReminders = prefs.getBool('workout_reminders') ?? true;
        _achievementNotifications =
            prefs.getBool('achievement_notifications') ?? true;
        _promotionNotifications =
            prefs.getBool('promotion_notifications') ?? false;
        _clubUpdates = prefs.getBool('club_updates') ?? true;
        _trainerMessages = prefs.getBool('trainer_messages') ?? true;
        _soundEnabled = prefs.getBool('sound_enabled') ?? true;
        _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
        _reminderTime = prefs.getString('reminder_time') ?? 'За час';
        _notificationFrequency =
            prefs.getString('notification_frequency') ?? 'Всегда';
      });
    } catch (e) {
      debugPrint('Ошибка загрузки настроек уведомлений: $e');
    }
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    } catch (e) {
      debugPrint('Ошибка сохранения настройки: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.text, size: 20.sp),
        ),
        title: Text(
          'Уведомления',
          style: GoogleFonts.delaGothicOne(
            fontSize: 18.sp,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Общие настройки
            _buildSection(
              title: 'Общие настройки',
              icon: Icons.settings,
              children: [
                _buildSwitchTile(
                  title: 'Push-уведомления',
                  subtitle: 'Включить все уведомления',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                    _saveSetting('push_notifications', value);
                  },
                ),
                SizedBox(height: 16.h),
                _buildFrequencySelector(),
                SizedBox(height: 16.h),
                _buildSwitchTile(
                  title: 'Звук',
                  subtitle: 'Звуковые уведомления',
                  value: _soundEnabled,
                  onChanged: (value) {
                    setState(() {
                      _soundEnabled = value;
                    });
                    _saveSetting('sound_enabled', value);
                  },
                ),
                SizedBox(height: 16.h),
                _buildSwitchTile(
                  title: 'Вибрация',
                  subtitle: 'Вибрация при уведомлениях',
                  value: _vibrationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _vibrationEnabled = value;
                    });
                    _saveSetting('vibration_enabled', value);
                  },
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Тренировки
            _buildSection(
              title: 'Тренировки',
              icon: Icons.fitness_center,
              children: [
                _buildSwitchTile(
                  title: 'Напоминания о тренировках',
                  subtitle: 'Уведомления о предстоящих тренировках',
                  value: _workoutReminders,
                  onChanged: (value) {
                    setState(() {
                      _workoutReminders = value;
                    });
                    _saveSetting('workout_reminders', value);
                  },
                ),
                SizedBox(height: 16.h),
                _buildReminderTimeSelector(),
                SizedBox(height: 16.h),
                _buildSwitchTile(
                  title: 'Достижения',
                  subtitle: 'Уведомления о новых достижениях',
                  value: _achievementNotifications,
                  onChanged: (value) {
                    setState(() {
                      _achievementNotifications = value;
                    });
                    _saveSetting('achievement_notifications', value);
                  },
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Клуб и тренеры
            _buildSection(
              title: 'Клуб и тренеры',
              icon: Icons.business,
              children: [
                _buildSwitchTile(
                  title: 'Обновления клуба',
                  subtitle: 'Новости и изменения в клубе',
                  value: _clubUpdates,
                  onChanged: (value) {
                    setState(() {
                      _clubUpdates = value;
                    });
                    _saveSetting('club_updates', value);
                  },
                ),
                SizedBox(height: 16.h),
                _buildSwitchTile(
                  title: 'Сообщения от тренеров',
                  subtitle: 'Персональные сообщения от тренеров',
                  value: _trainerMessages,
                  onChanged: (value) {
                    setState(() {
                      _trainerMessages = value;
                    });
                    _saveSetting('trainer_messages', value);
                  },
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Маркетинг
            _buildSection(
              title: 'Маркетинг',
              icon: Icons.campaign,
              children: [
                _buildSwitchTile(
                  title: 'Промо-акции',
                  subtitle: 'Специальные предложения и скидки',
                  value: _promotionNotifications,
                  onChanged: (value) {
                    setState(() {
                      _promotionNotifications = value;
                    });
                    _saveSetting('promotion_notifications', value);
                  },
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Время уведомлений
            _buildSection(
              title: 'Время уведомлений',
              icon: Icons.access_time,
              children: [
                _buildTimeRangeTile(
                  title: 'Тихие часы',
                  subtitle: 'Не беспокоить с 22:00 до 08:00',
                  icon: Icons.bedtime,
                  onTap: () => _showQuietHoursDialog(),
                ),
                SizedBox(height: 16.h),
                _buildTimeRangeTile(
                  title: 'Рабочие часы',
                  subtitle: 'Уведомления только в рабочее время',
                  icon: Icons.work,
                  onTap: () => _showWorkHoursDialog(),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Дополнительно
            _buildSection(
              title: 'Дополнительно',
              icon: Icons.more_horiz,
              children: [
                _buildActionTile(
                  title: 'Тестовое уведомление',
                  subtitle: 'Отправить тестовое уведомление',
                  icon: Icons.send,
                  onTap: () => _sendTestNotification(),
                ),
                SizedBox(height: 16.h),
                _buildActionTile(
                  title: 'История уведомлений',
                  subtitle: 'Просмотр всех уведомлений',
                  icon: Icons.history,
                  onTap: () => _showNotificationHistory(),
                ),
              ],
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: GoogleFonts.delaGothicOne(
                    fontSize: 16.sp,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textComplimentary,
                  fontSize: 14.sp,
                  fontFamily: 'Gilroy',
                ),
              ),
            ],
          ),
        ),
        AnimatedTap(
          onTap: () => onChanged(!value),
          child: Container(
            width: 50.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: value
                  ? AppColors.primary
                  : AppColors.backgroundComplimentary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: AnimatedAlign(
              duration: Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 26.w,
                height: 26.h,
                margin: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Частота уведомлений',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 16.sp,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.backgroundComplimentary),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _notificationFrequency,
              isExpanded: true,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14.sp,
                fontFamily: 'Gilroy',
              ),
              items: _frequencies.map((String frequency) {
                return DropdownMenuItem<String>(
                  value: frequency,
                  child: Text(frequency),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _notificationFrequency = newValue!;
                });
                _saveSetting('notification_frequency', newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReminderTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Время напоминания',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 16.sp,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.backgroundComplimentary),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _reminderTime,
              isExpanded: true,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14.sp,
                fontFamily: 'Gilroy',
              ),
              items: _reminderTimes.map((String time) {
                return DropdownMenuItem<String>(value: time, child: Text(time));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _reminderTime = newValue!;
                });
                _saveSetting('reminder_time', newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRangeTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 16.sp,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textComplimentary,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 16.sp,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textComplimentary,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showQuietHoursDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Тихие часы',
          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
        ),
        content: Text(
          'В разработке. Скоро вы сможете настроить время, когда не хотите получать уведомления.',
          style: TextStyle(
            color: AppColors.textComplimentary,
            fontFamily: 'Gilroy',
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Понятно', style: TextStyle(fontFamily: 'Gilroy')),
          ),
        ],
      ),
    );
  }

  void _showWorkHoursDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Рабочие часы',
          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
        ),
        content: Text(
          'В разработке. Скоро вы сможете настроить рабочие часы для получения уведомлений.',
          style: TextStyle(
            color: AppColors.textComplimentary,
            fontFamily: 'Gilroy',
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Понятно', style: TextStyle(fontFamily: 'Gilroy')),
          ),
        ],
      ),
    );
  }

  void _sendTestNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Тестовое уведомление отправлено'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showNotificationHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'История уведомлений',
          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
        ),
        content: Text(
          'В разработке. Скоро вы сможете просматривать историю всех уведомлений.',
          style: TextStyle(
            color: AppColors.textComplimentary,
            fontFamily: 'Gilroy',
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Понятно', style: TextStyle(fontFamily: 'Gilroy')),
          ),
        ],
      ),
    );
  }
}
