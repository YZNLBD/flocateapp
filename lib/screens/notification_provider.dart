import 'package:flutter/material.dart';
import 'dart:math';
import 'notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(id: '1', title: "Düşük Pil", body: "Cihaz 'Çocuk İzle' pili %15 seviyesinde.", timestamp: DateTime.now().subtract(const Duration(minutes: 10)),),
    NotificationModel(id: '2', title: "Bağlantı Koptu", body: "Cihaz 'Araba Anahtarı' ile bağlantı koptu.", timestamp: DateTime.now().subtract(const Duration(hours: 1)), isRead: true),
    NotificationModel(id: '3', title: "Güvenli Alandan Ayrıldı", body: "Cihaz 'Evcil Hayvan' güvenli alandan ayrıldı.", timestamp: DateTime.now().subtract(const Duration(hours: 3)),),
    NotificationModel(id: '4', title: "Acil Durum", body: "Cihaz 'Yaşlı Takip' acil durum sinyali gönderdi.", timestamp: DateTime.now().subtract(const Duration(days: 1)), isRead: true),
    NotificationModel(id: '5', title: "Düşük Pil", body: "Cihaz 'Laptop Çantası' pili %20 seviyesinde.", timestamp: DateTime.now().subtract(const Duration(days: 2)), isRead: true),
  ];

  List<NotificationModel> get notifications => _notifications..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  int get totalCount => _notifications.length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }
  
  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  void addRandomNotification() {
    final random = Random();
    final titles = ["Düşük Pil", "Bağlantı Koptu", "Güvenli Alan", "Yeni Mesaj"];
    final bodies = ["Pil seviyesi kritik.", "Cihaz çevrimdışı.", "Tehlikeli bir bölgeye girildi.", "Bir yakınınız size mesaj gönderdi."];
    
    _notifications.add(NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titles[random.nextInt(titles.length)],
      body: bodies[random.nextInt(bodies.length)],
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }
}
