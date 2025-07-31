import 'package:flutter/material.dart';
import 'package:online_courses/models/courses.dart';
import 'package:online_courses/screens/courses_screen.dart';
import 'package:online_courses/screens/course_detail_screen.dart';
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
      //  home: const SplashScreen(),
      //test ui- home_screen
      home: const CoursesScreen(),
      //test course_detail_screen
      //  home: CourseDetailScreen(),
    );
  }
}
