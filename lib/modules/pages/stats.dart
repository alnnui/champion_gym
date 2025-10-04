import 'package:flutter/material.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  String selectedPeriod = 'Неделя';
  final List<String> periods = ['Неделя', 'Месяц', 'Год'];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        height: screenHeight,
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Text(
              'Статистика',
              style: GoogleFonts.delaGothicOne(
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.text,
              ),
            ),

            SizedBox(height: 16.h),

            SizedBox(height: 24.h),

            // Основные метрики посещаемости
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: _VisitStatCard(
                      title: "Посещений за ${selectedPeriod.toLowerCase()}",
                      value: _getVisitsCount(),
                      icon: Icons.fitness_center,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _VisitStatCard(
                      title: "Средняя продолжительность",
                      value: "1ч 25м",
                      icon: Icons.timer,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Лучшее время посещения
            Expanded(flex: 1, child: _BestTimeCard()),

            SizedBox(height: 16.h),

            // Реферальный xP (сохраняем как было)
          ],
        ),
      ),
    );
  }

  String _getVisitsCount() {
    switch (selectedPeriod) {
      case 'Неделя':
        return '12';
      case 'Месяц':
        return '48';
      case 'Год':
        return '156';
      default:
        return '12';
    }
  }
}

class _VisitStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _VisitStatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gilroy',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
            ),
          ),
        ],
      ),
    );
  }
}

class _BestTimeCard extends StatelessWidget {
  const _BestTimeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: AppColors.primary, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Лучшее время посещения",
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gilroy',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Чаще всего вы тренируетесь в 19:00",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
