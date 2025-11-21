import 'package:flutter/material.dart';
import 'package:flocateapp/screens/register_screen.dart';
import 'package:flocateapp/screens/forgot_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscure = true; // لتحكم إظهار/إخفاء كلمة المرور
  bool _loading = false; // حالة تحميل أثناء محاولة تسجيل الدخول
  bool rememberMe = false; // حالة تذكرني

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // مثال دالة تحقق بسيطة قبل محاولة تسجيل الدخول
  bool _validateInputs() {
    final email = emailController.text.trim();
    final pass = passwordController.text;
    if (email.isEmpty || pass.isEmpty) return false;
    // يمكن إضافة تحقق بريد إلكتروني regex هنا
    return true;
  }

 Future<void> _login() async {
  if (!_validateInputs()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
    );
    return;
  }

  setState(() => _loading = true);

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // نجاح تسجيل الدخول
    Navigator.pushReplacementNamed(context, '/home_screen');

  } on FirebaseAuthException catch (e) {
    String message = "Bir hata oluştu";

    if (e.code == 'user-not-found') {
      message = "Bu e-posta ile kullanıcı bulunamadı";
    } else if (e.code == 'wrong-password') {
      message = "Hatalı parola";
    } else if (e.code == 'invalid-email') {
      message = "Geçersiz e-posta formatı";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Logo
              Center(
                child: Hero(
                  tag: "logo",
                  child: Image.asset(
                    "assets/splash.png",
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              Center(
                child: Text (
                "Hoş Geldiniz", 
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w400),
              )
              ),
              const SizedBox(height: 36),

              // Email Field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "E-posta", // Turkish: Email
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: "Parola", // Turkish: Password
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              Row(
                children: [
                  // Checkbox + label
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text("Beni Hatırla"),
                    ],
                  ),

                  const Spacer(), // يضع المسافة بين العناصر على نفس السطر

                  // Forgot password
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ForgotPassword()));
                    },
                    child: const Text("Parolamı unuttum?"),
                  ),
                ],
              ),

              

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          "Giriş Yap", // Turkish: Login
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Create account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hesabınız yok mu?"), // Turkish: Don't have an account?
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()));
                    },
                    child: const Text("Yeni hesap oluştur"), // Turkish: Create new account
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
