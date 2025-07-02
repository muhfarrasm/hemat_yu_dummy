import 'dart:convert';
import 'package:hematyu_app_dummy_fix/data/model/request/auth/login_request_model.dart';
import 'package:hematyu_app_dummy_fix/data/model/request/auth/register_request_model.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/auth/login_response_model.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/auth/register_response_model.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/auth/me_response_model.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

class AuthRepository {
  final ServiceHttpClient httpClient;

  AuthRepository(this.httpClient);

  /// 🔐 Login
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await httpClient.post('/auth/login', request.toMap());
    try {
      final decoded = json.decode(response.body);

      print('📥 Response Body: ${response.body}');
      print('📥 Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final token = decoded['data']['token'];
        if (token != null) {
          print("✅ Token dari server: $token");

          // 🔐 Simpan token ke storage
          await httpClient.storage.saveToken(token);
          final savedToken = await httpClient.storage.getToken();
          print("🔐 Token tersimpan di storage: $savedToken");
        } else {
          print("⚠️ Token tidak ditemukan di response");
          throw Exception("Token tidak ditemukan dalam response");
        }

        return LoginResponseModel.fromMap(decoded);
      } else {
        throw Exception(decoded['message'] ?? 'Login gagal');
      }
    } catch (e) {
      print("❌ Login gagal: $e");
      throw Exception('Login response tidak valid: $e');
    }
  }

  /// 📝 Register
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    final response = await httpClient.post('/auth/register', request.toMap());

    print('📥 Register Response Status Code: ${response.statusCode}');
    print('📥 Register Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final jsonResponse = json.decode(response.body);
        return RegisterResponseModel.fromMap(jsonResponse);
      } catch (e) {
        print('❌ Register parsing error: $e');
        throw Exception('Gagal parsing response');
      }
    } else {
      throw Exception('Register gagal: ${response.statusCode}');
    }
  }

  /// 👤 Get Profil User (me)
  Future<MeResponseModel> getMe() async {
    final response = await httpClient.get('/auth/me', authorized: true);

    print("📡 Memuat profil user...");
    print("📥 Status code: ${response.statusCode}");
    print("📥 Body: ${response.body}");

    try {
      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        return MeResponseModel.fromMap(decoded);
      } else {
        throw Exception(decoded['message'] ?? 'Gagal mengambil profil');
      }
    } catch (e) {
      print('❌ Error parsing getMe: $e');
      throw Exception('Response getMe tidak valid: $e');
    }
  }

  /// 🔓 Logout
  Future<void> logout() async {
    await httpClient.clearToken();
    print("🚪 Token dihapus, logout berhasil");
  }

  /// Optional: akses storage dari luar jika dibutuhkan
  get storageService => httpClient.storage;
}
