import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:project_v1/modules/confirmation_screen.dart';
import 'package:project_v1/modules/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_v1/modules/components/animated_button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_v1/modules/theme/colors.dart';
// функция отправки смс кода
Future<Map<String, dynamic>> requestSms(String phoneNumber) async {
  final backendUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000';
  // 1. Форматируем номер телефона
  String rawPhone = phoneNumber.replaceAll(RegExp(r'\D'), ''); // только цифры
  // 1.1 Выводим ошибку если длина введеного телефона меньше 10 
  if (rawPhone.length < 10) {
    return {
      "status": "error",
      "errorMessage" : 'Введите корректный номер (10 цифр)'
    };
  }
  String last10 = rawPhone.substring(rawPhone.length - 10); // последние 10 цифр
  String formattedPhone = '+7$last10'; // +7 и 10 цифр
  // 2. Делаем запрос к бэку, localhost:8000 !! Заменить и вывести в env
  try {
    final response = await http.post(
      Uri.parse('$backendUrl/auth/phone/request-sms'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': formattedPhone}),
    );
    if (response.statusCode == 200) {
      return { 
        "status": "success",
        "phone" : formattedPhone ,
      };
    } else {
      final body = jsonDecode(response.body);
      return {
        "status" : "error",
        "errorMessage" : body['detail'] ?? 'Ошибка: ${response.statusCode}'
      };
    }
  } catch (e) {
    return {
      "status" : "error",
      "errorMessage" : 'Ошибка запроса: $e'
    };
  }
}

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
  String statusMessage = ''; // сообщение для пользователей
  bool loading = false; // состояние загрузки
  bool isSuccess = false; // состояние ошибки
  @override
  void initState() {
    super.initState();
    phoneController.text = '+7 (';
    phoneController.addListener(() {
      if (phoneController.text.length < 4 || !phoneController.text.startsWith('+7 (')) {
        phoneController.text = '+7 (';
        phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneController.text.length),
        );
      }
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

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
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Номер телефона',
                labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                ),
                border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                ),
              ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: fieldWidth,
              height: buttonHeight,
              child: AnimatedButton(
                backgroundColor: Colors.white,
                shadow: true,
                width: fieldWidth,
                height: buttonHeight,
                onPressed: () async {
                  // Логика отправки номера телефона
                  // 1. Начинаем загрузку
                  setState(() {
                    loading = true;
                  });
                  // 2. Запрашиваем СМС - код
                  Map<String, dynamic> result = await requestSms(phoneController.text);
                  // 3. Отображаем ответ с сервера
                  setState(() {
                    statusMessage = result["status"] == 'success' ? 
                      'СМС код на номер ${result['phone']} был отправлен' : result['errorMessage'];
                  });
                  if (result["status"] == 'success') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmationScreen(phone : result['phone']),
                      ));
                      setState(() {
                        isSuccess = true;
                      });
                  }
                  setState(() {
                    loading = false;
                  });
                },
                child: loading ?
                  SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                      strokeWidth: 4.0,
                    ),
                  )
                  :
                  const Text(
                    'Далее',
                    style: TextStyle(color: Colors.black),
                  ),
              ),
            ),
            const SizedBox(height: 16),
            Center( // Отображение статуса запроса
              child: Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:  isSuccess ? AppColors.success : AppColors.error, // проверка на ошибку
                  fontSize: 14,
                  fontWeight: FontWeight.w600
                )
              )
            ),
            SizedBox(
              width: fieldWidth,
              height: buttonHeight,
              child: AnimatedButton(
                width: fieldWidth,
                height: buttonHeight,
                backgroundColor: Colors.black.withAlpha(0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                  );
                },
                child: const Text(
                  '←  Назад',
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
