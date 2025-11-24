import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flocateapp/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flocateapp/widgets/modern_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController usernameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  bool editing = false;
  bool loading = false;
  bool notificationsEnabled = true;
  File? _selectedImage;
  bool logoutLoading = false;


  Future<DocumentSnapshot> getUserData() async {
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        // Here you can upload image to Firebase Storage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile picture updated successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  Future<void> _logout() async {
  setState(() => logoutLoading = true);
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
      SnackBar(content: Text("Logout failed: $e")),
    );
  } finally {
    setState(() => logoutLoading = false);
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
      body: ModernGradientBackground(
        child: FutureBuilder<DocumentSnapshot>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var data = snapshot.data!;
            String username = data['username'] ?? "User";
            String email = data['email'] ?? "";

            if (!editing && usernameController.text != username) {
              usernameController.text = username;
            }

            return CustomScrollView(
              slivers: [
                // Header with profile picture
                SliverAppBar(
                  expandedHeight: 320,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade400,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            "Profile",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "Manage your profile",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          ModernProfilePicture(
                            imageFile: _selectedImage,
                            size: 140,
                            onEditPressed: _pickImage,
                            initials: username.isNotEmpty
                                ? username[0].toUpperCase()
                                : "U",
                          ),
                          const SizedBox(height: 20),
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Main content
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Username Edit Section
                      if (editing)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ModernGlassCard(
                            child: ModernInputField(
                              controller: usernameController,
                              labelText: "Edit Username",
                              prefixIcon: Icons.edit,
                              accentColor: Colors.purple.shade400,
                            ),
                          ),
                        ),

                      // Settings Card
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ModernGlassCard(
                          child: Column(
                            children: [
                              SwitchListTile(
                                value: notificationsEnabled,
                                activeColor: Colors.purple.shade400,
                                onChanged: (val) {
                                  setState(() => notificationsEnabled = val);
                                },
                                title: const Text(
                                  "Notifications",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: const Text("Stay updated with notifications"),
                                secondary: Icon(
                                  Icons.notifications_active,
                                  color: Colors.purple.shade400,
                                  size: 28,
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey.shade200,
                              ),
                              ModernSettingsTile(
                                icon: Icons.lock,
                                title: "Change Password",
                                subtitle: "Reset with email",
                                iconColor: Colors.purple.shade400,
                                trailingIcon: Icons.arrow_forward_ios,
                                onTap: _changePassword,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ModernGradientButton(
                              label: editing ? "Save Username" : "Edit Username",
                              icon: editing ? Icons.check : Icons.edit,
                              gradientColors: [
                                Colors.purple.shade400,
                                Colors.blue.shade400,
                              ],
                              isLoading: loading,
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
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: ModernGradientButton(
                          label: "Logout",
                          icon: Icons.logout,
                          gradientColors: [
                            Colors.red.shade400,
                            Colors.orange.shade400,
                          ],
                          isLoading: logoutLoading,   // التعديل المهم
                          fullWidth: true,
                          onPressed: _logout,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
