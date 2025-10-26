import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/modules/auth/welcoming.dart';
import 'package:myapp/modules/layout.dart';
import 'package:myapp/modules/providers/UserProvider.dart';
import 'package:myapp/modules/splash.dart' as splash_screen;
import 'package:dio/dio.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:myapp/modules/api/interceptors/auth_interceptor.dart';

late final Dio dio;

Future main() async {
  await dotenv.load(fileName: '.env');
  dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
    },
  ));
  
  // Добавляем JWT интерцептор
  dio.interceptors.add(AuthInterceptor(dio));
  
  // Debug interceptor (можно убрать в проде)
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      print('REQUEST[${options.method}] => PATH: ${options.path}');
      print('Headers: ${options.headers}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      return handler.next(response);
    },
    onError: (err, handler) {
      print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      return handler.next(err);
    },
  ));
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(dio),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(404, 1010),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Champion Fitness',
            theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: Colors.black,
                selectionColor: AppColors.primary.withOpacity(0.25),
                selectionHandleColor: AppColors.primary
              ),
              primarySwatch: Colors.yellow,
              useMaterial3: true,
              fontFamily: 'Gilroy',
            ),
            home: const splash_screen.SplashScreen(),
            routes: {
              '/main': (context) => Layout(),
              '/auth': (context) => WelcomingPage(),
            },
          );
        },
      ),
    );
  }
}
