import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'device_provider.dart'; // تأكد أن المسار صحيح
import 'device_detail.dart';   // تأكد أن المسار صحيح
import 'device_model.dart';    // تأكد أن المسار صحيح

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم Consumer للاستماع للتغييرات (إضافة/حذف) وتحديث الشاشة تلقائياً
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cihazlarım", style: TextStyle(fontWeight: FontWeight.bold , color: Color.fromARGB(255, 76, 74, 74))),
        centerTitle: true,
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // 1. البوكس المستطيل العلوي (الإحصائيات)
              _buildSummaryCard(provider),

              // 2. قائمة الأجهزة
              Expanded(
                child: provider.devices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.devices_other, size: 80, color: Colors.grey.shade300),
                            const SizedBox(height: 10),
                            const Text("Cihaz bulunamadı (No Devices)", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.devices.length,
                        itemBuilder: (context, index) {
                          final device = provider.devices[index];
                          return _buildDeviceCard(context, device);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDeviceModal(context),
        label: const Text("Cihaz Ekle", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  // --- تصميم بوكس الإحصائيات العلوي ---
  Widget _buildSummaryCard(DeviceProvider provider) {
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
          _buildStatItem("Toplam", provider.totalDevices.toString(), Icons.devices), // المجموع
          Container(width: 1, height: 40, color: Colors.white30), // خط فاصل
          _buildStatItem("Bağlı", provider.connectedCount.toString(), Icons.wifi, color: Colors.greenAccent), // متصل
          Container(width: 1, height: 40, color: Colors.white30),
          _buildStatItem("Kopuk", provider.disconnectedCount.toString(), Icons.wifi_off, color: Colors.orangeAccent), // غير متصل
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

  // --- تصميم كارت الجهاز في القائمة ---
  Widget _buildDeviceCard(BuildContext context, DeviceModel device) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          // الانتقال للتفاصيل
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeviceDetailScreen(
                device: device,
                // نمرر دوال التعامل مع البروفايدر للحذف والتعديل
                onDelete: (id) => Provider.of<DeviceProvider>(context, listen: false).deleteDevice(id),
                onRename: (id, name) => Provider.of<DeviceProvider>(context, listen: false).renameDevice(id, name),
              ),
            ),
          );
        },
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: device.isConnected ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.gps_fixed, color: device.isConnected ? Colors.blue : Colors.grey),
        ),
        title: Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          device.isConnected ? "Çevrimiçi (Online)" : "Son: ${DateFormat('HH:mm').format(device.lastSeen)}",
          style: TextStyle(color: device.isConnected ? Colors.green : Colors.grey, fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.battery_std, color: device.batteryColor, size: 20),
            Text("%${device.batteryLevel}", style: TextStyle(color: device.batteryColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // --- نافذة إضافة جهاز جديد ---
  void _showAddDeviceModal(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController idController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Yeni Cihaz Ekle", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(controller: idController, decoration: const InputDecoration(labelText: "Cihaz ID", border: OutlineInputBorder(), prefixIcon: Icon(Icons.qr_code))),
            const SizedBox(height: 10),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Cihaz Adı", border: OutlineInputBorder(), prefixIcon: Icon(Icons.edit))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50, // ارتفاع الزر
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && idController.text.isNotEmpty) {
                    // *** هنا يتم الحفظ الفعلي عبر البروفايدر ***
                    Provider.of<DeviceProvider>(context, listen: false).addDevice(nameController.text, idController.text);
                    Navigator.pop(ctx); // إغلاق النافذة
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700, 
                  foregroundColor: Colors.white // لون النص والأيقونة أبيض
                ),
                child: const Text("Eşleştir (Pair)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}