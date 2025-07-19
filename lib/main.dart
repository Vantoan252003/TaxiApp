import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'general_lib/screens/splash_screen.dart';
import 'general_lib/screens/auth_wrapper.dart';
import 'general_lib/core/di/service_locator.dart';
import 'general_lib/core/providers/auth_provider.dart';
import 'general_lib/services/vietmap_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize service locator
  ServiceLocator.instance.registerServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          lazy: false, // Initialize immediately
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
