import 'package:flutter/material.dart';
import '/screens/splash_screen.dart';
import '/screens/welcome_screen.dart';
import '/screens/login_screen.dart';
import '/student/screens/home/student_home_screen.dart';
import '/admin/screens/admin_splash_screen.dart';
import '/admin/screens/admin_login_screen.dart';
import '/admin/screens/dashboard_screen.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String welcome = '/welcome';
  static const String studentLogin = '/student/login';
  static const String studentHome = '/student/home';
  static const String adminSplash = '/admin/splash';
  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin/dashboard';

  static Map<String, WidgetBuilder> get routes => {
    splashScreen: (_) => const SplashScreen(),
    welcome: (_) => const WelcomeScreen(),
    studentLogin: (_) => const LoginScreen(),
    studentHome: (_) => const StudentHomeScreen(),
    adminSplash: (_) => const AdminSplashScreen(),
    adminLogin: (_) => const AdminLoginScreen(),
    adminDashboard: (_) => const DashboardScreen(),
  };
}
