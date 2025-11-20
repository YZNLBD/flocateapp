import 'package:flocateapp/screens/home_controller.dart';
import 'package:flocateapp/screens/profiles/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Widget> _screens = const [
    Center(child: Text("Home Page")),
    Center(child: Text("Technicians Page")),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Banshara")),
      body: _screens[controller.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.currentIndex,
        onTap: controller.changeTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Technicians",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
