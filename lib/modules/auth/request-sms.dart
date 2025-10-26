import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myapp/main.dart';
import 'package:myapp/modules/api/services/auth_service.dart';
import 'package:myapp/modules/auth/confirmation_screen.dart';
import 'package:myapp/modules/components/animated_button.dart';
import 'package:myapp/modules/layout.dart';

class RequestSmsPage extends StatefulWidget {
  const RequestSmsPage({super.key});

  @override
  State<RequestSmsPage> createState() => _RequestSmsPageState();
}

class _RequestSmsPageState extends State<RequestSmsPage> {
  late final AuthService _authService;

  final phoneFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final phoneController = TextEditingController();
  bool loading = false; // состояние загрузки

  @override
  void initState() {
    super.initState();
    _authService = AuthService(dio);
  }

  // Метод для показа модального окна с ошибкой
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Красный крест
                Icon(Icons.cancel, color: Colors.red, size: 64.sp),
                SizedBox(height: 16.h),
                Text(
                  'Ошибка',
                  style: GoogleFonts.delaGothicOne(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: AnimatedButton(
                    backgroundColor: const Color(0xFFF5DA34),
                    shadow: false,
                    width: double.infinity,
                    height: 43.h,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ВРЕМЕННЫЙ метод для быстрого входа с тестовым токеном
  Future<void> _testLogin() async {
    setState(() {
      loading = true;
    });

    try {
      // Получаем JWT токен от бэкенда по CRM токену
      final response = await dio.post('/auth/dev/token-from-crm');

      if (response.statusCode == 200) {
        final accessToken = response.data['access_token'];
        final refreshToken = response.data['refresh_token'];

        // Сохраняем JWT токены
        await _authService.saveTokens(accessToken, refreshToken);

        if (!mounted) return;

        // Переходим на главный экран
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Layout()),
        );
      } else {
        if (!mounted) return;
        _showErrorDialog('Ошибка получения токена: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('Ошибка тестового входа: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> _requestSms() async {
    if (loading) return;

    final unmaskedPhone = phoneFormatter.getUnmaskedText();
    if (unmaskedPhone.length != 10) {
      _showErrorDialog('Пожалуйста, введите корректный номер телефона');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final result = await _authService.requestSms(phoneController.text);

      if (!mounted) return;

      if (result["status"] == 'success' || result["result"] == 'success') {
        await Future.delayed(const Duration(milliseconds: 100));

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConfirmationScreen(phone: phoneController.text),
          ),
        );
      } else {
        String errorMessage = 'Произошла ошибка';

        if (result['errors'] != null &&
            result['errors'] is List &&
            (result['errors'] as List).isNotEmpty) {
          errorMessage = (result['errors'] as List).join('\n');
        } else if (result['details'] != null &&
            result['details'] is List &&
            (result['details'] as List).isNotEmpty) {
          errorMessage = (result['details'] as List).join('\n');
        } else if (result['errorMsg'] != null &&
            result['errorMsg'].toString().isNotEmpty) {
          errorMessage = result['errorMsg'].toString();
        } else if (result['message'] != null &&
            result['message'].toString().isNotEmpty) {
          errorMessage = result['message'].toString();
        }

        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      if (!mounted) return;

      _showErrorDialog('Ошибка подключения: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5DA34),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
            final isKeyboardVisible = keyboardInset > 0;

            return AnimatedPadding(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: SizedBox(
                height: (constraints.maxHeight - keyboardInset).clamp(
                  0.0,
                  constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      if (!isKeyboardVisible) ...[
                        Image.asset(
                          'lib/assets/images/champion_black.png',
                          width: 210.w,
                          height: 112.h,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.fitness_center,
                              size: 96.sp,
                              color: Colors.black,
                            );
                          },
                        ),
                        SizedBox(height: 34.h),
                      ],
                      Text(
                        'Введите ваш номер телефона',
                        style: GoogleFonts.delaGothicOne(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Мы отправим SMS с кодом подтверждения',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF2F2F2F),
                          fontFamily: 'Gilroy',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: 320.w,
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [phoneFormatter],
                          cursorColor: Colors.black,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Gilroy',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: '+7 (___) ___-__-__',
                            labelText: 'Номер телефона',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ),
                            labelStyle: TextStyle(
                              color: const Color(0xFF4A4A4A),
                              fontFamily: 'Gilroy',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black.withAlpha(90),
                              fontFamily: 'Gilroy',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.r),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      AnimatedButton(
                        backgroundColor: Colors.black,
                        shadow: true,
                        width: 320.w,
                        height: 56.h,
                        onPressed: _requestSms,
                        child: loading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                'Далее',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Gilroy',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                      SizedBox(height: 12.h),
                      AnimatedButton(
                        backgroundColor: const Color(0xFF47B455),
                        shadow: true,
                        width: 320.w,
                        height: 52.h,
                        borderRadius: 18.r,
                        onPressed: () {
                          if (!loading) _testLogin();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.science_outlined,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Тестовый вход',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),
                      AnimatedButton(
                        width: 320.w,
                        height: 44.h,
                        backgroundColor: Colors.black.withAlpha(0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Назад',
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
