import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_v1/modules/layout.dart';
import 'modules/home_screen.dart';
import 'modules/login.dart';
import 'package:http/http.dart';
Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Champion Project',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: Layout(),
    );
  }
}



