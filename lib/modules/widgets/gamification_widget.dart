import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class GamificationWidget extends StatelessWidget {
  final int level;
  final int xpPoints;
  final String? referralCode;
  final double progress;
  final int xpToNextLevel;

  const GamificationWidget({
    super.key,
    required this.level,
    required this.xpPoints,
    this.referralCode,
    required this.progress,
    required this.xpToNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundComplimentary,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Верхняя строка: Уровень и реферальный код
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Уровень
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$level',
                        style: GoogleFonts.delaGothicOne(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'УРОВЕНЬ',
                        style: TextStyle(
                          color: AppColors.textComplimentary,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '$xpPoints XP',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Реферальный код
              if (referralCode != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    referralCode!,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gilroy',
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Прогресс бар
          Column(
            children: [
              // Текст над прогресс-баром
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'До ${level + 1} уровня',
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  Text(
                    '$xpToNextLevel XP',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Прогресс бар
              Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(3.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 6.h,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
