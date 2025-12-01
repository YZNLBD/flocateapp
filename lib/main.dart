import 'package:flocateapp/screens/splash_screen.dart';
import 'package:flocateapp/screens/login_screen.dart';
import 'package:flocateapp/screens/register_screen.dart';
import 'package:flocateapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart'; // مكتبة البروفايدر

// استيراد ملفات البروفايدر الخاصة بك
import 'screens/device_provider.dart'; 
import 'screens/notification_provider.dart'; // <-- تأكد من إنشاء هذا الملف واستيراده

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // التغيير هنا: نستخدم MultiProvider بدلاً من ChangeNotifierProvider
    MultiProvider(
      providers: [
        // 1. بروفايدر الأجهزة
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        
        // 2. بروفايدر الإشعارات (هذا الذي كان ينقصك)
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LocateApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home_screen': (context) => const HomeScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}