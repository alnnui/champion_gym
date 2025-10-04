import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/modules/pages/notifications_settings.dart';
import 'package:myapp/modules/pages/security_settings.dart';
import 'package:myapp/modules/components/animated_tap.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userPhone;

  @override
  void initState() {
    super.initState();
    _loadUserPhone();
  }

  Future<void> _loadUserPhone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _userPhone = prefs.getString('userPhone');
      });
    } catch (e) {
      // Можно логировать ошибку, если нужно
      debugPrint('Ошибка загрузки номера: $e');
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundComplimentary,
        title: Text(
          'Выход',
          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
        ),
        content: Text(
          'Вы уверены, что хотите выйти из аккаунта?',
          style: TextStyle(
            color: AppColors.textComplimentary,
            fontFamily: 'Gilroy',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Отмена',
              style: TextStyle(
                color: AppColors.textComplimentary,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.text,
            ),
            child: Text('Выйти', style: TextStyle(fontFamily: 'Gilroy')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        // Примеры ключей — поменяй под свои
        await prefs.remove('authToken');
        await prefs.remove('userPhone');

        if (!mounted) return;
        // Замените '/login' на ваш реальный маршрут экрана входа
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      } catch (e) {
        debugPrint('Ошибка при выходе: $e');
        // Можно показать SnackBar с ошибкой
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Не удалось выйти. Попробуйте снова.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Верхняя секция с профилем
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.background,
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40.sp,
                        color: AppColors.textAlternative,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Добро пожаловать, Алексей!',
                              style: TextStyle(
                                color: AppColors.text,
                                fontFamily: 'Gilroy',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              _userPhone ?? '+7-777-888-77-88',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: AppColors.textComplimentary,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: AppColors.success,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Premium',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 12.sp,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Редактирование профиля
                      },
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Настройки
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Настройки',
                    style: GoogleFonts.delaGothicOne(
                      fontSize: 18.sp,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _menuCard(
                    icon: FontAwesomeIcons.bell,
                    title: 'Уведомления',
                    subtitle: 'Настройка уведомлений',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotificationsSettingsPage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                  _menuCard(
                    icon: FontAwesomeIcons.shield,
                    title: 'Безопасность',
                    subtitle: 'Пароль, двухфакторная аутентификация',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecuritySettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Информация об абонементе
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Абонемент',
                    style: GoogleFonts.delaGothicOne(
                      fontSize: 18.sp,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _sectionCard(
                    icon: FontAwesomeIcons.ticket,
                    title: 'Текущий абонемент',
                    children: [
                      _infoRow('Тип', 'Premium'),
                      _infoRow('Срок действия', 'до 31.12.2025'),
                      _infoRow('Статус', 'Активен'),
                      _infoRow('Осталось дней', '45'),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  _sectionCard(
                    icon: FontAwesomeIcons.medal,
                    title: 'Достижения',
                    children: [
                      _infoRow('Уровень', 'Gold'),
                      _infoRow('Баллы', '1,250'),
                      _infoRow('Следующий уровень', 'Platinum (2,000 баллов)'),
                      _infoRow('Прогресс', '62%'),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  _sectionCard(
                    icon: FontAwesomeIcons.building,
                    title: 'Клуб',
                    children: [
                      _infoRow('Название', 'Champion Fitness'),
                      _infoRow('Адрес', 'ул. Кажымукана, 123'),
                      _infoRow('Телефон', '+7 (777) 123-45-67'),
                      _infoRow('Режим работы', '24/7'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Кнопка выхода
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.text,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(FontAwesomeIcons.signOut, size: 18.sp),
                  label: Text(
                    'Выйти из аккаунта',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AnimatedTap(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16.sp,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textComplimentary,
              fontSize: 14.sp,
              fontFamily: 'Gilroy',
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textComplimentary,
            size: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
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
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20.sp),
                ),
                SizedBox(width: 12.w),
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textComplimentary,
              fontSize: 14.sp,
              fontFamily: 'Gilroy',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 14.sp,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
