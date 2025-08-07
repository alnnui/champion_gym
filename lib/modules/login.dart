import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'second_login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageWidth = screenWidth * 0.75;
    final titleFontSize = screenWidth * 0.0625;
    final subtitleFontSize = screenWidth * 0.045;

    return Scaffold(
      backgroundColor: const Color(0xFFF5DA34),

      body: Center(
        child:Align(alignment: Alignment.topCenter,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: screenHeight * 0.2),
            Image.asset(
              'lib/assets/images/champion_black.png',
              width: imageWidth,
              height: 150,
            ),
            const SizedBox(height: 40),
            Text(
              'Добро пожаловать!',
              style: GoogleFonts.delaGothicOne(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Залы комфорта и бизнес класса по доступным ценам',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                fontSize: subtitleFontSize,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: imageWidth,
              height: 43,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NumberScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Начать',
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ],
        ),) 

      ),
    );
  }
}

