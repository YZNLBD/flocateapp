import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flocateapp/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController usernameController = TextEditingController();

  bool editing = false;
  bool loading = false;
  bool notificationsEnabled = true;

  Future<DocumentSnapshot> getUserData() async {
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<void> _logout() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logout failed: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  void _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.email == null) return;

    await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      body: FutureBuilder<DocumentSnapshot>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!;
          String username = data['username'] ?? "";
          String email = data['email'] ?? "";

          if (!editing && usernameController.text != username) {
            usernameController.text = username;
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // مركزي بالكامل
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ----------------- Glass Card -----------------
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.4), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            editing
                                ? TextField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      labelText: "Username Düzenle",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.3),
                                    ),
                                  )
                                : Text(
                                    username,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            Text(
                              email,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            const SizedBox(height: 20),
                            loading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                    ),
                                    onPressed: () async {
                                      if (editing) {
                                        setState(() => loading = true);

                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid)
                                            .update({
                                          "username":
                                              usernameController.text.trim(),
                                        });

                                        setState(() {
                                          editing = false;
                                          loading = false;
                                        });
                                      } else {
                                        setState(() => editing = true);
                                      }
                                    },
                                    child: Text(
                                      editing ? "Kaydet" : "Username Düzenle",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ----------------- Settings Glass Card -----------------
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.4), width: 1.2),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              value: notificationsEnabled,
                              onChanged: (val) {
                                setState(() => notificationsEnabled = val);
                              },
                              title: const Text("Bildirimler"),
                              secondary: const Icon(Icons.notifications_active,
                                  color: Colors.blueAccent),
                            ),
                            const Divider(),
                            ListTile(
                              leading:
                                  const Icon(Icons.lock, color: Colors.blueAccent),
                              title: const Text("Şifreyi Değiştir"),
                              subtitle: const Text(
                                  "E-posta üzerinden şifre sıfırlama"),
                              onTap: _changePassword,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ----------------- Logout Button -----------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        "Çıkış Yap",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: loading ? null : _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
