import 'package:flutter/material.dart';
import 'package:scholarx/features/auth/screens/select_role_screen.dart';
import 'package:scholarx/features/student/screens/login/student_login_screen.dart';
import 'package:scholarx/features/student/screens/home/student_home_screen.dart';


class AppRoutes {
  static const String selectRole = '/';
  static const String studentLogin = '/student/login';
  static const String studentHome = '/student/home';
  static const String staffLogin = '/staff/login';
  static const String staffDashboard = '/staff/dashboard';

  static Map<String, WidgetBuilder> get routes => {
    selectRole: (_) => const SelectRoleScreen(),
    studentLogin: (_) => const StudentLoginScreen(),
    studentHome: (_) => const StudentHomeScreen(),
  };
}
