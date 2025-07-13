import 'package:workmanager/workmanager.dart';
import 'package:flutter/material.dart';
import 'general_lib/screens/splash_screen.dart';
import 'general_lib/screens/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Đặt false khi release
  );
  runApp(const MyApp());
}
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // TODO: Thực hiện tác vụ nền ở đây (ví dụ: gửi vị trí, đồng bộ dữ liệu, ...)
    print("Background task is running");
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'System',
      ),
      home: const SplashScreen(
        homeScreen: AuthWrapper(),
      ),
    );
  }
}
