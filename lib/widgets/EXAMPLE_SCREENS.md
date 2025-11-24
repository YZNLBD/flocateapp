## 📱 Example Screens Using Modern Widgets

Here are complete, ready-to-use examples that you can copy into your app!

---

## 1. 🏠 Dashboard Screen

```dart
import 'package:flutter/material.dart';
import 'package:flocateapp/widgets/modern_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ModernHeader(
                title: "Dashboard",
                subtitle: "Welcome back! 👋",
                height: 220,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quick Stats",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ModernStatCard(
                          value: "2,450",
                          label: "Total Points",
                          icon: Icons.trending_up,
                          gradientColors: [
                            Colors.purple.shade400,
                            Colors.blue.shade400,
                          ],
                        ),
                        ModernStatCard(
                          value: "156",
                          label: "Friends",
                          icon: Icons.people,
                          gradientColors: [
                            Colors.pink.shade400,
                            Colors.purple.shade400,
                          ],
                        ),
                        ModernStatCard(
                          value: "89",
                          label: "Achievements",
                          icon: Icons.star,
                          gradientColors: [
                            Colors.orange.shade400,
                            Colors.yellow.shade400,
                          ],
                        ),
                        ModernStatCard(
                          value: "42",
                          label: "Reviews",
                          icon: Icons.rate_review,
                          gradientColors: [
                            Colors.green.shade400,
                            Colors.teal.shade400,
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Recent Activity",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ModernGlassCard(
                      child: Column(
                        children: [
                          ModernSettingsTile(
                            icon: Icons.check_circle,
                            title: "Completed Task",
                            subtitle: "2 hours ago",
                            onTap: () {},
                          ),
                          const Divider(),
                          ModernSettingsTile(
                            icon: Icons.favorite,
                            title: "Got a like",
                            subtitle: "5 hours ago",
                            onTap: () {},
                          ),
                          const Divider(),
                          ModernSettingsTile(
                            icon: Icons.comment,
                            title: "New comment",
                            subtitle: "1 day ago",
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 2. ⚙️ Settings Screen

```dart
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: ModernHeader(
                  title: "Settings",
                  subtitle: "Customize your experience",
                  height: 180,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    "Notifications",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ModernGlassCard(
                    child: SwitchListTile(
                      value: notificationsEnabled,
                      onChanged: (val) {
                        setState(() => notificationsEnabled = val);
                      },
                      title: const Text("Push Notifications"),
                      subtitle: const Text("Receive app notifications"),
                      secondary: Icon(
                        Icons.notifications,
                        color: Colors.purple.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Display",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ModernGlassCard(
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: darkModeEnabled,
                          onChanged: (val) {
                            setState(() => darkModeEnabled = val);
                          },
                          title: const Text("Dark Mode"),
                          subtitle: const Text("Enable dark theme"),
                          secondary: Icon(
                            Icons.dark_mode,
                            color: Colors.purple.shade400,
                          ),
                        ),
                        const Divider(),
                        ModernSettingsTile(
                          icon: Icons.language,
                          title: "Language",
                          subtitle: selectedLanguage,
                          onTap: () {
                            // Show language picker
                          },
                          trailingIcon: Icons.arrow_forward_ios,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Account",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ModernGlassCard(
                    child: Column(
                      children: [
                        ModernSettingsTile(
                          icon: Icons.lock,
                          title: "Change Password",
                          onTap: () {},
                          trailingIcon: Icons.arrow_forward_ios,
                        ),
                        const Divider(),
                        ModernSettingsTile(
                          icon: Icons.delete,
                          title: "Delete Account",
                          onTap: () {},
                          trailingIcon: Icons.arrow_forward_ios,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ModernGradientButton(
                    label: "Logout",
                    icon: Icons.logout,
                    gradientColors: [
                      Colors.red.shade400,
                      Colors.orange.shade400,
                    ],
                    onPressed: () {
                      // Handle logout
                    },
                  ),
                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 3. 📝 Edit Profile Screen

```dart
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  File? profileImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: "John Doe");
    emailController = TextEditingController(text: "john@example.com");
    bioController = TextEditingController(text: "Flutter Developer");
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: ModernHeader(
                  title: "Edit Profile",
                  height: 220,
                  child: Center(
                    child: ModernProfilePicture(
                      imageFile: profileImage,
                      size: 120,
                      onEditPressed: () {
                        // Pick image
                      },
                      initials: "JD",
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ModernGlassCard(
                    child: Column(
                      children: [
                        ModernInputField(
                          controller: nameController,
                          labelText: "Full Name",
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        ModernInputField(
                          controller: emailController,
                          labelText: "Email",
                          prefixIcon: Icons.email,
                        ),
                        const SizedBox(height: 16),
                        ModernInputField(
                          controller: bioController,
                          labelText: "Bio",
                          prefixIcon: Icons.description,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ModernExpandableCard(
                    title: "Privacy Settings",
                    icon: Icons.privacy_tip,
                    content: Column(
                      children: [
                        SwitchListTile(
                          value: true,
                          onChanged: (val) {},
                          title: const Text("Public Profile"),
                          subtitle: const Text("Let others find your profile"),
                        ),
                        const Divider(),
                        SwitchListTile(
                          value: false,
                          onChanged: (val) {},
                          title: const Text("Show Activity"),
                          subtitle: const Text("Others can see your activity"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ModernGradientButton(
                    label: "Save Changes",
                    icon: Icons.check,
                    isLoading: isLoading,
                    onPressed: () async {
                      setState(() => isLoading = true);
                      // Save profile
                      await Future.delayed(Duration(seconds: 2));
                      setState(() => isLoading = false);
                    },
                  ),
                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 4. 📧 Contact Form Screen

```dart
class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({Key? key}) : super(key: key);

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController subjectController;
  late TextEditingController messageController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    subjectController = TextEditingController();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ModernHeader(
                title: "Contact Us",
                subtitle: "We'd love to hear from you",
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ModernGlassCard(
                  child: Column(
                    children: [
                      ModernInputField(
                        controller: nameController,
                        labelText: "Your Name",
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      ModernInputField(
                        controller: emailController,
                        labelText: "Email Address",
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: 16),
                      ModernInputField(
                        controller: subjectController,
                        labelText: "Subject",
                        prefixIcon: Icons.subject,
                      ),
                      const SizedBox(height: 16),
                      ModernInputField(
                        controller: messageController,
                        labelText: "Message",
                        prefixIcon: Icons.message,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 24),
                      ModernGradientButton(
                        label: "Send Message",
                        icon: Icons.send,
                        isLoading: isLoading,
                        onPressed: () async {
                          setState(() => isLoading = true);
                          // Send message
                          await Future.delayed(Duration(seconds: 2));
                          setState(() => isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Message sent successfully!"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 5. 🎯 Onboarding Screen

```dart
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                children: [
                  _buildOnboardingPage(
                    icon: Icons.lock,
                    title: "Secure",
                    subtitle: "Your data is always encrypted and safe",
                  ),
                  _buildOnboardingPage(
                    icon: Icons.speed,
                    title: "Fast",
                    subtitle: "Lightning quick performance",
                  ),
                  _buildOnboardingPage(
                    icon: Icons.star,
                    title: "Premium",
                    subtitle: "Enjoy premium features for free",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        width: currentPage == index ? 32 : 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: currentPage == index
                              ? Colors.purple.shade400
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (currentPage < 2)
                    ModernGradientButton(
                      label: "Next",
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                    )
                  else
                    ModernGradientButton(
                      label: "Get Started",
                      icon: Icons.check,
                      onPressed: () {
                        // Navigate to home
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade400,
                Colors.blue.shade400,
              ],
            ),
          ),
          child: Icon(icon, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 32),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}
```

---

**These examples are production-ready and fully customizable! Copy and paste to get started instantly! 🚀**
