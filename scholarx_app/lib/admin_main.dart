import 'package:flutter/material.dart';
import 'admin/core/colors.dart';
import 'admin/screens/dashboard_screen.dart';
import 'admin/screens/admin_splash_screen.dart';

void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScholarX Admin',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: SXColor.background,
        colorScheme: ColorScheme.fromSeed(seedColor: SXColor.primary),
      ),
      home: const AdminSplashScreen(),
    );
  }
}