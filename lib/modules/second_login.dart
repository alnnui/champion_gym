import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:project_v1/modules/confirmation_screen.dart';
import 'package:project_v1/modules/login.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final phoneFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fieldWidth = screenWidth * 0.75;
    final titleFontSize = screenWidth * 0.05;

    final titleStyle = GoogleFonts.delaGothicOne(
      fontSize: titleFontSize,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    const buttonHeight = 43.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5DA34),
      body: Center(
        child: Align(alignment: Alignment.topCenter, child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: screenHeight * 0.3),
            Text('Введите ваш номер телефона', style: titleStyle),
            const SizedBox(height: 24),
            SizedBox(
              width: fieldWidth,
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [phoneFormatter],
                decoration: const InputDecoration(
                  labelText: 'Номер телефона',
                  hintText: '+7 (___) ___-__-__',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: fieldWidth,
              height: buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfirmationScreen(),
                    ));
                },
                child: const Text(
                  'Далее',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: fieldWidth,
              height: buttonHeight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                  );
                },
                child: const Text(
                  '<-   Назад',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF383838),
                  ),
                ),
              ),
            ),
          ],
        ),)
      ),
    );
  }
}
