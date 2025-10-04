import 'package:flutter/material.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/components/animated_tap.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({Key? key}) : super(key: key);

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.text,
        title: Text(
          'Акции и предложения',
          style: GoogleFonts.delaGothicOne(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Главная акция
            _buildMainPromotion(),

            SizedBox(height: 24.h),

            // Выгодный абонемент
            _buildSpecialOffer(),

            SizedBox(height: 24.h),

            // Список других акций
            Text(
              'Другие предложения',
              style: GoogleFonts.delaGothicOne(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.text,
              ),
            ),

            SizedBox(height: 16.h),

            _buildPromotionCard(
              title: 'Скидка на персональные тренировки',
              description:
                  'Получите 20% скидку на первые 5 персональных тренировок',
              discount: '20%',
              validUntil: '31.12.2024',
              icon: Icons.fitness_center,
            ),

            SizedBox(height: 12.h),

            _buildPromotionCard(
              title: 'Бесплатный месяц SPA',
              description:
                  'При покупке годового абонемента получите месяц SPA в подарок',
              discount: 'Бесплатно',
              validUntil: '31.12.2024',
              icon: Icons.spa,
            ),

            SizedBox(height: 12.h),

            _buildPromotionCard(
              title: 'Семейная скидка',
              description: 'Скидка 15% для семейных абонементов от 2 человек',
              discount: '15%',
              validUntil: '31.12.2024',
              icon: Icons.family_restroom,
            ),

            SizedBox(height: 12.h),

            _buildPromotionCard(
              title: 'Студенческая скидка',
              description:
                  'Специальные цены для студентов при предъявлении студенческого билета',
              discount: '25%',
              validUntil: '31.12.2024',
              icon: Icons.school,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainPromotion() {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/images/hot_image.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ГЛАВНАЯ АКЦИЯ',
                style: TextStyle(
                  color: AppColors.textAlternative,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy',
                ),
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'Приведи друга и получи 25% скидку',
              style: GoogleFonts.delaGothicOne(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              'Ваш друг получит абонемент в подарок',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14.sp,
                fontFamily: 'Gilroy',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialOffer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'СУПЕР ПРЕДЛОЖЕНИЕ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
              Spacer(),
              Icon(Icons.star, color: Colors.white, size: 20.sp),
            ],
          ),

          SizedBox(height: 12.h),

          Text(
            'Годовой абонемент\nсо скидкой 40%',
            style: GoogleFonts.delaGothicOne(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.2,
            ),
          ),

          SizedBox(height: 8.h),

          Row(
            children: [
              Text(
                'Обычная цена: ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                  fontFamily: 'Gilroy',
                ),
              ),
              Text(
                '120,000 Т',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                  fontFamily: 'Gilroy',
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          Row(
            children: [
              Text(
                'Ваша цена: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Gilroy',
                ),
              ),
              Text(
                '72,000 Т',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy',
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOfferFeature(
                      Icons.access_time,
                      'Без ограничений по времени',
                    ),
                    SizedBox(height: 4.h),
                    _buildOfferFeature(Icons.fitness_center, 'Все зоны клуба'),
                    SizedBox(height: 4.h),
                    _buildOfferFeature(Icons.spa, 'SPA и сауна включены'),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              AnimatedTap(
                onTap: () => _showPurchaseDialog(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Купить',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfferFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 14.sp),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11.sp,
              fontFamily: 'Gilroy',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionCard({
    required String title,
    required String description,
    required String discount,
    required String validUntil,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.backgroundComplimentary, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24.sp),
          ),

          SizedBox(width: 16.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.delaGothicOne(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textComplimentary,
                    fontSize: 12.sp,
                    fontFamily: 'Gilroy',
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 8.h),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        discount,
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Text(
                      'До $validUntil',
                      style: TextStyle(
                        color: AppColors.textComplimentary,
                        fontSize: 10.sp,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Иконка
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    color: AppColors.primary,
                    size: 30.sp,
                  ),
                ),

                SizedBox(height: 16.h),

                // Заголовок
                Text(
                  'Покупка абонемента',
                  style: GoogleFonts.delaGothicOne(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                // Цена
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '72,000 ₸',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Описание
                Text(
                  'Годовой абонемент со скидкой 40%\nВключает все зоны клуба, SPA и сауну',
                  style: TextStyle(
                    color: AppColors.textComplimentary,
                    fontSize: 14.sp,
                    fontFamily: 'Gilroy',
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Кнопки
                Row(
                  children: [
                    Expanded(
                      child: AnimatedTap(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundComplimentary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Отмена',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AnimatedTap(
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Покупка успешно оформлена!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Купить',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textAlternative,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
