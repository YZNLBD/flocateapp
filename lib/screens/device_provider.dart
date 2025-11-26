import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'device_model.dart';
import 'package:latlong2/latlong.dart'; // لإضافة موقع افتراضي عند الإنشاء

class DeviceProvider with ChangeNotifier {
  List<DeviceModel> _devices = [];

  List<DeviceModel> get devices => _devices;

  // إحصائيات للبوكس العلوي
  int get totalDevices => _devices.length;
  int get connectedCount => _devices.where((d) => d.isConnected).length;
  int get disconnectedCount => _devices.where((d) => !d.isConnected).length;

  DeviceProvider() {
    loadDevices(); // تحميل البيانات فور تشغيل التطبيق
  }

  // --- دوال التحكم ---

  // إضافة جهاز
  void addDevice(String name, String id) {
    final newDevice = DeviceModel(
      id: id,
      name: name,
      batteryLevel: 100, // افتراضي
      isConnected: true, // افتراضي
      lastSeen: DateTime.now(),
      position: LatLng(39.93, 32.85), // موقع افتراضي (أنقرة مثلاً)
    );
    
    _devices.add(newDevice);
    notifyListeners(); // تحديث الواجهات
    _saveToPrefs();    // حفظ في الكاش
  }

  // حذف جهاز
  void deleteDevice(String id) {
    _devices.removeWhere((element) => element.id == id);
    notifyListeners();
    _saveToPrefs();
  }

  // تعديل اسم جهاز
  void renameDevice(String id, String newName) {
    final index = _devices.indexWhere((d) => d.id == id);
    if (index != -1) {
      _devices[index].name = newName;
      notifyListeners();
      _saveToPrefs();
    }
  }

  // --- دوال التخزين (SharedPreferences) ---

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // تحويل قائمة الأجهزة إلى قائمة نصوص JSON
    List<String> listJson = _devices.map((d) => d.toJson()).toList();
    await prefs.setStringList('saved_devices', listJson);
  }

  Future<void> loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? listJson = prefs.getStringList('saved_devices');

    if (listJson != null) {
      _devices = listJson.map((item) => DeviceModel.fromJson(item)).toList();
      notifyListeners();
    }
  }
}