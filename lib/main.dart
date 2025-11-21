import 'package:flocateapp/screens/splash_screen.dart';
import 'package:flocateapp/screens/login_screen.dart';
import 'package:flocateapp/screens/register_screen.dart';
import 'package:flocateapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
      ),
      // الصفحة الأساسية الآن تعتمد على حالة تسجيل الدخول
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

// هذا الويجيت يتحقق من حالة تسجيل الدخول
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // إذا المستخدم مسجل الدخول -> انتقل للصفحة الرئيسية
      return const HomeScreen();
    } else {
      // إذا لم يكن مسجل الدخول -> انتقل لشاشة تسجيل الدخول
      return const LoginScreen();
    }
  }
}
