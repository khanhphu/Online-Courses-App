import 'package:flutter/material.dart';
import 'package:online_courses/pages/splashscreen.dart';
import 'package:online_courses/theme/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iStudy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
      
    );
  }
}
