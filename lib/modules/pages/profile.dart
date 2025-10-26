import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/modules/providers/UserProvider.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/main.dart';
import 'package:myapp/modules/pages/deposits_page.dart';
import 'package:myapp/modules/pages/settings.dart';
import 'package:myapp/modules/pages/avatar_customization.dart';
import 'package:myapp/modules/api/services/account_service.dart';
import 'package:myapp/modules/models/service.dart' as service_model;
import 'package:myapp/modules/widgets/avatar/rive_avatar_widget.dart';
import 'package:myapp/modules/widgets/gamification_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AccountService _accountService;
  service_model.AccountService? _membership;
  bool _isLoadingMembership = false;

  @override
  void initState() {
    super.initState();
    _accountService = AccountService(dio);
    // Обновляем данные при входе на страницу
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUser();
      _loadMembership();
    });
  }

  Future<void> _openAvatarCustomization() async {
    final current = context.read<UserProvider>().userProfile?.avatarConfig;
    await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => AvatarCustomizationScreen(initialConfig: current),
      ),
    );
    // Avatar is saved via UserProvider; the watched profile already reflects it.
  }

  String _avatarInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts[0].characters.first + parts[1].characters.first).toUpperCase();
  }

  Future<void> _loadMembership() async {
    setState(() {
      _isLoadingMembership = true;
    });

    try {
      final membership = await _accountService.getActiveMembership();
      
      if (!mounted) return;
      
      setState(() {
        _membership = membership;
        _isLoadingMembership = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoadingMembership = false;
      });
      debugPrint('Ошибка загрузки абонемента: $e');
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
        final userProvider = context.read<UserProvider>();
        await userProvider.logout(); // Очищаем токен и данные пользователя

        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
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
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.userProfile;
    final name = profile?.username ?? profile?.phone ?? 'Пользователь';
    final phone = profile?.phone ?? '+7-777-888-77-88';
    final photoUrl = profile?.avatarUrl;
    final avatarConfig = profile?.avatarConfig;
    final statusBadge = profile?.level != null && profile!.level > 5 ? 'Premium' : 'Standard';
    final credits = 0; // TODO: добавить credits в новую модель
    final totalCredits = 0; // TODO: добавить totalCredits в новую модель

    // Club info  
    final clubName = 'Champion Fitness'; // TODO: добавить club в новую модель
    
    // Subscription info (from loaded membership or default)
    final subscriptionType = _membership?.title ?? statusBadge;
    final subscriptionStatus = _membership?.status ?? 'Не найден';
    final subscriptionExpiry = _membership?.endDate != null 
        ? 'до ${_membership!.endDate!.day.toString().padLeft(2, '0')}.${_membership!.endDate!.month.toString().padLeft(2, '0')}.${_membership!.endDate!.year}'
        : 'Не указано';
    final subscriptionDaysLeft = _membership?.daysLeft?.toString() ?? '-';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (userProvider.error != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  userProvider.error!,
                  style: TextStyle(color: AppColors.error, fontFamily: 'Gilroy'),
                ),
              ),
            // Верхняя секция с профилем
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _openAvatarCustomization,
                      child: Stack(
                        children: [
                          // Saved Rive avatar; falls back to the network photo
                          // or initials when no avatar has been customized.
                          avatarConfig != null
                              ? UserAvatarWidget(
                                  avatarConfig: avatarConfig,
                                  size: 80.w,
                                  backgroundColor: AppColors.primary,
                                  initials: _avatarInitials(name),
                                  textColor: AppColors.textAlternative,
                                  fontSize: 32.sp,
                                )
                              : Container(
                                  width: 80.w,
                                  height: 80.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    image: photoUrl != null &&
                                            photoUrl.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(photoUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: photoUrl == null || photoUrl.isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 40.sp,
                                          color: AppColors.textAlternative,
                                        )
                                      : null,
                                ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 26.w,
                              height: 26.w,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.background,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 14.sp,
                                color: AppColors.textAlternative,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Добро пожаловать, $name!',
                              style: TextStyle(
                                color: AppColors.text,
                                fontFamily: 'Gilroy',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              phone,
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: AppColors.textComplimentary,
                                fontSize: 16.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _logout,
                          icon: Icon(
                            Icons.logout,
                            color: AppColors.textComplimentary,
                            size: 22.sp,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        SizedBox(width: 12.w),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.settings_outlined,
                            color: AppColors.primary,
                            size: 24.sp,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Виджет геймификации
            if (profile != null)
              GamificationWidget(
                level: profile.level,
                xpPoints: profile.xpPoints,
                referralCode: profile.referralCode,
                progress: profile.levelProgress,
                xpToNextLevel: profile.xpToNextLevel,
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
                  _isLoadingMembership
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : _sectionCard(
                          icon: FontAwesomeIcons.ticket,
                          title: 'Текущий абонемент',
                          children: [
                            _infoRow('Тип', subscriptionType),
                            _infoRow('Срок действия', subscriptionExpiry),
                            _infoRow('Статус', subscriptionStatus),
                            _infoRow('Осталось дней', subscriptionDaysLeft),
                          ],
                        ),
                  SizedBox(height: 18.h),
                  _sectionCard(
                    icon: FontAwesomeIcons.wallet,
                    title: 'Баланс',
                    children: [
                      _infoRow('Доступно кредитов', '$credits'),
                      _infoRow('Всего начислено', '$totalCredits'),
                      SizedBox(height: 16.h),
                      // Кнопка для просмотра лицевых счетов
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DepositsPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.text,
                            side: BorderSide(
                              color: AppColors.textComplimentary.withOpacity(0.3),
                              width: 1.5,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon(
                            FontAwesomeIcons.wallet,
                            size: 16.sp,
                            color: AppColors.textComplimentary,
                          ),
                          label: Text(
                            'Мои лицевые счета',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w500,
                              color: AppColors.textComplimentary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  _sectionCard(
                    icon: FontAwesomeIcons.building,
                    title: 'Клуб',
                    children: [
                      _infoRow('Название', clubName)
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),
          ],
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
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 18.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.delaGothicOne(
                      fontSize: 16.sp,
                      color: AppColors.text,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textComplimentary,
                fontSize: 14.sp,
                fontFamily: 'Gilroy',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14.sp,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
