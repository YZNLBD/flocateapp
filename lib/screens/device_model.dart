import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DeviceModel {
  final String id;
  String name;
  final String deviceType;
  int batteryLevel;
  bool isConnected; // عدنا لاستخدام هذا الاسم ليتوافق مع باقي كودك
  DateTime lastSeen;
  LatLng position;
  List<LatLng> locationHistory;

  // --- متغيرات المنطقة الآمنة (Safe Zone) ---
  bool isSafeZoneEnabled;
  LatLng? safeZoneCenter;
  double safeZoneRadius;

  // خاصية مساعدة للتوافق (اذا استخدمت isActive بالخطأ في مكان ما)
  bool get isActive => isConnected;

  DeviceModel({
    required this.id,
    required this.name,
    this.deviceType = 'generic',
    required this.batteryLevel,
    required this.isConnected,
    required this.lastSeen,
    required this.position,
    this.locationHistory = const [],
    this.isSafeZoneEnabled = false,
    this.safeZoneCenter,
    this.safeZoneRadius = 100.0,
  });

  // أيقونة الجهاز
  IconData get icon {
    switch (deviceType.toLowerCase()) {
      case 'vehicle': return Icons.directions_car;
      case 'personal': return Icons.person_pin_circle;
      case 'asset': return Icons.local_mall;
      case 'pet': return Icons.pets;
      default: return Icons.gps_fixed;
    }
  }

  // لون البطارية
  Color get batteryColor {
    if (batteryLevel > 50) return Colors.green;
    if (batteryLevel > 20) return Colors.orange;
    return Colors.red;
  }

  // --- التحويل من Map (يدعم Firebase و JSON المحلي) ---
  factory DeviceModel.fromMap(Map<String, dynamic> data) {
    // 1. معالجة الموقع
    LatLng pos = const LatLng(39.93, 32.85);
    if (data['location'] != null && data['location'] is GeoPoint) {
      // قادم من Firebase
      final GeoPoint geo = data['location'];
      pos = LatLng(geo.latitude, geo.longitude);
    } else if (data['lat'] != null && data['lng'] != null) {
      // قادم من JSON محلي
      pos = LatLng(data['lat'], data['lng']);
    }

    // 2. معالجة المنطقة الآمنة
    LatLng? safeCenter;
    if (data['safe_zone_center'] != null) {
      if (data['safe_zone_center'] is GeoPoint) {
        final GeoPoint p = data['safe_zone_center'];
        safeCenter = LatLng(p.latitude, p.longitude);
      } else if (data['safe_center_lat'] != null) {
        safeCenter = LatLng(data['safe_center_lat'], data['safe_center_lng']);
      }
    } else if (data['safe_center_lat'] != null) {
       safeCenter = LatLng(data['safe_center_lat'], data['safe_center_lng']);
    }

    // 3. معالجة التاريخ
    DateTime lastSeenDate = DateTime.now();
    if (data['last_updated'] != null) {
      if (data['last_updated'] is Timestamp) {
        lastSeenDate = (data['last_updated'] as Timestamp).toDate();
      } else {
        lastSeenDate = DateTime.tryParse(data['last_updated'].toString()) ?? DateTime.now();
      }
    } else if (data['lastSeen'] != null) {
       lastSeenDate = DateTime.tryParse(data['lastSeen'].toString()) ?? DateTime.now();
    }

    return DeviceModel(
      id: data['device_id'] ?? data['id'] ?? '',
      name: data['name'] ?? 'Unknown',
      deviceType: data['device_type'] ?? 'generic',
      batteryLevel: data['battery_level'] ?? data['batteryLevel'] ?? 0,
      // هنا ندعم الاسمين
      isConnected: data['is_active'] ?? data['isConnected'] ?? false,
      lastSeen: lastSeenDate,
      position: pos,
      locationHistory: [pos], 
      isSafeZoneEnabled: data['safe_zone_enabled'] ?? false,
      safeZoneRadius: (data['safe_zone_radius'] ?? 100.0).toDouble(),
      safeZoneCenter: safeCenter,
    );
  }

  // --- التحويل إلى Map (للحفظ) ---
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'device_id': id, // للحفاظ على التوافق
      'name': name,
      'device_type': deviceType,
      'batteryLevel': batteryLevel,
      'battery_level': batteryLevel,
      'isConnected': isConnected,
      'is_active': isConnected, // نحفظ النسختين
      'lastSeen': lastSeen.toIso8601String(),
      'last_updated': lastSeen.toIso8601String(), // للـ JSON المحلي
      
      // الموقع بصيغة بسيطة
      'lat': position.latitude,
      'lng': position.longitude,
      
      // المنطقة الآمنة
      'safe_zone_enabled': isSafeZoneEnabled,
      'safe_zone_radius': safeZoneRadius,
      'safe_center_lat': safeZoneCenter?.latitude,
      'safe_center_lng': safeZoneCenter?.longitude,
    };
  }

  String toJson() => json.encode(toMap());

  factory DeviceModel.fromJson(String source) => DeviceModel.fromMap(json.decode(source));
}