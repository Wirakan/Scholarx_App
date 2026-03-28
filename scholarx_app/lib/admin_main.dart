import 'package:flutter/material.dart';
import 'coreApp/colors.dart';
import 'screens/dashboard_screen.dart';

void main() => runApp(const ScholarXApp());

class ScholarXApp extends StatelessWidget {
  const ScholarXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScholarX Admin',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: SXColor.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: SXColor.primary,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}