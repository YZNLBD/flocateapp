// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ضع هنا رابط ngrok الذي أرسلك المهندس
  static const String baseUrl = "https://floria-unpresuming-unwomanly.ngrok-free.dev";

  String? accessToken;
  String? refreshToken;

  // Paths (عدّلها إذا backend يستخدم مسارات مختلفة)
  final String loginPath = "/api/token/";
  final String refreshPath = "/api/token/refresh/";
  final String devicesPath = "/devices/";
  final String registerPath = "/register"; // قد تحتاج لتعديل المسار إذا backend مختلف
  final String personsPath = "/persons/";
  final String geofencesPath = "/geofences/";
  final String alarmsPath = "/alarms/";
  final String forgotPasswordPath = "/password/reset/";

  // Helper: POST request JSON
  Future<Map<String, dynamic>> _postJson(String path, Map body, {Map<String, String>? headers}) async {
    final url = Uri.parse("$baseUrl$path");
    try {
      final resp = await http.post(
        url,
        headers: headers ?? {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final decoded = resp.body.isNotEmpty ? jsonDecode(resp.body) : null;

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return {"status": "success", "code": resp.statusCode, "data": decoded};
      } else {
        String message = "Request failed: ${resp.statusCode}";
        if (decoded != null) {
          if (decoded is Map && decoded.containsKey('detail')) {
            message = decoded['detail'].toString();
          } else if (decoded is Map && decoded.containsKey('message')) {
            message = decoded['message'].toString();
          } else if (decoded is Map) {
            message = decoded.values.join(' | ');
          } else if (decoded is String) {
            message = decoded;
          }
        }
        return {"status": "error", "code": resp.statusCode, "message": message, "data": decoded};
      }
    } catch (e) {
      return {"status": "error", "message": "Exception: ${e.toString()}"};
    }
  }

  // -------------------------
  // LOGIN → set accessToken & refreshToken
  // -------------------------
  /// Returns true if login succeeded and tokens saved.
  Future<bool> login(String username, String password) async {
    final body = {"username": username, "password": password};
    final res = await _postJson(loginPath, body);

    if (res["status"] == "success" && res["data"] != null) {
      final data = res["data"];
      // backend REST example earlier returns { "refresh": "...", "access": "..." }
      if (data is Map && data.containsKey("access")) {
        accessToken = data["access"]?.toString();
        refreshToken = data["refresh"]?.toString();
        return true;
      } else {
        // إذا الbackend يعيد هيكل مختلف، حاول استخراج أي توكن ممكن
        if (data is Map && (data.containsKey("token") || data.containsKey("access_token"))) {
          accessToken = (data["access_token"] ?? data["token"]).toString();
          // refresh قد لا تكون موجودة
          refreshToken = data["refresh"]?.toString();
          return true;
        }
      }
    }

    return false;
  }

  // -------------------------
  // REFRESH accessToken
  // -------------------------
  Future<bool> refreshAccessToken() async {
    if (refreshToken == null) return false;

    final res = await _postJson(refreshPath, {"refresh": refreshToken});
    if (res["status"] == "success" && res["data"] != null) {
      final data = res["data"];
      if (data is Map && data.containsKey("access")) {
        accessToken = data["access"]?.toString();
        return true;
      } else if (data is Map && data.containsKey("access_token")) {
        accessToken = data["access_token"]?.toString();
        return true;
      }
    }
    return false;
  }

  // Helper headers
  Map<String, String> get authHeaders {
    final h = {"Content-Type": "application/json"};
    if (accessToken != null) {
      h["Authorization"] = "Bearer $accessToken";
    }
    return h;
  }

  // -------------------------
  // GET DEVICES
  // -------------------------
  Future<List<dynamic>> getDevices() async {
    final url = Uri.parse("$baseUrl$devicesPath");
    try {
      final resp = await http.get(url, headers: authHeaders);
      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);
        if (decoded is List) return decoded;
        // لو الbackend يعيد object: return decoded['results'] ?? []
        if (decoded is Map && decoded.containsKey('results')) {
          return decoded['results'] as List<dynamic>;
        }
      } else if (resp.statusCode == 401) {
        final ok = await refreshAccessToken();
        if (ok) return getDevices();
      }
    } catch (e) {
      rethrow;
    }
    throw Exception("Failed to load devices");
  }

  // -------------------------
  // ADD DEVICE
  // -------------------------
  Future<bool> addDevice(Map<String, dynamic> device) async {
    final res = await _postJson(devicesPath, device, headers: authHeaders);
    if (res["status"] == "success") return true;
    if (res["code"] == 401) {
      final ok = await refreshAccessToken();
      if (ok) return addDevice(device);
    }
    return false;
  }

  // -------------------------
  // ADD PERSON
  // -------------------------
  Future<bool> addPerson(Map<String, dynamic> person) async {
    final res = await _postJson(personsPath, person, headers: authHeaders);
    if (res["status"] == "success") return true;
    return false;
  }

  // -------------------------
  // ADD GEOFENCE
  // -------------------------
  Future<bool> addGeofence(Map<String, dynamic> geofence) async {
    final res = await _postJson(geofencesPath, geofence, headers: authHeaders);
    if (res["status"] == "success") return true;
    return false;
  }

  // -------------------------
  // ADD ALARM
  // -------------------------
  Future<bool> addAlarm(Map<String, dynamic> alarm) async {
    final res = await _postJson(alarmsPath, alarm, headers: authHeaders);
    if (res["status"] == "success") return true;
    return false;
  }

  // -------------------------
  // REGISTER (fallback: used by RegisterScreen if backend supports it)
  // -------------------------
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final body = {
      "username": username,
      "email": email,
      "password": password,
    };
    return await _postJson(registerPath, body);
  }

  // -------------------------
  // FORGOT PASSWORD
  // -------------------------
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return await _postJson(forgotPasswordPath, {"email": email});
  }
}
