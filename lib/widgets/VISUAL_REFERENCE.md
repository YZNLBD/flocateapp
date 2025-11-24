# 🎨 Widget Reference Card

Quick visual reference for all 9 modern widgets

---

## Widget: ModernGradientButton

```
┌─────────────────────────────┐
│  🔵 Purple    Click Me  🔵  │
│     [Gradient Button]       │
└─────────────────────────────┘
```

**Usage:**
```dart
ModernGradientButton(
  label: "Click Me",
  icon: Icons.check,
  onPressed: () {},
  gradientColors: [Colors.purple.shade400, Colors.blue.shade400],
)
```

**When to use:** Primary actions, form submissions, navigation

---

## Widget: ModernGlassCard

```
╔═════════════════════════════╗
║ 🔮 Glassmorphic Card        ║
║                             ║
║  Your content here          ║
║  With blur effect           ║
║                             ║
╚═════════════════════════════╝
```

**Usage:**
```dart
ModernGlassCard(
  padding: EdgeInsets.all(20),
  child: Text("Beautiful content"),
)
```

**When to use:** Grouping content, card-based layouts

---

## Widget: ModernProfilePicture

```
     ╭─────────╮
    ╱           ╲
   │   👤 (160) │  ← Circle with optional
   │  Profile   │     edit button
    ╲           ╱
     ╰─────────╯
       ╔════╗
       ║📷 edit
       ╚════╝
```

**Usage:**
```dart
ModernProfilePicture(
  imageFile: myImage,
  size: 140,
  onEditPressed: pickImage,
  initials: "JD",
)
```

**When to use:** User avatars, profile pages

---

## Widget: ModernGradientBackground

```
┌─────────────────────────────┐
│ 🔵 Gradient Background      │
│ ∘ ∘ ∘ Your Content ∘ ∘ ∘   │
│   (Full screen gradient)    │
│ ∘ ∘ ∘ ∘ ∘ ∘ ∘ ∘ ∘ ∘ ∘ ∘   │
│ 🟣 (Smooth gradient)       │
└─────────────────────────────┘
```

**Usage:**
```dart
ModernGradientBackground(
  colors: [Colors.blue.shade50, Colors.purple.shade50],
  child: YourScreen(),
)
```

**When to use:** Screen backgrounds, consistent theming

---

## Widget: ModernSettingsTile

```
┌─────────────────────────────┐
│ 🔔 Title                 →  │
│    Subtitle text            │
└─────────────────────────────┘
```

**Usage:**
```dart
ModernSettingsTile(
  icon: Icons.notifications,
  title: "Notifications",
  subtitle: "Manage notifications",
  onTap: () {},
  trailingIcon: Icons.arrow_forward_ios,
)
```

**When to use:** Settings menus, list items

---

## Widget: ModernHeader

```
╔═════════════════════════════╗
║ 🔵 Welcome        [Title]   ║
║    Back to your home        ║
║                             ║
║  [Custom content overlay]   ║
╚═════════════════════════════╝
```

**Usage:**
```dart
ModernHeader(
  title: "Welcome",
  subtitle: "Back to your profile",
  gradientColors: [Colors.blue.shade400, Colors.purple.shade400],
  height: 200,
)
```

**When to use:** Screen headers, section titles

---

## Widget: ModernInputField

```
┌─────────────────────────────┐
│ ✉️ Email Address           │
│  ✎ ____________________    │
│  [Focus animation]          │
└─────────────────────────────┘
```

**Usage:**
```dart
ModernInputField(
  controller: emailController,
  labelText: "Email",
  prefixIcon: Icons.email,
  accentColor: Colors.purple.shade400,
)
```

**When to use:** Forms, user data collection

---

## Widget: ModernExpandableCard

```
┌─────────────────────────────┐
│ ⚙️ Settings            ▼    │  ← Tap to expand
│    (Header - click me)      │
└─────────────────────────────┘

After expand:

┌─────────────────────────────┐
│ ⚙️ Settings            ▲    │
│ ─────────────────────────── │
│ • Option 1                  │
│ • Option 2                  │
│ • Option 3                  │
└─────────────────────────────┘
```

**Usage:**
```dart
ModernExpandableCard(
  title: "Advanced Settings",
  icon: Icons.settings,
  content: YourContent(),
  initiallyExpanded: true,
)
```

**When to use:** Accordion layouts, collapsible sections

---

## Widget: ModernStatCard

```
┌─────────────────────┐
│    🟣 Icon 🟣      │  ← Gradient circle
│                     │
│      2,450          │  ← Large value
│   Total Points      │  ← Label
└─────────────────────┘
```

**Usage:**
```dart
ModernStatCard(
  value: "2,450",
  label: "Total Points",
  icon: Icons.trending_up,
  gradientColors: [Colors.purple.shade400, Colors.blue.shade400],
)
```

**When to use:** Dashboards, metrics, statistics

---

## 📱 Common Layouts

### Full Page Layout
```
┌─────────────────────────────┐
│  ModernHeader               │
│  (Title + Optional Content) │
├─────────────────────────────┤
│                             │
│  Padding(all: 20)           │
│                             │
│  ┌───────────────────────┐  │
│  │ ModernGlassCard       │  │
│  │ or ModernInputField   │  │
│  └───────────────────────┘  │
│                             │
│  SizedBox(height: 20)       │
│                             │
│  ┌───────────────────────┐  │
│  │ ModernGradientButton  │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### Settings Grid Layout
```
┌─────────────────────────────┐
│  [Stat 1]  [Stat 2]         │
│  [Stat 3]  [Stat 4]         │
└─────────────────────────────┘
```

### Settings Menu Layout
```
┌─────────────────────────────┐
│  🔔 Notifications        →   │
├─────────────────────────────┤
│  🔒 Security             →   │
├─────────────────────────────┤
│  ⚙️ Settings             →   │
└─────────────────────────────┘
```

---

## 🎨 Color Gradients

### Purple & Blue (Primary)
```
🟣 ─────────────────── 🔵
  Colors.purple.shade400
  to
  Colors.blue.shade400
```

### Red & Orange (Danger)
```
🔴 ─────────────────── 🟠
  Colors.red.shade400
  to
  Colors.orange.shade400
```

### Green & Teal (Success)
```
🟢 ─────────────────── 🌊
  Colors.green.shade400
  to
  Colors.teal.shade400
```

### Pink & Purple (Playful)
```
🌸 ─────────────────── 🟣
  Colors.pink.shade400
  to
  Colors.purple.shade400
```

---

## 📊 Quick Selector Table

| Need | Widget | Icon |
|------|--------|------|
| Button | ModernGradientButton | 🔘 |
| Container | ModernGlassCard | 📦 |
| Avatar | ModernProfilePicture | 👤 |
| Background | ModernGradientBackground | 🖼️ |
| Menu Item | ModernSettingsTile | ⚙️ |
| Header | ModernHeader | 📍 |
| Input | ModernInputField | ⌨️ |
| Collapsible | ModernExpandableCard | 📂 |
| Metric | ModernStatCard | 📊 |

---

## ✨ Animation Examples

### ModernGradientButton Scale Animation
```
Normal:  ┌─────────────────┐
         │  Click Me       │
         └─────────────────┘

Pressed: ┌───────────────┐
         │   Click Me    │  ← Scales to 95%
         └───────────────┘
```

### ModernInputField Focus Animation
```
Unfocused:
┌─────────────────┐
│ ✎ Email        │ (Gray border)

Focused:
┌─────────────────┐
│ ✎ Email        │ (Purple border, 2px)
│                 │ (Background color changes)
```

### ModernExpandableCard Rotation
```
Collapsed: ▼  Title
Expanded:  ▲  Title  ← Icon rotates 180°
```

---

## 🔄 State Examples

### Loading Button
```
Before:  [💾 Save]
During:  [⏳ Saving...]
After:   [✅ Saved!]
```

### Input Field States
```
Empty:    [Email      ]
Focused:  [Email ✎    ] ← Color changes
Filled:   [Email ✉️user@example.com]
Error:    [Email ❌   ] ← Red state
```

---

## 💡 Tips Panel

| Tip | Remember |
|-----|----------|
| Spacing | Use SizedBox(height: 16) between elements |
| Colors | Purple = Primary, Red = Danger, Green = Success |
| Icons | Always add icons to buttons and tiles |
| Loading | Set isLoading: true on async operations |
| Glass | Use ModernGlassCard to group content |
| Background | Wrap screens in ModernGradientBackground |
| Input | Use ModernInputField for all text inputs |
| Profile | Use ModernProfilePicture for avatars |

---

## 🚀 Getting Started Checklist

- [ ] Import `modern_widgets.dart`
- [ ] Read `QUICK_REFERENCE.md`
- [ ] Pick a widget to use first
- [ ] Copy example code
- [ ] Customize colors
- [ ] Test on emulator
- [ ] Apply to other screens

---

**Your complete modern widget system is ready! 🎉**
