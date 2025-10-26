import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/main.dart';
import 'package:myapp/modules/api/services/auth_service.dart';
import 'package:myapp/modules/components/animated_button.dart';
import 'package:myapp/modules/theme/colors.dart';

class ConfirmationScreen extends StatefulWidget {
  final String phone;
  const ConfirmationScreen({super.key, required this.phone});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  late final AuthService _authService;
  late final List<FocusNode> focusNodes;
  late final List<String> prevValues;
  final codeController = TextEditingController();
  final List<TextEditingController> fieldsControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  void updateCodeController() {
    codeController.text = fieldsControllers.map((c) => c.text).join();
  }

  @override
  void initState() {
    super.initState();
    _authService = AuthService(dio);

    // Инициализация focusNodes и prevValues для 6 полей
    focusNodes = List.generate(6, (_) => FocusNode());
    prevValues = List.generate(6, (_) => '');
  }

  @override
  void dispose() {
    codeController.dispose();
    for (var c in fieldsControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _distributePasted(String pasted, int startIndex) {
    // Разложить вставленный текст по полям, начиная с startIndex
    for (
      int j = 0;
      j < pasted.length && (startIndex + j) < fieldsControllers.length;
      j++
    ) {
      fieldsControllers[startIndex + j].text = pasted[j];
      prevValues[startIndex + j] = pasted[j];
    }
    // Обновить общий контроллер
    updateCodeController();
    // Ставим фокус на следующую пустую (или снимаем фокус)
    int next = startIndex + pasted.length;
    if (next < focusNodes.length) {
      focusNodes[next].requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> confirmSms() async {
    // Проверяем, что код введен полностью (6 цифр)
    if (codeController.text.length != 6) {
      setState(() {
        statusMessage = 'Пожалуйста, введите код из 6 цифр';
        isSuccess = false;
      });
      return;
    }

    // Проверяем, что код состоит только из цифр
    if (!RegExp(r'^\d{6}$').hasMatch(codeController.text)) {
      setState(() {
        statusMessage = 'Код должен содержать только цифры';
        isSuccess = false;
      });
      return;
    }

    setState(() {
      loading = true;
      statusMessage = '';
    });

    try {
      // НОВЫЙ API: передаем телефон и код
      Map<String, dynamic> response = await _authService.confirmPasswordFromSms(
        widget.phone,
        codeController.text,
      );

      if (!mounted) return;

      // Проверяем статус ответа
      if (response['status'] == 'success') {
        setState(() {
          isSuccess = true;
          statusMessage = 'Успешно!';
          loading = false;
        });

        // Небольшая задержка для отображения успеха
        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;

        // Переход на главную страницу без возможности вернуться в auth-стек
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/main', (route) => false);
      } else {
        // Ошибка подтверждения кода
        setState(() {
          statusMessage = response['errorMsg'] ?? 'Неверный код подтверждения';
          isSuccess = false;
          loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        statusMessage = 'Ошибка: ${e.toString()}';
        isSuccess = false;
        loading = false;
      });
    }
  }

  Future<void> resendSms() async {
    if (loading) return;

    setState(() {
      loading = true;
      statusMessage = '';
    });

    try {
      final result = await _authService.requestSms(widget.phone);

      if (!mounted) return;

      if (result["status"] == 'success' || result["result"] == 'success') {
        setState(() {
          isSuccess = true;
          statusMessage = 'Код отправлен повторно';
        });
      } else {
        String errorMessage = 'Не удалось отправить код повторно';

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

        setState(() {
          isSuccess = false;
          statusMessage = errorMessage;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSuccess = false;
        statusMessage = 'Ошибка: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  String statusMessage = '';
  bool loading = false; // состояние загрузки
  bool isSuccess = false; // состояние ошибки
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5DA34),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).viewInsets.bottom,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  Text(
                    'Подтвердить через код',
                    style: GoogleFonts.delaGothicOne(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Text(
                    'На номер ${widget.phone}\nбыл отправлен код',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  SizedBox(
                    width: 340.w,
                    child: Form(
                      // Смс код инпут филд - 6 полей
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (i) {
                          return SizedBox(
                            width: 50.w,
                            height: 64.h,
                            child: RawKeyboardListener(
                              focusNode: FocusNode(),
                              onKey: (RawKeyEvent event) {
                                // Обработка нажатия Backspace когда поле пустое
                                if (event is RawKeyDownEvent &&
                                    event.logicalKey ==
                                        LogicalKeyboardKey.backspace) {
                                  if (fieldsControllers[i].text.isEmpty &&
                                      i > 0) {
                                    // Переходим на предыдущее поле и очищаем его
                                    focusNodes[i - 1].requestFocus();
                                    fieldsControllers[i - 1].clear();
                                    prevValues[i - 1] = '';
                                    updateCodeController();
                                  }
                                }
                              },
                              child: TextFormField(
                                focusNode: focusNodes[i],
                                controller: fieldsControllers[i],
                                onChanged: (value) {
                                  // Если вставили сразу больше одного символа (paste)
                                  if (value.length > 1) {
                                    // Распределяем вставку начиная с этого индекса
                                    _distributePasted(value, i);
                                    return;
                                  }

                                  final prev = prevValues[i];
                                  // Ввод символа (prev.length < value.length)
                                  if (value.length > prev.length) {
                                    prevValues[i] = value;
                                    updateCodeController();
                                    // Переход к следующему если есть
                                    if (value.isNotEmpty &&
                                        i < focusNodes.length - 1) {
                                      focusNodes[i + 1].requestFocus();
                                    } else {
                                      FocusScope.of(context).unfocus();
                                    }
                                  }
                                  // Удаление символа (prev.length > value.length)
                                  else if (value.length < prev.length) {
                                    prevValues[i] = value;
                                    updateCodeController();
                                    if (value.isEmpty && i > 0) {
                                      // Перейти в предыдущее поле и очистить его (UX как в большинстве приложений)
                                      focusNodes[i - 1].requestFocus();
                                    }
                                  }
                                  // Нулевой случай (равны) — просто обновляем
                                  else {
                                    prevValues[i] = value;
                                    updateCodeController();
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 28.sp,
                                ),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  SizedBox(height: 28.h),
                  // Кнопка подтвердить код
                  AnimatedButton(
                    backgroundColor: Colors.white,
                    width: 320.w,
                    height: 56.h,
                    shadow: true,
                    onPressed: confirmSms,
                    child: loading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.yellow,
                              ),
                              strokeWidth: 4.0,
                            ),
                          )
                        : Text(
                            'Далее',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Gilroy',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    // Отображение состояния запроса
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        statusMessage,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSuccess
                              ? AppColors.success
                              : AppColors.error,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: 320.w,
                    height: 44.h,
                    child: AnimatedButton(
                      backgroundColor: Colors.black.withAlpha(0),
                      shadow: false,
                      width: 320.w,
                      height: 44.h,
                      onPressed: resendSms,
                      child: Text(
                        'Отправить заново',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Color(0xFF383838),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
