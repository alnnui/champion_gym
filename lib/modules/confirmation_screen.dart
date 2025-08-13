import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_v1/modules/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_v1/modules/components/animated_button.dart';
import 'package:project_v1/modules/second_login.dart';
import 'package:project_v1/modules/theme/colors.dart';
final storage = FlutterSecureStorage();

Future<Map<String, dynamic>> confirmSmsCode(String code, String phone) async {
  final backendUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000';

  try {
    final response = await http.post(
      Uri.parse('$backendUrl/auth/phone/authorize'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'code': code})
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      String accessToken = body['access_token'];
      String refreshToken = body['refresh_token'];
      // Загружаем в сторедж флаттера токены авторизации
      final accessTokenExpiresAt = DateTime.now().add(Duration(hours: 24)).toIso8601String();
      final refreshTokenExpiresAt = DateTime.now().add(Duration(days: 31)).toIso8601String();
      await storage.write(key: 'access_token', value: accessToken);
      await storage.write(key: 'access_token_expires_at', value: accessTokenExpiresAt);
      await storage.write(key: 'refresh_token', value: refreshToken);
      await storage.write(key: 'access_token_expires_at', value: refreshTokenExpiresAt);
      return {
        "status": "success",
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
    }
    else {
      return {
        'status' : 'error',
        'errorMessage' : '${body['detail']}'
      };
    }
  } catch (e) {
    return {
      'status': 'error',
      'errorMessage' : 'Ошибка запроса: $e'
    };
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
  final List<TextEditingController> fieldsControllers =
      List.generate(4, (_) => TextEditingController());
  void updateCodeController() {
    codeController.text = fieldsControllers.map((c) => c.text).join();
  }
  @override
  void dispose() {
    codeController.dispose();
    for (var c in fieldsControllers) {
      c.dispose();
    }
    super.dispose();
  }
  String statusMessage = '';
  bool loading = false; // состояние загрузки
  bool isSuccess = false; // состояние ошибки
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
                
                child: Form( // Смс код инпут филд
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (i) => SizedBox(
                        width: 68,
                        height: 64,
                        child: TextFormField(
                          controller: fieldsControllers[i],
                          onChanged: (value) {
                            updateCodeController();
                            if (value.isNotEmpty && i < 3) {
                              // При вводе → следующий
                              FocusScope.of(context).nextFocus();
                            } else if (value.isEmpty && i > 0) {
                              // При удалении → предыдущий
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w800,
                            fontSize: 32,
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(1)],
                        )
                      ),
                  ),
                  )
                )
              ),

              const SizedBox(height: 24),
              // Кнопка подтвердить код
              SizedBox(
                width: fieldWidth,
                height: buttonHeight,
                child: AnimatedButton(
                  backgroundColor: Colors.white,
                  width: fieldWidth,
                  height: buttonHeight,
                  shadow: true,
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    Map<String, dynamic> response = await confirmSmsCode(codeController.text, widget.phone);
                    if (!mounted) return; // <-- защита от устаревшего контекста
                    if (response['status'] == 'error') {
                      setState(() {
                        statusMessage = response['errorMessage'];
                      });
                    } else {
                      setState(() {
                        isSuccess = true;
                        statusMessage = '';
                      });
                    }
                    setState(() {
                      loading = false;
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
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
              Center( // Отображение состояния запроса
                child: Text(
                  statusMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:  isSuccess ? AppColors.success: AppColors.error,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  )
                )
              ),
              SizedBox(
                width: fieldWidth,
                height: buttonHeight,
                child: AnimatedButton(
                  backgroundColor: Colors.black.withAlpha(0),
                  shadow: false,
                  width: fieldWidth,
                  height: buttonHeight,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NumberScreen(),
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
