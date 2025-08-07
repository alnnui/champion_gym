import 'package:flutter/material.dart';
import 'modules/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Champion Project',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}



