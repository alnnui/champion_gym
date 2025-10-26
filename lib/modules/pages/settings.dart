import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:myapp/modules/components/animated_tap.dart';
import 'package:myapp/modules/pages/avatar_customization.dart';
import 'package:myapp/modules/pages/edit_profile.dart';
import 'package:myapp/modules/pages/notifications_settings.dart';
import 'package:myapp/modules/pages/security_settings.dart';
import 'package:myapp/modules/providers/UserProvider.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:myapp/modules/widgets/avatar/rive_avatar_widget.dart';

/// Settings screen, structure ported from the Bapcare mobile app and adapted
/// to Champion Fitness (dark theme, yellow accent, existing settings pages).
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _openAvatarCustomization() async {
    final current = context.read<UserProvider>().userProfile?.avatarConfig;
    await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => AvatarCustomizationScreen(initialConfig: current),
      ),
    );
    // The avatar is saved through UserProvider, so the watched profile already
    // reflects the change — nothing else to do here.
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

    if (confirmed == true && mounted) {
      try {
        await context.read<UserProvider>().logout();
        if (!mounted) return;
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/auth', (route) => false);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Не удалось выйти. Попробуйте снова.')),
          );
        }
      }
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts[0].characters.first + parts[1].characters.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProvider>().userProfile;
    final name = profile?.username ?? profile?.phone ?? 'Пользователь';
    final phone = profile?.phone ?? '';
    final avatarConfig = profile?.avatarConfig;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded,
              color: AppColors.text, size: 28.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Настройки',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 8.h, bottom: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Profile card ──
              _ProfileCard(
                name: name,
                phone: phone,
                avatarConfig: avatarConfig,
                initials: _initials(name),
                onEditProfile: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                ),
                onEditAvatar: _openAvatarCustomization,
              ),
              SizedBox(height: 28.h),

              // ── General ──
              _SectionLabel(title: 'Основное'),
              SizedBox(height: 8.h),
              _SettingsGroup(
                children: [
                  _SettingsRowNav(
                    iconColor: AppColors.primary,
                    icon: Icons.person_outline_rounded,
                    title: 'Редактировать профиль',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfilePage(),
                      ),
                    ),
                  ),
                  const _SettingsDivider(),
                  _SettingsRowNav(
                    iconColor: const Color(0xFF9C27B0),
                    icon: Icons.face_retouching_natural_rounded,
                    title: 'Аватар',
                    onTap: _openAvatarCustomization,
                  ),
                  const _SettingsDivider(),
                  _SettingsRowNav(
                    iconColor: const Color(0xFF5B8DEF),
                    icon: Icons.notifications_none_rounded,
                    title: 'Уведомления',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationsSettingsPage(),
                      ),
                    ),
                  ),
                  const _SettingsDivider(),
                  _SettingsRowNav(
                    iconColor: const Color(0xFF4CAF50),
                    icon: Icons.lock_outline_rounded,
                    title: 'Безопасность',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SecuritySettingsPage(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),

              // ── Account ──
              _SectionLabel(title: 'Аккаунт'),
              SizedBox(height: 8.h),
              _SettingsGroup(
                children: [
                  _SettingsRowNav(
                    iconColor: AppColors.error,
                    icon: Icons.logout_rounded,
                    title: 'Выйти из аккаунта',
                    titleColor: AppColors.error,
                    showChevron: false,
                    onTap: _logout,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Profile card ──────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final String name;
  final String phone;
  final Map<String, dynamic>? avatarConfig;
  final String initials;
  final VoidCallback onEditProfile;
  final VoidCallback onEditAvatar;

  const _ProfileCard({
    required this.name,
    required this.phone,
    required this.avatarConfig,
    required this.initials,
    required this.onEditProfile,
    required this.onEditAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundComplimentary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            AnimatedTap(
              onTap: onEditAvatar,
              child: Stack(
                children: [
                  UserAvatarWidget(
                    avatarConfig: avatarConfig,
                    size: 64.w,
                    backgroundColor: AppColors.primary,
                    initials: initials,
                    textColor: AppColors.textAlternative,
                    fontSize: 24.sp,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.backgroundComplimentary,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 12.sp,
                        color: AppColors.textAlternative,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (phone.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      phone,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 14.sp,
                        color: AppColors.textComplimentary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            AnimatedTap(
              onTap: onEditProfile,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Изменить',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section building blocks ───────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Text(
        title,
        style: GoogleFonts.delaGothicOne(
          fontSize: 14.sp,
          color: AppColors.textComplimentary,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundComplimentary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 64.w),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withOpacity(0.06),
      ),
    );
  }
}

class _SettingsRowNav extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? titleColor;
  final bool showChevron;
  final VoidCallback onTap;

  const _SettingsRowNav({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: titleColor ?? AppColors.text,
                ),
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textComplimentary,
                size: 22.sp,
              ),
          ],
        ),
      ),
    );
  }
}
