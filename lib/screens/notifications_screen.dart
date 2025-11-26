import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'notification_provider.dart';
import 'notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bildirimler", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 76, 74, 74))),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => Provider.of<NotificationProvider>(context, listen: false).clearAll(),
            tooltip: "Tümünü Temizle",
          )
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildSummaryCard(provider),
              Expanded(
                child: provider.notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade300),
                            const Text("Yeni bildirim yok", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.notifications.length,
                        itemBuilder: (context, index) {
                          final notification = provider.notifications[index];
                          return _buildNotificationCard(context, notification, provider);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<NotificationProvider>(context, listen: false).addRandomNotification(),
        backgroundColor: Colors.blue.shade700,
        tooltip: "Rastgele Bildirim Ekle",
        child: const Icon(Icons.add_alert, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard(NotificationProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("Toplam", provider.totalCount.toString(), Icons.notifications),
          Container(width: 1, height: 40, color: Colors.white30),
          _buildStatItem("Okunmamış", provider.unreadCount.toString(), Icons.mark_email_unread, color: Colors.amberAccent),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.white, size: 24),
        const SizedBox(height: 5),
        Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationModel notification, NotificationProvider provider) {
    final timeAgo = formatTimeAgo(notification.timestamp);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias, // Ensures the InkWell ripple is clipped
      color: notification.color,
      child: InkWell(
        onTap: () => provider.markAsRead(notification.id),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Leading Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(notification.icon, color: notification.isRead ? Colors.grey : Colors.blue.shade700, size: 24),
              ),
              const SizedBox(width: 16),
              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.title, style: TextStyle(fontWeight: FontWeight.bold, color: notification.isRead ? Colors.grey.shade600 : Colors.black)),
                    const SizedBox(height: 4),
                    Text(notification.body, style: TextStyle(color: notification.isRead ? Colors.grey.shade500 : Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Trailing Section
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(timeAgo, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  InkResponse(
                    onTap: () => provider.deleteNotification(notification.id),
                    child: const Icon(Icons.delete_outline, size: 25, color: Colors.redAccent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String formatTimeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inDays > 1) {
      return DateFormat('dd/MM/yy').format(time);
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}s önce';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}d önce';
    } else {
      return 'şimdi';
    }
  }
}
