# 🎨 Modern Widgets - Quick Reference

## Import Statement
```dart
import 'package:flocateapp/widgets/modern_widgets.dart';
```

## 9 Powerful Widgets Ready to Use

### 1️⃣ ModernGradientButton
```dart
ModernGradientButton(
  label: "Click Me",
  icon: Icons.check,
  onPressed: () {},
)
```
**Best For:** Primary actions, form submissions, navigation

---

### 2️⃣ ModernGlassCard
```dart
ModernGlassCard(
  child: Text("Your Content"),
)
```
**Best For:** Card containers, sections, content grouping

---

### 3️⃣ ModernProfilePicture
```dart
ModernProfilePicture(
  imageFile: pickedImage,
  size: 140,
  onEditPressed: () {},
)
```
**Best For:** User avatars, profile pages

---

### 4️⃣ ModernGradientBackground
```dart
ModernGradientBackground(
  child: YourScreen(),
)
```
**Best For:** Full-screen backgrounds, consistent theming

---

### 5️⃣ ModernSettingsTile
```dart
ModernSettingsTile(
  icon: Icons.notifications,
  title: "Notifications",
  onTap: () {},
)
```
**Best For:** Settings, menu items, list tiles

---

### 6️⃣ ModernHeader
```dart
ModernHeader(
  title: "Welcome",
  subtitle: "Back!",
)
```
**Best For:** Screen headers, section titles

---

### 7️⃣ ModernInputField
```dart
ModernInputField(
  controller: controller,
  labelText: "Email",
  prefixIcon: Icons.email,
)
```
**Best For:** Forms, text input, user data collection

---

### 8️⃣ ModernExpandableCard
```dart
ModernExpandableCard(
  title: "Settings",
  icon: Icons.settings,
  content: YourContent(),
)
```
**Best For:** Collapsible sections, advanced options

---

### 9️⃣ ModernStatCard
```dart
ModernStatCard(
  value: "2,450",
  label: "Total",
  icon: Icons.trending_up,
)
```
**Best For:** Dashboards, metrics, statistics

---

## 🎨 Gradient Color Presets

```dart
// Purple & Blue (Default)
[Colors.purple.shade400, Colors.blue.shade400]

// Red & Orange (Danger/Alert)
[Colors.red.shade400, Colors.orange.shade400]

// Green & Teal (Success)
[Colors.green.shade400, Colors.teal.shade400]

// Pink & Purple (Playful)
[Colors.pink.shade400, Colors.purple.shade400]

// Blue & Cyan (Cool)
[Colors.blue.shade400, Colors.cyan.shade400]

// Orange & Red (Warm)
[Colors.orange.shade400, Colors.red.shade400]
```

---

## 💡 Common Patterns

### Complete Settings Screen
```dart
Scaffold(
  body: ModernGradientBackground(
    child: SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          ModernHeader(title: "Settings"),
          SizedBox(height: 20),
          ModernGlassCard(
            child: Column(
              children: [
                ModernSettingsTile(
                  icon: Icons.person,
                  title: "Profile",
                  onTap: () {},
                ),
                Divider(),
                ModernSettingsTile(
                  icon: Icons.notifications,
                  title: "Notifications",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
)
```

### Dashboard Grid
```dart
GridView.count(
  crossAxisCount: 2,
  children: [
    ModernStatCard(
      value: "100",
      label: "Users",
      icon: Icons.people,
    ),
    ModernStatCard(
      value: "50",
      label: "Active",
      icon: Icons.check_circle,
    ),
  ],
)
```

### Form with Input Fields
```dart
Column(
  children: [
    ModernInputField(
      controller: nameController,
      labelText: "Name",
      prefixIcon: Icons.person,
    ),
    SizedBox(height: 16),
    ModernInputField(
      controller: emailController,
      labelText: "Email",
      prefixIcon: Icons.email,
    ),
    SizedBox(height: 20),
    ModernGradientButton(
      label: "Submit",
      onPressed: () {},
    ),
  ],
)
```

---

## 🔧 Common Parameters

### Button Parameters
- `label` - Button text
- `onPressed` - Tap callback
- `icon` - Icon before text
- `gradientColors` - Color gradient
- `isLoading` - Show loader
- `fullWidth` - Make full width

### Card Parameters
- `child` - Content widget
- `padding` - Inner spacing
- `borderRadius` - Corner radius
- `opacity` - Background opacity
- `hasBorder` - Show border

### Input Parameters
- `controller` - Text controller
- `labelText` - Field label
- `prefixIcon` - Icon before text
- `obscureText` - Hide input
- `accentColor` - Focus color

---

## 🚀 Pro Tips

1. **Wrap your entire screen in `ModernGradientBackground`** for consistent theming
2. **Use `ModernGlassCard` to group related content** for better visual hierarchy
3. **Add `SizedBox(height: 16)` between components** for consistent spacing
4. **Always use `isLoading: true`** on buttons during API calls
5. **Customize `gradientColors`** to match your app's theme
6. **Use `ModernHeader` as your screen titles** for a polished look

---

## 📝 Example: Complete Profile Screen

```dart
import 'package:flocateapp/widgets/modern_widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? profileImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: ModernHeader(
                  title: "Profile",
                  child: Center(
                    child: ModernProfilePicture(
                      imageFile: profileImage,
                      onEditPressed: () {
                        // Pick image
                      },
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ModernGlassCard(
                    child: Column(
                      children: [
                        ModernSettingsTile(
                          icon: Icons.edit,
                          title: "Edit Profile",
                          onTap: () {},
                        ),
                        Divider(),
                        ModernSettingsTile(
                          icon: Icons.lock,
                          title: "Security",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ModernGradientButton(
                    label: "Save",
                    isLoading: isLoading,
                    onPressed: () {
                      // Save changes
                    },
                  ),
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

**Now you can build beautiful, consistent UIs across your entire app! 🎉**
