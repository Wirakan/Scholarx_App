import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';                          
import 'coreApp/themeApp/app_theme.dart';
import 'student/routes/student_routes.dart';
import 'student/providers/notification_provider.dart';            

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ChangeNotifierProvider(                                        
      create: (_) => NotificationProvider(),                      
      child: const ScholarXApp(),                                  
    ),                                                             
  );
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