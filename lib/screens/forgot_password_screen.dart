import 'package:flutter/material.dart';
import 'package:flocateapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: "logo",
                child: Image.asset(
                  "assets/splash.png",
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 48),

              Text(
                "Şifre Sıfırlama",
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "E-posta",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Send reset link
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _resetPassword,
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
                          "Gönder", // Turkish: Login
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Return to login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Giriş sayfasına dön",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),


              const SizedBox(height: 24),

              Text(
                "Şifre sıfırlama linki e-mail'inize gönderilecektir.",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
