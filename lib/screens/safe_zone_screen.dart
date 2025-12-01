import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flocateapp/screens/device_model.dart'; // تأكد أن المسار صحيح للموديل

class SafeZoneScreen extends StatefulWidget {
  final DeviceModel device;

  const SafeZoneScreen({super.key, required this.device});

  @override
  State<SafeZoneScreen> createState() => _SafeZoneScreenState();
}

class _SafeZoneScreenState extends State<SafeZoneScreen> {
  late LatLng _center;
  late double _radius;
  late bool _isEnabled;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // إذا كانت هناك منطقة محفوظة نستخدمها، وإلا نستخدم موقع الجهاز الحالي كبداية
    _center = widget.device.safeZoneCenter ?? widget.device.position;
    _radius = widget.device.safeZoneRadius;
    _isEnabled = widget.device.isSafeZoneEnabled;
  }

  // دالة الحفظ في Firebase
  Future<void> _saveSafeZone() async {
    try {
      await FirebaseFirestore.instance
          .collection('devices')
          .doc(widget.device.id)
          .update({
        'safe_zone_enabled': _isEnabled,
        'safe_zone_radius': _radius,
        // تحويل LatLng إلى GeoPoint الخاص بفايربيس
        'safe_zone_center': GeoPoint(_center.latitude, _center.longitude),
        'last_updated': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context); // الرجوع للخلف
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Güvenli Bölge Kaydedildi (Safe Zone Saved)")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Güvenli Bölge Ayarla"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. الخريطة
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 15,
                // عند الضغط على الخريطة، ننقل مركز الدائرة إلى مكان الضغط
                onTap: (tapPosition, point) {
                  setState(() {
                    _center = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                // رسم الدائرة (المنطقة الآمنة)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _center,
                      color: _isEnabled 
                          ? Colors.green.withOpacity(0.3) 
                          : Colors.grey.withOpacity(0.3),
                      borderColor: _isEnabled ? Colors.green : Colors.grey,
                      borderStrokeWidth: 2,
                      radius: _radius, 
                      useRadiusInMeter: true, // مهم جداً: لجعل الدائرة بالمتر الحقيقي
                    ),
                  ],
                ),
                // رسم أيقونة المركز وأيقونة الجهاز
                MarkerLayer(
                  markers: [
                    // 1. مركز المنطقة الآمنة (علم)
                    Marker(
                      point: _center,
                      width: 40, height: 40,
                      child: const Icon(Icons.flag, color: Colors.red, size: 40),
                    ),
                    // 2. موقع الجهاز الحالي (شفاف قليلاً للمقارنة)
                    Marker(
                      point: widget.device.position,
                      width: 40, height: 40,
                      child: const Icon(Icons.gps_fixed, color: Colors.blue, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. أدوات التحكم (في الأسفل)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // مفتاح التفعيل
                SwitchListTile(
                  title: const Text("Güvenli Bölgeyi Aktif Et", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Cihaz bu alanın dışına çıkarsa bildirim alırsınız."),
                  value: _isEnabled,
                  activeColor: Colors.green,
                  onChanged: (val) => setState(() => _isEnabled = val),
                ),
                const Divider(),
                
                // شريط التحكم بنصف القطر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Yarıçap (Radius):"),
                    Text("${_radius.toInt()} metre", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
                Slider(
                  value: _radius,
                  min: 50,   // أقل شيء 50 متر
                  max: 5000, // أكثر شيء 5 كيلومتر
                  divisions: 100,
                  activeColor: Colors.blue,
                  label: "${_radius.toInt()}m",
                  onChanged: (val) => setState(() => _radius = val),
                ),
                
                const SizedBox(height: 10),
                
                // زر الحفظ
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _saveSafeZone,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text("Kaydet (Save)", style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}