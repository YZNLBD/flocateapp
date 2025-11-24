## Modern Widgets Library - Usage Guide

A collection of reusable, beautiful modern widgets for building consistent UIs across your Flutter app.

### 📦 Widgets Included

---

## 1. **ModernGradientButton**
Beautiful gradient button with smooth animations and scale effects.

```dart
ModernGradientButton(
  label: "Save Changes",
  icon: Icons.check,
  gradientColors: [Colors.purple.shade400, Colors.blue.shade400],
  onPressed: () {
    // Handle button press
  },
)
```

**Parameters:**
- `label` (required): Button text
- `onPressed` (required): Callback when pressed
- `icon`: Optional icon before text
- `gradientColors`: List of colors for gradient (default: purple to blue)
- `isLoading`: Show loading indicator
- `borderRadius`: Border radius (default: 16)
- `verticalPadding`: Vertical padding (default: 14)
- `horizontalPadding`: Horizontal padding (default: 24)
- `fullWidth`: Make button full width (default: true)

---

## 2. **ModernGlassCard**
Glassmorphic card with blur effect and modern styling.

```dart
ModernGlassCard(
  padding: const EdgeInsets.all(20),
  child: Text("Your content here"),
)
```

**Parameters:**
- `child` (required): Widget to display inside card
- `padding`: Inner padding (default: all 20)
- `borderRadius`: Border radius (default: 20)
- `opacity`: Background opacity (default: 0.95)
- `hasBorder`: Show border (default: true)
- `customShadow`: Custom shadow effect

---

## 3. **ModernProfilePicture**
Circular profile picture with edit button overlay.

```dart
ModernProfilePicture(
  imageFile: File('path/to/image.jpg'),
  size: 140,
  onEditPressed: () {
    // Handle edit
  },
  initials: "JD",
)
```

**Parameters:**
- `imageFile`: Local image file
- `imageUrl`: Network image URL
- `size`: Diameter of circle (default: 140)
- `onEditPressed`: Callback for edit button
- `initials`: Display initials if no image
- `backgroundColor`: Background color
- `iconColor`: Icon color

---

## 4. **ModernGradientBackground**
Full-screen gradient background container.

```dart
ModernGradientBackground(
  colors: [Colors.blue.shade50, Colors.purple.shade50],
  child: YourContent(),
)
```

**Parameters:**
- `child` (required): Content to display
- `colors`: Gradient colors
- `begin`: Gradient start alignment
- `end`: Gradient end alignment

---

## 5. **ModernSettingsTile**
Settings menu item with icon, title, and subtitle.

```dart
ModernSettingsTile(
  icon: Icons.notifications,
  title: "Notifications",
  subtitle: "Manage notifications",
  iconColor: Colors.purple.shade400,
  trailingIcon: Icons.arrow_forward_ios,
  onTap: () {
    // Handle tap
  },
)
```

**Parameters:**
- `icon` (required): Leading icon
- `title` (required): Tile title
- `subtitle`: Optional subtitle
- `onTap` (required): Tap callback
- `trailingIcon`: Optional trailing icon
- `iconColor`: Icon color
- `trailing`: Custom trailing widget

---

## 6. **ModernHeader**
Gradient header with title, subtitle, and custom content.

```dart
ModernHeader(
  title: "Welcome",
  subtitle: "Back to your profile",
  gradientColors: [Colors.blue.shade400, Colors.purple.shade400],
  height: 200,
)
```

**Parameters:**
- `title` (required): Header title
- `subtitle`: Optional subtitle
- `gradientColors`: Gradient colors
- `height`: Header height (default: 200)
- `child`: Optional custom content overlay

---

## 7. **ModernInputField**
Styled input field with focus animations.

```dart
ModernInputField(
  controller: textController,
  labelText: "Enter username",
  prefixIcon: Icons.person,
  accentColor: Colors.purple.shade400,
)
```

**Parameters:**
- `controller` (required): TextEditingController
- `labelText` (required): Input label
- `prefixIcon`: Leading icon
- `hintText`: Placeholder text
- `obscureText`: Hide input (for passwords)
- `keyboardType`: Input type
- `maxLines`: Max lines
- `accentColor`: Focus color

---

## 8. **ModernExpandableCard**
Expandable card with smooth animations.

```dart
ModernExpandableCard(
  title: "Advanced Settings",
  icon: Icons.settings,
  initiallyExpanded: true,
  content: Column(
    children: [
      // Your settings widgets
    ],
  ),
)
```

**Parameters:**
- `title` (required): Card title
- `content` (required): Expandable content
- `icon` (required): Title icon
- `iconColor`: Icon color
- `initiallyExpanded`: Start expanded (default: true)

---

## 9. **ModernStatCard**
Card for displaying metrics/statistics.

```dart
ModernStatCard(
  value: "2,450",
  label: "Total Points",
  icon: Icons.trending_up,
  gradientColors: [Colors.purple.shade400, Colors.blue.shade400],
)
```

**Parameters:**
- `value` (required): Stat value
- `label` (required): Stat label
- `icon` (required): Display icon
- `gradientColors`: Icon gradient colors

---

## 🎨 Usage Examples

### Complete Profile Screen
```dart
import 'package:flocateapp/widgets/modern_widgets.dart';

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ModernHeader(
                title: "Dashboard",
                subtitle: "Welcome back!",
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(20),
                child: ModernGlassCard(
                  child: Column(
                    children: [
                      ModernSettingsTile(
                        icon: Icons.person,
                        title: "Profile",
                        onTap: () {},
                      ),
                      Divider(),
                      ModernSettingsTile(
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ModernGradientButton(
                  label: "Continue",
                  onPressed: () {},
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

### Dashboard with Stats
```dart
Column(
  children: [
    Padding(
      padding: EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ModernStatCard(
            value: "2,450",
            label: "Total Points",
            icon: Icons.trending_up,
          ),
          ModernStatCard(
            value: "156",
            label: "Friends",
            icon: Icons.people,
          ),
          ModernStatCard(
            value: "89",
            label: "Achievements",
            icon: Icons.star,
          ),
          ModernStatCard(
            value: "42",
            label: "Reviews",
            icon: Icons.rate_review,
          ),
        ],
      ),
    ),
  ],
)
```

### Settings Section
```dart
ModernExpandableCard(
  title: "Advanced Settings",
  icon: Icons.settings,
  content: Column(
    children: [
      ModernSettingsTile(
        icon: Icons.dark_mode,
        title: "Dark Mode",
        onTap: () {},
      ),
      Divider(),
      ModernSettingsTile(
        icon: Icons.language,
        title: "Language",
        onTap: () {},
      ),
    ],
  ),
)
```

---

## 🎯 Color Schemes

### Purple & Blue (Default)
```dart
gradientColors: [Colors.purple.shade400, Colors.blue.shade400]
```

### Red & Orange (Alert)
```dart
gradientColors: [Colors.red.shade400, Colors.orange.shade400]
```

### Green & Teal (Success)
```dart
gradientColors: [Colors.green.shade400, Colors.teal.shade400]
```

### Pink & Purple (Playful)
```dart
gradientColors: [Colors.pink.shade400, Colors.purple.shade400]
```

---

## ✨ Tips & Best Practices

1. **Consistency**: Use the same gradient colors throughout your app for a cohesive look
2. **Spacing**: Use `SizedBox(height: 16)` or `SizedBox(height: 20)` between components
3. **Icons**: Choose icons from Material Icons that represent the action clearly
4. **Loading States**: Always set `isLoading: true` on buttons during API calls
5. **Accessibility**: Provide clear labels and subtitles for better UX
6. **Colors**: Use `Colors.purple.shade400` for primary actions, `Colors.red.shade400` for destructive actions

---

## 📁 File Structure

```
lib/
├── widgets/
│   └── modern_widgets.dart      # All modern widgets
├── screens/
│   ├── profile_screen.dart      # Example using widgets
│   └── ...other screens
└── main.dart
```

---

## 🚀 Quick Start

1. Import in your screen:
```dart
import 'package:flocateapp/widgets/modern_widgets.dart';
```

2. Start using the widgets:
```dart
ModernGradientButton(
  label: "Get Started",
  onPressed: () {},
)
```

3. Customize colors and styling as needed!
