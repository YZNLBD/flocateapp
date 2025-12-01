import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart'; // مكتبة الربط
import 'package:url_launcher/url_launcher.dart';

// تأكد من صحة مسارات ملفاتك هنا
import 'package:flocateapp/screens/device_model.dart'; // تأكد من أن المسار models وليس screens إذا قمت بنقله
import 'package:flocateapp/screens/device_detail.dart';
import 'package:flocateapp/screens/devices_screen.dart';
import 'package:flocateapp/screens/device_provider.dart'; // أو المسار الصحيح للبروفايدر

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? userLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Konum servisi etkin değil');
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Konum izni reddedildi');
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Konum izni kalıcı olarak reddedildi');
        setState(() => _isLoading = false);
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          userLocation = LatLng(pos.latitude, pos.longitude);
          _isLoading = false;
        });
        _mapController.move(userLocation!, 15);
      }
    } catch (e) {
      _showSnackBar('Hata oluştu');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openGoogleMaps(double lat, double lng) async {
    final Uri googleMapsUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar('Google Maps açılamadı');
    }
  }

  void _showDeviceBottomSheet(DeviceModel device) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(device.icon, color: Colors.blue, size: 30),
                  const SizedBox(width: 10),
                  Text(device.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Icon(
                    device.batteryLevel > 20
                        ? Icons.battery_std
                        : Icons.battery_alert,
                    color: device.batteryColor,
                  ),
                  Text("%${device.batteryLevel}"),
                ],
              ),
              const SizedBox(height: 10),
              Text("Durum: ${device.isActive ? 'Aktif' : 'Pasif'}",
                  style: const TextStyle(color: Colors.grey)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _openGoogleMaps(
                        device.position.latitude, device.position.longitude);
                  },
                  icon: const Icon(Icons.map, color: Colors.white),
                  label: const Text("Google Maps'te Aç",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeviceDetailScreen(
                          device: device,
                          // ربط الحذف بالبروفايدر
                          onDelete: (id) => Provider.of<DeviceProvider>(context, listen: false).deleteDevice(id),
                          // ربط التعديل بالبروفايدر
                          onRename: (id, newName) => Provider.of<DeviceProvider>(context, listen: false).renameDevice(id, newName),
                        ),
                      ),
                    );
                  },
                  child: const Text("Detayları Gör"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. جلب البيانات من البروفايدر (البيانات الحقيقية)
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final devices = deviceProvider.devices;

    // 2. تحويل البيانات لعلامات
    List<Marker> deviceMarkers = devices.map((device) {
      return Marker(
        point: device.position,
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showDeviceBottomSheet(device),
          child: Column(
            children: [
              Icon(
                device.icon, // استخدام أيقونة الموديل
                color: device.isActive
                    ? const Color.fromARGB(255, 229, 30, 30)
                    : const Color.fromARGB(255, 198, 89, 31),
                size: 45,
                shadows: const [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 5,
                      offset: Offset(0, 2))
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  device.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      );
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: const Text("Harita",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 76, 74, 74))),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 3,
              shadowColor: Colors.black.withOpacity(0.2),
              iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    _buildMenuItem(
                        "settings", Icons.settings, "Ayarlar", Colors.blue),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  userLocation ?? const LatLng(39.925533, 32.866287),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.flocateapp',
              ),
              
              // 3. طبقة المناطق الآمنة (الدوائر) - تضاف قبل العلامات
              CircleLayer(
                circles: devices
                    .where((d) => d.isSafeZoneEnabled && d.safeZoneCenter != null)
                    .map((d) {
                  return CircleMarker(
                    point: d.safeZoneCenter!,
                    radius: d.safeZoneRadius,
                    useRadiusInMeter: true, // استخدام المتر الحقيقي
                    color: Colors.green.withOpacity(0.2), // شفافية خفيفة
                    borderColor: Colors.green, // حدود خضراء
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),

              // 4. طبقة العلامات
              MarkerLayer(markers: [
                if (userLocation != null)
                  Marker(
                    point: userLocation!,
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.my_location,
                        color: Colors.blue, size: 30),
                  ),
                ...deviceMarkers,
              ]),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "listBtn",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DevicesScreen()),
              );
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.list, color: Colors.black),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "locBtn",
            onPressed: _getUserLocation,
            backgroundColor: Colors.blue.shade600,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      String value, IconData icon, String text, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}