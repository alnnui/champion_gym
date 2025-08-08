import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:project_v1/modules/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<String> confirmSmsCode(String code, String phone) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:8000/auth/phone/authorize'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'code': code})
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      String token = body['access_token'];
      await storage.write(key: 'access_token', value: token);
      return token;
    }
    else {
      return 'Ошибка: ${body['detail']}';
    }
  } catch (e) {
    return 'Ошибка запроса: $e';
  }
}
class ConfirmationScreen extends StatefulWidget {
  final String phone;
  const ConfirmationScreen({super.key, required this.phone});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final codeController = TextEditingController();
  String statusMessage = '';
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fieldWidth = screenWidth * 0.75;
    final titleFontSize = screenWidth * 0.05;
    final subtitleFontSize = screenWidth * 0.045;

    final titleStyle = GoogleFonts.delaGothicOne(
      fontSize: titleFontSize,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    const buttonHeight = 43.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5DA34),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: screenHeight * 0.3),
              Text('Подтвердить через код', style: titleStyle),
              const SizedBox(height: 24),

              Text(
                'На номер ${widget.phone}\nбыл отправлен код',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: screenWidth * 0.8,
                
                child: TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: false,
                  obscuringCharacter: '•', // или '●' или '|'
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                    letterSpacing: screenWidth * 0.15,
                  ),
                  enableInteractiveSelection: false,

                  decoration: InputDecoration(
                    counterText: '', 
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              // Кнопка подтвердить код
              SizedBox(
                width: fieldWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    String response = await confirmSmsCode(codeController.text, widget.phone);
                    if (response.startsWith('Ошибка')) {
                      setState(() {
                        statusMessage = response;
                      });
                    } else {
                      setState(() {
                        statusMessage = 'Удачи с занятиями :)';
                      });
                    }
                  },
                  child: const Text(
                    'Подтвердить',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  statusMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: statusMessage.startsWith('Ошибка') ? Colors.red.shade400 : Colors.green.shade500,
                    fontSize: 16
                  )
                )
              ),
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
                    'Отправить заново',
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
          ),
        ),
      ),
    );
  }
}
