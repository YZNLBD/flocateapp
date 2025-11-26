import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DeviceModel {
  final String id;
  String name; // لم تعد final لنسمح بتعديل الاسم
  int batteryLevel;
  bool isConnected;
  DateTime lastSeen;
  LatLng position;
  List<LatLng> locationHistory;

  DeviceModel({
    required this.id,
    required this.name,
    required this.batteryLevel,
    required this.isConnected,
    required this.lastSeen,
    required this.position,
    this.locationHistory = const [],
  });

  Color get batteryColor {
    if (batteryLevel > 50) return Colors.green;
    if (batteryLevel > 20) return Colors.orange;
    return Colors.red;
  }

  // 1. تحويل البيانات إلى خريطة (Map) للحفظ
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'batteryLevel': batteryLevel,
      'isConnected': isConnected,
      'lastSeen': lastSeen.toIso8601String(),
      'lat': position.latitude, // نحفظ الإحداثيات منفصلة
      'lng': position.longitude,
    };
  }

  // 2. إنشاء كائن من البيانات المحفوظة
  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      id: map['id'],
      name: map['name'],
      batteryLevel: map['batteryLevel'],
      isConnected: map['isConnected'],
      lastSeen: DateTime.parse(map['lastSeen']),
      position: LatLng(map['lat'], map['lng']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceModel.fromJson(String source) => DeviceModel.fromMap(json.decode(source));
}