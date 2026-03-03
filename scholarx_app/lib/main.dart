// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:scholarx/coreApp/themeApp/app_theme.dart';
// import 'package:scholarx/features/student_routes.dart';
// import 'screens/splash_screen.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   runApp(const ScholarXApp());
// }

// class ScholarXApp extends StatelessWidget {
//   const ScholarXApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ScholarX',
//       debugShowCheckedModeBanner: false,
//       initialRoute: AppRoutes.selectRole,
//       routes: AppRoutes.routes,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF5722)),
//         useMaterial3: true,
//         fontFamily: 'Roboto',
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }


// หน้าแรก
// import 'package:flutter/material.dart';
// import 'screens/splash_screen.dart';
// import 'screens/scholarship_detail_screen.dart';

// void main() {
//   runApp(const ScholarXApp());
// }

// class ScholarXApp extends StatelessWidget {
//   const ScholarXApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ScholarX',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF5722)),
//         useMaterial3: true,
//         fontFamily: 'Roboto',
//       ),
//       home: const ScholarshipDetailScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'coreApp/themeApp/app_theme.dart';
import 'features/student_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ScholarXApp());
}

class ScholarXApp extends StatelessWidget {
  const ScholarXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScholarX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splashScreen,
      routes: AppRoutes.routes,
    );
  }
}

