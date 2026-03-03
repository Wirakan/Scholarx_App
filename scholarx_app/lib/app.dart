import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'features/student/screens/apply_scholarship/apply_scholarship_flow.dart';

class ScholarshipApp extends StatelessWidget {
  const ScholarshipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'สมัครขอทุนการศึกษา',
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
      home: const ApplyScholarshipFlow(),
    );
  }
}
