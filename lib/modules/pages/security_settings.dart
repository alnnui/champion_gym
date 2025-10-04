import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/modules/components/animated_tap.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({Key? key}) : super(key: key);

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _twoFactorAuth = false;
  bool _biometricAuth = true;
  bool _autoLock = true;
  bool _sessionTimeout = true;
  bool _loginNotifications = true;
  bool _deviceManagement = true;
  String _autoLockTime = '5 минут';
  String _sessionTimeoutTime = '30 минут';

  final List<String> _autoLockTimes = [
    '1 минута',
    '5 минут',
    '15 минут',
    '30 минут',
    '1 час',
  ];
  final List<String> _sessionTimeoutTimes = [
    '15 минут',
    '30 минут',
    '1 час',
    '2 часа',
    'Никогда',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _twoFactorAuth = prefs.getBool('two_factor_auth') ?? false;
        _biometricAuth = prefs.getBool('biometric_auth') ?? true;
        _autoLock = prefs.getBool('auto_lock') ?? true;
        _sessionTimeout = prefs.getBool('session_timeout') ?? true;
        _loginNotifications = prefs.getBool('login_notifications') ?? true;
        _deviceManagement = prefs.getBool('device_management') ?? true;
        _autoLockTime = prefs.getString('auto_lock_time') ?? '5 минут';
        _sessionTimeoutTime =
            prefs.getString('session_timeout_time') ?? '30 минут';
      });
    } catch (e) {
      debugPrint('Ошибка загрузки настроек безопасности: $e');
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
          'Безопасность',
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
            // Аутентификация
            _buildSection(
              title: 'Аутентификация',
              icon: Icons.security,
              children: [
                _buildSwitchTile(
                  title: 'Двухфакторная аутентификация',
                  subtitle: 'Дополнительная защита аккаунта',
                  value: _twoFactorAuth,
                  onChanged: (value) {
                    setState(() {
                      _twoFactorAuth = value;
                    });
                    _saveSetting('two_factor_auth', value);
                    if (value) {
                      _show2FASetupDialog();
                    }
                  },
                ),
                SizedBox(height: 16.h),
                _buildSwitchTile(
                  title: 'Биометрическая аутентификация',
                  subtitle: 'Вход по отпечатку пальца или Face ID',
                  value: _biometricAuth,
                  onChanged: (value) {
                    setState(() {
                      _biometricAuth = value;
                    });
                    _saveSetting('biometric_auth', value);
                  },
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Блокировка
            _buildSection(
              title: 'Блокировка',
              icon: Icons.lock,
              children: [
                _buildSwitchTile(
                  title: 'Автоблокировка',
                  subtitle: 'Автоматическая блокировка приложения',
                  value: _autoLock,
                  onChanged: (value) {
                    setState(() {
                      _autoLock = value;
                    });
                    _saveSetting('auto_lock', value);
                  },
                ),
                if (_autoLock) ...[
                  SizedBox(height: 16.h),
                  _buildAutoLockTimeSelector(),
                ],
                SizedBox(height: 16.h),
                _buildSwitchTile(
                  title: 'Таймаут сессии',
                  subtitle: 'Автоматический выход из сессии',
                  value: _sessionTimeout,
                  onChanged: (value) {
                    setState(() {
                      _sessionTimeout = value;
                    });
                    _saveSetting('session_timeout', value);
                  },
                ),
                if (_sessionTimeout) ...[
                  SizedBox(height: 16.h),
                  _buildSessionTimeoutSelector(),
                ],
              ],
            ),

            SizedBox(height: 24.h),

            // Уведомления безопасности
            _buildSection(
              title: 'Уведомления безопасности',
              icon: Icons.notifications_active,
              children: [
                _buildSwitchTile(
                  title: 'Уведомления о входе',
                  subtitle: 'Уведомления о входе в аккаунт',
                  value: _loginNotifications,
                  onChanged: (value) {
                    setState(() {
                      _loginNotifications = value;
                    });
                    _saveSetting('login_notifications', value);
                  },
                ),
                SizedBox(height: 16.h),
                _buildSwitchTile(
                  title: 'Управление устройствами',
                  subtitle: 'Контроль подключенных устройств',
                  value: _deviceManagement,
                  onChanged: (value) {
                    setState(() {
                      _deviceManagement = value;
                    });
                    _saveSetting('device_management', value);
                  },
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Пароль
            _buildSection(
              title: 'Пароль',
              icon: Icons.key,
              children: [
                _buildActionTile(
                  title: 'Изменить пароль',
                  subtitle: 'Обновить текущий пароль',
                  icon: Icons.edit,
                  onTap: () => _showChangePasswordDialog(),
                ),
                SizedBox(height: 16.h),
                _buildActionTile(
                  title: 'Восстановление пароля',
                  subtitle: 'Настроить способы восстановления',
                  icon: Icons.restore,
                  onTap: () => _showPasswordRecoveryDialog(),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Активные сессии
            _buildSection(
              title: 'Активные сессии',
              icon: Icons.devices,
              children: [
                _buildActionTile(
                  title: 'Управление устройствами',
                  subtitle: 'Просмотр и управление устройствами',
                  icon: Icons.phone_android,
                  onTap: () => _showDeviceManagement(),
                ),
                SizedBox(height: 16.h),
                _buildActionTile(
                  title: 'История входов',
                  subtitle: 'Просмотр истории входов в аккаунт',
                  icon: Icons.history,
                  onTap: () => _showLoginHistory(),
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
                  title: 'Экспорт данных',
                  subtitle: 'Скачать все данные аккаунта',
                  icon: Icons.download,
                  onTap: () => _showExportDataDialog(),
                ),
                SizedBox(height: 16.h),
                _buildActionTile(
                  title: 'Удалить аккаунт',
                  subtitle: 'Безвозвратно удалить аккаунт',
                  icon: Icons.delete_forever,
                  onTap: () => _showDeleteAccountDialog(),
                  isDestructive: true,
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

  Widget _buildAutoLockTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Время автоблокировки',
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
              value: _autoLockTime,
              isExpanded: true,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14.sp,
                fontFamily: 'Gilroy',
              ),
              items: _autoLockTimes.map((String time) {
                return DropdownMenuItem<String>(value: time, child: Text(time));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _autoLockTime = newValue!;
                });
                _saveSetting('auto_lock_time', newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionTimeoutSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Таймаут сессии',
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
              value: _sessionTimeoutTime,
              isExpanded: true,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14.sp,
                fontFamily: 'Gilroy',
              ),
              items: _sessionTimeoutTimes.map((String time) {
                return DropdownMenuItem<String>(value: time, child: Text(time));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _sessionTimeoutTime = newValue!;
                });
                _saveSetting('session_timeout_time', newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColors.error : AppColors.primary,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDestructive ? AppColors.error : AppColors.text,
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

  void _show2FASetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Настройка 2FA',
          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
        ),
        content: Text(
          'В разработке. Скоро вы сможете настроить двухфакторную аутентификацию.',
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

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Изменение пароля',
          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
        ),
        content: Text(
          'В разработке. Скоро вы сможете изменить пароль.',
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

  void _showPasswordRecoveryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Восстановление пароля',
          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
        ),
        content: Text(
          'В разработке. Скоро вы сможете настроить способы восстановления пароля.',
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

  void _showDeviceManagement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Управление устройствами',
          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
        ),
        content: Text(
          'В разработке. Скоро вы сможете управлять подключенными устройствами.',
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

  void _showLoginHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'История входов',
          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
        ),
        content: Text(
          'В разработке. Скоро вы сможете просматривать историю входов в аккаунт.',
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

  void _showExportDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Экспорт данных',
          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
        ),
        content: Text(
          'В разработке. Скоро вы сможете экспортировать все данные аккаунта.',
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Удаление аккаунта',
          style: TextStyle(color: AppColors.error, fontFamily: 'Gilroy'),
        ),
        content: Text(
          'Это действие необратимо. Все ваши данные будут удалены навсегда.',
          style: TextStyle(
            color: AppColors.textComplimentary,
            fontFamily: 'Gilroy',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: TextStyle(
                color: AppColors.textComplimentary,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Здесь будет логика удаления аккаунта
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Удалить', style: TextStyle(fontFamily: 'Gilroy')),
          ),
        ],
      ),
    );
  }
}
