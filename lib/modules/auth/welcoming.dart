import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/modules/auth/request-sms.dart';
import 'package:myapp/modules/components/animated_button.dart';

class WelcomingPage extends StatefulWidget {
  const WelcomingPage({super.key});

  @override
  State<WelcomingPage> createState() => _WelcomingPage();
}

class _WelcomingPage extends State<WelcomingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5DA34),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Image.asset(
                  'lib/assets/images/champion_black.png',
                  width: 280.w,
                  height: 150.h,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.fitness_center,
                      size: 150.sp,
                      color: Colors.black,
                    );
                  },
                ),
                SizedBox(height: 40.h),
                Text(
                  'Добро пожаловать!',
                  style: GoogleFonts.delaGothicOne(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Залы комфорта и бизнес класса по доступным ценам',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                AnimatedButton(
                  width: 320.w,
                  height: 56.h,
                  backgroundColor: Colors.white,
                  shadow: true,
                  onPressed: () {
                    // Сразу переходим на ввод телефона
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestSmsPage()),
                    );
                  },
                  child: Text(
                    'Начать',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Gilroy',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
