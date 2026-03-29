import 'package:flutter/material.dart';
import '/screens/splash_screen.dart';
import '/screens/login_screen.dart';
import '/student/screens/home/student_home_screen.dart';
import '/student/screens/notification/notification_screen.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String studentLogin = '/student/login';
  static const String studentHome = '/student/home';
  static const String studentNotification = '/student/notification';
  static const String staffLogin = '/staff/login';
  static const String staffDashboard = '/staff/dashboard';

  static Map<String, WidgetBuilder> get routes => {
    splashScreen: (_) => const SplashScreen(),
    studentLogin: (_) => const LoginScreen(),
    studentHome: (_) => const StudentHomeScreen(),
    studentNotification: (_) => const NotificationScreen(),
  };
}