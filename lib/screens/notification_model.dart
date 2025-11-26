import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  // أيقونة بناءً على نوع الإشعار (مثال)
  IconData get icon {
    if (title.toLowerCase().contains('düşük pil')) {
      return Icons.battery_alert;
    } else if (title.toLowerCase().contains('bağlantı')) {
      return Icons.wifi_off;
    }
    return Icons.notifications;
  }

  // لون لتمييز الإشعارات
  Color get color {
    if (isRead) {
      return Colors.grey.shade400;
    }
    if (title.toLowerCase().contains('acil')) {
      return Colors.red.shade100;
    }
    return Colors.blue.shade50;
  }
}
