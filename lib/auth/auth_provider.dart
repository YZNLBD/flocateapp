import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService api = ApiService();
  String? accessToken;

  Future<bool> login(String username, String password) async {
    final success = await api.login(username, password);

    if (success) {
      accessToken = api.accessToken;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', api.accessToken!);
      await prefs.setString('refresh', api.refreshToken!);

      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access');
    api.accessToken = prefs.getString('access');
    api.refreshToken = prefs.getString('refresh');
    notifyListeners();
  }

  bool get isLoggedIn => accessToken != null;

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access');
    await prefs.remove('refresh');
    accessToken = null;
    notifyListeners();
  }
}
