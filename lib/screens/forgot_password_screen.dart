import 'package:flutter/material.dart';
import 'package:flocateapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flocateapp/widgets/modern_widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    final email = emailController.text.trim();
    if (email.isEmpty) return false;
    return true;
  }

  Future<void> _resetPassword() async {
    if (!_validateInputs()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen e-posta girin')),
      );
      return;
    }
    setState(() => _loading = true);

    try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: emailController.text.trim(),
    );

    if (mounted) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre sıfırlama linki gönderildi')),
      );
    }
  } on FirebaseAuthException catch (e) {
    setState(() => _loading = false);
    String message = '';
    if (e.code == 'user-not-found') {
      message = 'Kullanıcı bulunamadı';
    } else if (e.code == 'invalid-email') {
      message = 'Geçersiz e-posta adresi';
    } else {
      message = 'Bir hata oluştu: ${e.message}';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          "assets/logo0.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Şifre Sıfırlama",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Yeni şifre oluşturun",
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
                          labelText: "E-posta Adresi",
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          accentColor: Colors.purple.shade400,
                        ),
                        const SizedBox(height: 14),
                        
                        // Info Text
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.purple.shade400,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Şifre sıfırlama linki e-mailinizie gönderilecektir.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.purple.shade600,
                                  ),
                                ),
                              ),
                            ],
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
                      // Send Button
                      ModernGradientButton(
                        label: "Gönder",
                        icon: Icons.send,
                        gradientColors: [
                          Colors.purple.shade400,
                          Colors.blue.shade400,
                        ],
                        isLoading: _loading,
                        fullWidth: true,
                        onPressed: _resetPassword,
                      ),
                      const SizedBox(height: 12),

                      // Return to Login Button
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.purple.shade400,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.purple.shade400,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Giriş Sayfasına Dön",
                                style: TextStyle(
                                  color: Colors.purple.shade400,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
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
