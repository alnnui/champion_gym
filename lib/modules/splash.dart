import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/main.dart';
import 'package:myapp/modules/api/services/auth_service.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:myapp/modules/providers/UserProvider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(dio);
    _initAnimation();
    _navigateToHome();
  }

  void _initAnimation() {
    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _scaleController.forward();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (!mounted) return;

    // Проверяем наличие JWT токена
    final bool isAuthenticated = await _authService.isAuthenticated();

    // Если токена нет — направляем на экран авторизации
    if (!isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/auth');
      return;
    }

    // Если токен есть — пытаемся получить данные пользователя
    final userProvider = UserProvider(dio);
    try {
      await userProvider.fetchUser();
      
      if (!mounted) return;
      
      // Успешно получили данные — идём на главный экран
      Navigator.of(context).pushReplacementNamed('/main');
    } catch (e) {
      // Если не удалось получить профиль (токен невалиден) — на авторизацию
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Жёлтый фон
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Логотип с анимацией
            ScaleTransition(
              scale: _scaleAnimation,
              child: SvgPicture.asset(
                'lib/assets/images/champion_yellow.svg',
                width: 130.w,
                height: 130.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
