import 'package:flutter/material.dart';
import 'package:flocateapp/screens/register_screen.dart';
import 'package:flocateapp/screens/forgot_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flocateapp/widgets/modern_widgets.dart';



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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
        child: ModernGradientBackground(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                
                
                // Header Section with Icon
                Column(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          "assets/logo0.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Hoş Geldiniz",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Hesabınıza giriş yapın",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),

                // Form Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ModernGlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Email Input
                        ModernInputField(
                          controller: emailController,
                          labelText: "E-posta",
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          accentColor: Colors.purple.shade400,
                        ),
                        const SizedBox(height: 14),

                        // Password Input
                        ModernInputField(
                          controller: passwordController,
                          labelText: "Parola",
                          prefixIcon: Icons.lock,
                          obscureText: _obscure,
                          accentColor: Colors.purple.shade400,
                        ),
                        const SizedBox(height: 10),

                        // Show/Hide Password Toggle
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => setState(() => _obscure = !_obscure),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _obscure ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.purple.shade400,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _obscure ? "Göster" : "Gizle",
                                  style: TextStyle(
                                    color: Colors.purple.shade400,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Remember Me Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              },
                              activeColor: Colors.purple.shade400,
                            ),
                            const Text(
                              "Beni Hatırla",
                              style: TextStyle(fontSize: 13),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                MaterialPageRoute(builder: (_) => const ForgotPassword()));
                              },
                              child: Text(
                                "Parolamı unuttum?",
                                style: TextStyle(
                                  color: Colors.purple.shade400,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Login Button
                      ModernGradientButton(
                        label: "Giriş Yap",
                        icon: Icons.login,
                        gradientColors: [
                          Colors.purple.shade400,
                          Colors.blue.shade400,
                        ],
                        isLoading: _loading,
                        fullWidth: true,
                        onPressed: _login,
                      ),
                      const SizedBox(height: 14),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hesabınız yok mu? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen()));
                            },
                            child: Text(
                              "Yeni hesap oluştur",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
