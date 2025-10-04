import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/modules/layout.dart';
import 'package:http/http.dart';
import 'package:myapp/modules/login.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
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
    return ScreenUtilInit(
      designSize: const Size(404, 1010),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Champion Project',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            fontFamily: 'Gilroy',
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
