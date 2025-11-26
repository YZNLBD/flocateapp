import 'package:flutter/material.dart';
import 'package:flocateapp/screens/map_screen.dart';
import 'package:flocateapp/screens/devices_screen.dart';
import 'package:flocateapp/screens/notifications_screen.dart';
import 'package:flocateapp/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    MapScreen(),
    DevicesScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red.shade400,
        unselectedItemColor: const Color.fromARGB(255, 76, 74, 74),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Harita'),
          BottomNavigationBarItem(icon: Icon(Icons.devices_other_rounded), label: 'Cihazlar'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active_outlined), label: 'Bildirimler'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: 'Profil'),
        ],
      ),
    );
  }
}
