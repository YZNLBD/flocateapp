import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Profile Page"),

          Checkbox(
            value: true,
            onChanged: (value) {
              // Respond to checkbox state change
            },
          ),
          ElevatedButton(
            onPressed: () {
              print("Button geklickt");
            },
            child: const Text("Mein Button"),
          ),
        ],
      ),
    );
  }
}
