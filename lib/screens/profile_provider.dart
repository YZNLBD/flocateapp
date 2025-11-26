import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProfileProvider with ChangeNotifier {
  File? _profileImage;
  static const String _imagePathKey = 'profile_image_path';

  File? get profileImage => _profileImage;

  ProfileProvider() {
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_imagePathKey);
    if (imagePath != null) {
      _profileImage = File(imagePath);
      notifyListeners();
    }
  }

  Future<void> setProfileImage(File image) async {
    _profileImage = image;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imagePathKey, image.path);
    notifyListeners();
  }

  void clearProfileImage() async {
    _profileImage = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_imagePathKey);
    notifyListeners();
  }
}
