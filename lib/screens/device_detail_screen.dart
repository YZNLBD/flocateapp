import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flocateapp/screens/device_model.dart';
import 'package:flocateapp/screens/safe_zone_screen.dart'; 

class DeviceDetailScreen extends StatefulWidget {
  final DeviceModel device;
  final Function(String id) onDelete;
  final Function(String id, String newName) onRename;

  const DeviceDetailScreen({
    super.key,
    required this.device,
    required this.onDelete,
    required this.onRename,
  });

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  late String _currentName;
  bool _notificationEnabled = true;
  bool _lostMode = false;

  @override
  void initState() {
    super.initState();
    _currentName = widget.device.name;
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cihazı Sil"),
        content: Text(
            "$_currentName adlı cihazı silmek istediğinize emin misiniz? Bu işlem geri alınamaz."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("İptal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              widget.onDelete(widget.device.id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Cihaz başarıyla silindi.")),
              );
            },
            child: const Text("Sil",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: _currentName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cihaz Adını Düzenle"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: "Yeni Ad (New Name)",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("İptal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _currentName = nameController.text;
                });
                widget.onRename(widget.device.id, nameController.text);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("İsim güncellendi.")),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Kaydet", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentName),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete(context);
              } else if (value == 'edit') {
                _showEditNameDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("Düzenle"),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 10),
                      Text("Cihazı Sil", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: widget.device.position,
                        width: 60,
                        height: 60,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(blurRadius: 10, color: Colors.black26)
                            ],
                          ),
                          child: const Icon(Icons.location_history,
                              color: Colors.red, size: 30),
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
                  _buildSectionTitle("Pil Durumu (Battery Status)"),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade200, blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Kalan Pil: %${widget.device.batteryLevel}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: widget.device.batteryColor)),
                            const Text("Tahmini: 4 Gün",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: widget.device.batteryLevel / 100,
                          backgroundColor: Colors.grey.shade200,
                          color: widget.device.batteryColor,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        const SizedBox(height: 8),
                        const Text("Son 24 Saat Kullanımı",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // --- أزرار التحكم (تم تعديلها لتشمل زر المنطقة الآمنة) ---
                  Row(
                    children: [
                      Expanded(
                          child: _buildActionButton(Icons.notifications_active,
                              "Ses Çal", Colors.orange)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _buildActionButton(
                              Icons.directions, "Yol Tarifi", Colors.blue)),
                      const SizedBox(width: 10),
                      // 👇 زر المنطقة الآمنة الجديد 👇
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SafeZoneScreen(device: widget.device),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Column( // استخدمت Column لتنسيق الأيقونة والنص
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.security, color: Colors.white),
                              Text("Güvenli", // اختصار للنص ليناسب المساحة
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // -------------------------------------------------------

                  const SizedBox(height: 20),
                  _buildSectionTitle("Ayarlar & Bildirimler"),
                  SwitchListTile(
                    title: const Text("Beni Unuttuğunda Bildir"),
                    subtitle: const Text("Cihazdan uzaklaştığında uyarı al."),
                    value: _notificationEnabled,
                    activeThumbColor: Colors.blue,
                    onChanged: (val) =>
                        setState(() => _notificationEnabled = val),
                  ),
                  SwitchListTile(
                    title: const Text("Kayıp Modu (Lost Mode)"),
                    subtitle: const Text(
                        "Cihaz kilitlenir ve iletişim bilgileri gösterilir."),
                    value: _lostMode,
                    activeThumbColor: Colors.red,
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
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column( // استخدام Column بدل Row لتوفير المساحة الأفقية
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}