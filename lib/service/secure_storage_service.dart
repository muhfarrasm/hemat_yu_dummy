import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Simpan token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    print('💾 Token saved: $token');
  }

  // Ambil token
  Future<String?> getToken() async {
    final token = await _storage.read(key: _tokenKey);
    print('🔐 Token from storage: $token');
    return token;
  }

  // Hapus token
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    print('🗑️ Token cleared from storage');
  }
}
