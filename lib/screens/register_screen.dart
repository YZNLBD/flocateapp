import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flocateapp/widgets/modern_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      return false;
    }

    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Parolalar uyuşmuyor")),
      );
      return false;
    }

    return true;
  }

  Future<void> _register() async {
    if (!_validateInputs()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // 📌 1) Create user in Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 📌 2) Save user data in Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "username": usernameController.text.trim(),
        "email": emailController.text.trim(),
        "createdAt": Timestamp.now(),
      });

      // 📌 3) Navigate to home
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = "Bir hata oluştu";

      if (e.code == 'email-already-in-use') {
        message = "Bu e-posta zaten kayıtlı";
      } else if (e.code == 'invalid-email') {
        message = "Geçersiz e-posta formatı";
      } else if (e.code == 'weak-password') {
        message = "Parola çok zayıf (en az 6 karakter)";
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
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        "assets/logo0.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Text(
                    "Hesap oluştur",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  Text(
                    "Bize katıl",
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
                      // Username Input
                      ModernInputField(
                        controller: usernameController,
                        labelText: "Adı",
                        prefixIcon: Icons.person,
                        accentColor: Colors.purple.shade400,
                      ),
                      const SizedBox(height: 14),

                      // Email Input
                      ModernInputField(
                        controller: emailController,
                        labelText: "E-mail Adresi",
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
                      const SizedBox(height: 14),

                      // Confirm Password Input
                      ModernInputField(
                        controller: confirmPasswordController,
                        labelText: "Parolayı Doğrula",
                        prefixIcon: Icons.lock_outline,
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
                                _obscure ? "Show" : "Hide",
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
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Register Button
                    ModernGradientButton(
                      label: "Hesap Oluştur",
                      icon: Icons.check_circle,
                      gradientColors: [
                        Colors.purple.shade400,
                        Colors.blue.shade400,
                      ],
                      isLoading: _loading,
                      fullWidth: true,
                      onPressed: _register,
                    ),
                    const SizedBox(height: 14),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hesabın var mı?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/login'),
                          child: Text(
                            "Giriş Yap",
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
