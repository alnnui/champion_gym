import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/modules/components/animated_button.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:myapp/modules/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Footbar extends StatefulWidget {
  final void Function(int screenIndex) changeScreen;
  final int currentScreen;
  const Footbar({
    super.key,
    required this.changeScreen,
    required this.currentScreen,
  });
  @override
  State<Footbar> createState() => _Footbar();
}

class _Footbar extends State<Footbar> {

  Future<void> _showBarcodeModal() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cardNumber = userProvider.userProfile?.card ?? '';
    final barcodeType = 'CODE39'; // TODO: get from club data
    final photo = userProvider.userProfile?.avatarUrl;    // Преобразуем тип штрихкода
    Barcode getBarcodeType(String type) {
      switch (type.toUpperCase()) {
        case 'CODE39':
          return Barcode.code39();
        case 'CODE128':
          return Barcode.code128();
        case 'EAN13':
          return Barcode.ean13();
        case 'EAN8':
          return Barcode.ean8();
        case 'UPCA':
          return Barcode.upcA();
        case 'UPCE':
          return Barcode.upcE();
        default:
          return Barcode.code39();
      }
    }

    // Проверяем наличие фото в профиле
    if (photo == null || photo.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 32.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Фото профиля не найдено',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gilroy',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Для доступа к штрихкоду необходимо добавить фото в профиль. Это нужно для подтверждения вашей личности при входе в клуб.',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'Gilroy',
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Понятно',
                style: TextStyle(
                  color: const Color(0xFFFFD700),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // TODO: Здесь будет реализовано распознавание лица
    // Нужно будет:
    // 1. Открыть камеру
    // 2. Сделать фото пользователя
    // 3. Отправить на сервер для сравнения с фото в профиле
    // 4. Если лица совпадают - показать штрихкод
    // 5. Если не совпадают - показать ошибку
    
    // Временно показываем штрихкод без проверки
    // После реализации распознавания лиц, этот код нужно будет убрать
    
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.6,
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Проверка личности пройдена - показываем галочку
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 36.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Ваш штрихкод',
                style: TextStyle(
                  color: AppColors.text,
                  fontFamily: 'Gilroy',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.h),

              // Отображаем реальный штрихкод пользователя
              if (cardNumber.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 24.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Реальный штрихкод
                      BarcodeWidget(
                        barcode: getBarcodeType(barcodeType),
                        data: cardNumber,
                        width: 250.w,
                        height: 80.h,
                        drawText: true,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundComplimentary,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    'Номер карты не найден',
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontFamily: 'Gilroy',
                      fontSize: 14.sp,
                    ),
                  ),
                ),

              SizedBox(height: 24.h),
              Text(
                'Покажите этот штрихкод на входе в клуб для быстрого прохода',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textComplimentary,
                  fontFamily: 'Gilroy',
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorFilter? getColorFilter(int index) {
      return widget.currentScreen == index
          ? const ColorFilter.mode(Colors.yellow, BlendMode.srcIn)
          : null;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Center(
            child: AnimatedButton(
              width: 56,
              height: 56,
              backgroundColor: Colors.black.withAlpha(0),
              onPressed: () {
                widget.changeScreen(0);
              },
              borderRadius: 12,
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/icons/home.svg',
                  width: 20,
                  height: 20,
                  colorFilter: getColorFilter(0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedButton(
              width: 56,
              height: 56,
              backgroundColor: Colors.black.withAlpha(0),
              onPressed: () {
                widget.changeScreen(1);
              },
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              borderRadius: 12,
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/icons/statistic.svg',
                  width: 20,
                  height: 20,
                  colorFilter: getColorFilter(1),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedButton(
              width: 48,
              height: 48,
              backgroundColor: AppColors.primary,
              onPressed: () async {
                await _showBarcodeModal();
              },
              borderRadius: 12,
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/icons/card.svg',
                  width: 20,
                  height: 20,
                  colorFilter: getColorFilter(
                    4,
                  ), // не подсвечивается, если нужно - поменяйте индекс
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedButton(
              width: 56,
              height: 56,
              backgroundColor: Colors.black.withAlpha(0),
              onPressed: () {
                widget.changeScreen(2);
              },
              // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              borderRadius: 12,
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/icons/workout.svg',
                  width: 24,
                  height: 24,
                  colorFilter: getColorFilter(2),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedButton(
              width: 56,
              height: 56,
              backgroundColor: Colors.black.withAlpha(0),
              onPressed: () {
                widget.changeScreen(3);
              },
              // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              borderRadius: 12,
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/icons/profile.svg',
                  width: 28,
                  height: 28,
                  colorFilter: getColorFilter(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
