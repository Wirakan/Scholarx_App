import 'package:flutter/material.dart';
import '../features/student/screens/apply_scholarship/apply_scholarship_flow.dart';

class AppRoutes {
  AppRoutes._();

  static const String applyScholarship = '/apply-scholarship';

  static Map<String, WidgetBuilder> get routes => {
    applyScholarship: (_) => const ApplyScholarshipFlow(),
  };
}
