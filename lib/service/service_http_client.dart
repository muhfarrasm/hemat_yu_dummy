// lib/service/service_http_client.dart
import 'dart:convert';
import 'package:hematyu_app_dummy_fix/service/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServiceHttpClient {
  final _client = http.Client();
  final SecureStorageService _storage = SecureStorageService();
  final String baseUrl = 'http://10.0.2.2:8000/api';

  SecureStorageService get storage => _storage;
  Future<Map<String, String>> _getHeaders({bool authorized = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authorized) {
      final token = await _storage.getToken(); // 🔥 Pakai getToken()
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> post(
    String path,
    dynamic body, {
    bool authorized = false,
  }) async {
    return await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: await _getHeaders(authorized: authorized),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(String path, {bool authorized = false}) async {
    return await _client.get(
      Uri.parse('$baseUrl$path'),
      headers: await _getHeaders(authorized: authorized),
    );
  }

  Future<void> clearToken() async => await _storage.clearToken();

  // FlutterSecureStorage get storage => _storage;
}
