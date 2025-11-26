import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // تأكد من الاستيراد
import 'package:latlong2/latlong.dart';
import 'package:flocateapp/screens/device_model.dart';

class DeviceDetailScreen extends StatefulWidget {
  final DeviceModel device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  bool _notificationEnabled = true;
  bool _lostMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // فتح إعدادات متقدمة
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. قسم الخريطة وتاريخ المسار
            SizedBox(
              height: 250,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: widget.device.position,
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  // رسم مسار الحركة (History)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: widget.device.locationHistory.isNotEmpty 
                            ? widget.device.locationHistory 
                            : [widget.device.position],
                        strokeWidth: 4.0,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                    ],
                  ),
                  // علامة الجهاز الحالية
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: widget.device.position,
                        width: 60,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                          ),
                          child: Icon(Icons.location_history, color: Colors.red, size: 30),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. معلومات البطارية (يمكن استبدالها بمكتبة fl_chart لرسم بياني)
                  _buildSectionTitle("Pil Durumu (Battery Status)"),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Kalan Pil: %${widget.device.batteryLevel}", 
                              style: TextStyle(fontWeight: FontWeight.bold, color: widget.device.batteryColor)),
                            Text("Tahmini: 4 Gün", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // تمثيل بسيط للرسم البياني
                        LinearProgressIndicator(
                          value: widget.device.batteryLevel / 100,
                          backgroundColor: Colors.grey.shade200,
                          color: widget.device.batteryColor,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        const SizedBox(height: 8),
                        const Text("Son 24 Saat Kullanımı", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. الإجراءات السريعة
                  Row(
                    children: [
                      Expanded(child: _buildActionButton(Icons.notifications_active, "Ses Çal", Colors.orange)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildActionButton(Icons.directions, "Yol Tarifi", Colors.blue)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 4. الإعدادات والتنبيهات
                  _buildSectionTitle("Ayarlar & Bildirimler"),
                  SwitchListTile(
                    title: const Text("Beni Unuttuğunda Bildir"),
                    subtitle: const Text("Cihazdan uzaklaştığında uyarı al."),
                    value: _notificationEnabled,
                    activeColor: Colors.blue,
                    onChanged: (val) => setState(() => _notificationEnabled = val),
                  ),
                  SwitchListTile(
                    title: const Text("Kayıp Modu (Lost Mode)"),
                    subtitle: const Text("Cihaz kilitlenir ve iletişim bilgileri gösterilir."),
                    value: _lostMode,
                    activeColor: Colors.red,
                    onChanged: (val) => setState(() => _lostMode = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}