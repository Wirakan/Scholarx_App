import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/scholarship_detail_screen.dart';

void main() {
  runApp(const ScholarXApp());
}

class ScholarXApp extends StatelessWidget {
  const ScholarXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScholarX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF5722)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ScholarshipDetailScreen(),
    );
  }
}